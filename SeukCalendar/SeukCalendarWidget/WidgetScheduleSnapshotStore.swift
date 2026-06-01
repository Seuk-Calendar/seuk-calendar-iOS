import SwiftUI
import EventKit
import WidgetKit

struct WidgetScheduleSnapshotStore {
  private let userDefaults: UserDefaults?
  private let decoder: JSONDecoder

  init(appGroupIdentifier: String = WidgetSharedConstants.appGroupIdentifier) {
    userDefaults = UserDefaults(suiteName: appGroupIdentifier)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    self.decoder = decoder
  }

  func load() -> WidgetScheduleSnapshot? {
    guard let userDefaults,
          let data = userDefaults.data(forKey: WidgetSharedConstants.snapshotStorageKey)
    else {
      return nil
    }

    return try? decoder.decode(WidgetScheduleSnapshot.self, from: data)
  }
}

struct WidgetScheduleDataSource {
  private let snapshotStore: WidgetScheduleSnapshotStore
  private let calendar: Calendar
  private let eventStoreFactory: () -> EKEventStore

  init(
    snapshotStore: WidgetScheduleSnapshotStore = WidgetScheduleSnapshotStore(),
    calendar: Calendar = WidgetCalendarFactory.calendar,
    eventStoreFactory: @escaping () -> EKEventStore = { EKEventStore() }
  ) {
    self.snapshotStore = snapshotStore
    self.calendar = calendar
    self.eventStoreFactory = eventStoreFactory
  }

  func loadSnapshot(referenceDate: Date) -> WidgetScheduleSnapshot? {
    if let directSnapshot = loadDirectSnapshot(referenceDate: referenceDate) {
      debugLog("loaded direct EventKit snapshot: \(directSnapshot.items.count) items")
      return directSnapshot
    }

    if let storedSnapshot = snapshotStore.load() {
      debugLog("loaded fallback App Group snapshot: \(storedSnapshot.items.count) items")
      return storedSnapshot
    }

    debugLog("no widget snapshot source available, using empty state")
    return nil
  }
}

private extension WidgetScheduleDataSource {
  func loadDirectSnapshot(referenceDate: Date) -> WidgetScheduleSnapshot? {
    guard isReadableAuthorizationStatus(EKEventStore.authorizationStatus(for: .event)) else {
      debugLog("direct EventKit fetch skipped: authorization is unavailable")
      return nil
    }

    let eventStore = eventStoreFactory()
    let range = widgetRange(referenceDate: referenceDate)
    let predicate = eventStore.predicateForEvents(
      withStart: range.start,
      end: range.end,
      calendars: nil
    )

    let items = eventStore
      .events(matching: predicate)
      .compactMap(mapItem(from:))
      .sorted(by: { lhs, rhs in
        if lhs.startDate == rhs.startDate {
          return lhs.title < rhs.title
        }
        return lhs.startDate < rhs.startDate
      })

    return WidgetScheduleSnapshot(generatedAt: referenceDate, items: items)
  }

  func mapItem(from event: EKEvent) -> WidgetScheduleSnapshot.Item? {
    let fallbackIdentifier = "\(Int(event.startDate.timeIntervalSince1970))_\(event.title ?? "untitled")"

    return WidgetScheduleSnapshot.Item(
      id: event.eventIdentifier ?? fallbackIdentifier,
      title: (event.title?.isEmpty == false ? event.title : nil) ?? "제목 없음",
      startDate: event.startDate,
      endDate: event.endDate,
      isAllDay: event.isAllDay,
      location: event.location
    )
  }

  func widgetRange(referenceDate: Date) -> DateInterval {
    let dayStart = calendar.startOfDay(for: referenceDate)
    let monthStart = calendar.dateInterval(of: .month, for: dayStart)?.start ?? dayStart
    let gridStart = calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart
    let gridEnd = calendar.date(byAdding: .day, value: 35, to: gridStart) ?? gridStart

    return DateInterval(start: gridStart, end: gridEnd)
  }

  func isReadableAuthorizationStatus(_ status: EKAuthorizationStatus) -> Bool {
    switch status {
    case .authorized:
      return true
    case .fullAccess:
      return true
    case .writeOnly, .notDetermined, .denied, .restricted:
      return false
    @unknown default:
      return false
    }
  }

  func debugLog(_ message: String) {
    #if DEBUG
      print("[SeukCalendarWidget] \(message)")
    #endif
  }
}
