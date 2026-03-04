import CalendarDomain
import EventKit
import Foundation
import UserNotifications

public final class EventKitScheduleRepository: ScheduleRepository {
  private let eventStore: EKEventStore
  private let calendar: Calendar
  private let notificationCenter: UNUserNotificationCenter

  public init(
    eventStore: EKEventStore = EKEventStore(),
    calendar: Calendar = .current,
    notificationCenter: UNUserNotificationCenter = .current()
  ) {
    self.eventStore = eventStore
    self.calendar = calendar
    self.notificationCenter = notificationCenter
  }

  public func requestAccess() async throws -> Bool {
    let calendarGranted = try await eventStore.requestFullAccessToEvents()
    guard calendarGranted else {
      return false
    }

    _ = try await requestNotificationAccessIfNeeded()
    return true
  }

  public func fetchAuthorizationStatus() -> ScheduleAuthorizationStatus {
    let status = EKEventStore.authorizationStatus(for: .event)

    switch status {
    case .notDetermined:
      return .notDetermined
    case .restricted:
      return .restricted
    case .denied:
      return .denied
    case .authorized:
      return .fullAccess
    case .fullAccess:
      return .fullAccess
    case .writeOnly:
      return .writeOnly
    @unknown default:
      return .denied
    }
  }

  public func hasNotificationPermission() async -> Bool {
    let settings = await notificationCenter.notificationSettings()

    switch settings.authorizationStatus {
    case .authorized, .provisional, .ephemeral:
      return true
    case .notDetermined, .denied:
      return false
    @unknown default:
      return false
    }
  }

  public func observeScheduleChanges() -> AsyncStream<Void> {
    AsyncStream { continuation in
      let token = NotificationCenter.default.addObserver(
        forName: .EKEventStoreChanged,
        object: eventStore,
        queue: nil
      ) { _ in
        continuation.yield(())
      }

      continuation.onTermination = { _ in
        NotificationCenter.default.removeObserver(token)
      }
    }
  }

  public func create(schedule: Schedule) async throws -> Schedule {
    try ensureReadWriteAccess()

    let event = EKEvent(eventStore: eventStore)
    try apply(schedule: schedule, to: event)

    guard let selectedCalendar = preferredCalendar(for: schedule) else {
      throw ScheduleRepositoryError.calendarNotFound
    }

    event.calendar = selectedCalendar
    try eventStore.save(event, span: .thisEvent, commit: true)

    return toSchedule(event: event)
  }

  public func fetchSchedule(id: String) async throws -> Schedule? {
    try ensureReadAccess()

    guard let event = eventStore.event(withIdentifier: id) else {
      return nil
    }

    return toSchedule(event: event)
  }

  public func fetchSchedules(in range: DateInterval) async throws -> [Schedule] {
    try ensureReadAccess()

    let predicate = eventStore.predicateForEvents(
      withStart: range.start,
      end: range.end,
      calendars: nil
    )

    return eventStore
      .events(matching: predicate)
      .sorted(by: { $0.startDate < $1.startDate })
      .map(toSchedule)
  }

  public func update(schedule: Schedule) async throws -> Schedule {
    try ensureReadWriteAccess()

    guard let id = schedule.id,
          let event = eventStore.event(withIdentifier: id)
    else {
      throw ScheduleRepositoryError.scheduleNotFound
    }

    try apply(schedule: schedule, to: event)

    if let selectedCalendar = preferredCalendar(for: schedule) {
      event.calendar = selectedCalendar
    }

    try eventStore.save(event, span: .thisEvent, commit: true)

    return toSchedule(event: event)
  }

  public func deleteSchedule(id: String) async throws {
    try ensureReadWriteAccess()

    guard let event = eventStore.event(withIdentifier: id) else {
      throw ScheduleRepositoryError.scheduleNotFound
    }

    try eventStore.remove(event, span: .thisEvent, commit: true)
  }

  public func hasICloudCalendar() -> Bool {
    preferredICloudCalendar() != nil
  }
}

private extension EventKitScheduleRepository {
  func ensureReadWriteAccess() throws {
    guard fetchAuthorizationStatus() == .fullAccess else {
      throw ScheduleRepositoryError.permissionDenied
    }
  }

  func ensureReadAccess() throws {
    guard fetchAuthorizationStatus() == .fullAccess else {
      throw ScheduleRepositoryError.readAccessDenied
    }
  }

  func preferredCalendar(for schedule: Schedule) -> EKCalendar? {
    if let calendarIdentifier = schedule.calendarIdentifier,
       let specificCalendar = eventStore.calendar(withIdentifier: calendarIdentifier) {
      return specificCalendar
    }

    return preferredICloudCalendar() ?? eventStore.defaultCalendarForNewEvents
  }

  func preferredICloudCalendar() -> EKCalendar? {
    eventStore
      .calendars(for: .event)
      .first(where: {
        $0.allowsContentModifications
          && $0.source.sourceType == .calDAV
          && $0.source.title.localizedCaseInsensitiveContains("icloud")
      })
  }

  func apply(schedule: Schedule, to event: EKEvent) throws {
    guard let startDate = schedule.startDate(using: calendar),
          let endDate = schedule.endDate(using: calendar)
    else {
      throw ScheduleRepositoryError.invalidScheduleDate
    }

    event.title = schedule.title
    event.startDate = startDate
    event.endDate = endDate
    event.location = schedule.location
    event.notes = schedule.notes
    event.isAllDay = schedule.isAllDay

    if let recurrence = schedule.recurrence {
      event.recurrenceRules = [toEKRecurrenceRule(recurrence)]
    } else {
      event.recurrenceRules = nil
    }

    let mappedAlarms = schedule.alarms.compactMap(toEKAlarm)
    event.alarms = mappedAlarms.isEmpty ? nil : mappedAlarms
  }

  func toSchedule(event: EKEvent) -> Schedule {
    let date = calendar.dateComponents([.year, .month, .day], from: event.startDate)
    let time = event.isAllDay
      ? nil
      : calendar.dateComponents([.hour, .minute, .second], from: event.startDate)
    let duration = max((event.endDate ?? event.startDate).timeIntervalSince(event.startDate), 0)

    return Schedule(
      id: event.eventIdentifier,
      calendarIdentifier: event.calendar?.calendarIdentifier,
      title: event.title ?? "",
      date: date,
      time: time,
      duration: duration,
      location: event.location,
      notes: event.notes,
      isAllDay: event.isAllDay,
      recurrence: toRecurrence(event.recurrenceRules?.first),
      alarms: toScheduleAlarms(event.alarms, startDate: event.startDate)
    )
  }

  func toEKRecurrenceRule(_ recurrence: Schedule.Recurrence) -> EKRecurrenceRule {
    let frequency: EKRecurrenceFrequency

    switch recurrence.frequency {
    case .daily:
      frequency = .daily
    case .weekly:
      frequency = .weekly
    case .monthly:
      frequency = .monthly
    case .yearly:
      frequency = .yearly
    @unknown default:
      frequency = .daily
    }

    let recurrenceEnd = recurrence.endDate.map(EKRecurrenceEnd.init)

    return EKRecurrenceRule(
      recurrenceWith: frequency,
      interval: recurrence.interval,
      end: recurrenceEnd
    )
  }

  func toRecurrence(_ recurrenceRule: EKRecurrenceRule?) -> Schedule.Recurrence? {
    guard let recurrenceRule else {
      return nil
    }

    let frequency: Schedule.Recurrence.Frequency

    switch recurrenceRule.frequency {
    case .daily:
      frequency = .daily
    case .weekly:
      frequency = .weekly
    case .monthly:
      frequency = .monthly
    case .yearly:
      frequency = .yearly
    @unknown default:
      frequency = .daily
    }

    return Schedule.Recurrence(
      frequency: frequency,
      interval: max(recurrenceRule.interval, 1),
      endDate: recurrenceRule.recurrenceEnd?.endDate
    )
  }

  func requestNotificationAccessIfNeeded() async throws -> Bool {
    let settings = await notificationCenter.notificationSettings()

    switch settings.authorizationStatus {
    case .authorized, .provisional, .ephemeral:
      return true
    case .notDetermined:
      return try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
    case .denied:
      return false
    @unknown default:
      return false
    }
  }

  func toEKAlarm(_ alarm: ScheduleAlarm) -> EKAlarm? {
    switch alarm.type {
    case .relativeToStart:
      return EKAlarm(relativeOffset: alarm.offset)
    }
  }

  func toScheduleAlarms(_ alarms: [EKAlarm]?, startDate: Date) -> [ScheduleAlarm] {
    guard let alarms else {
      return []
    }

    let mapped = alarms.map { alarm in
      let offset = alarm.absoluteDate?.timeIntervalSince(startDate) ?? alarm.relativeOffset
      return ScheduleAlarm(offset: offset)
    }

    return Array(Set(mapped)).sorted(by: { $0.offset < $1.offset })
  }
}
