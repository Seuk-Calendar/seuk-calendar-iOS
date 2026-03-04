import Foundation

public enum ScheduleAlarmType: String, Sendable {
  case relativeToStart
}

public struct ScheduleAlarm: Equatable, Hashable, Sendable {
  public var offset: TimeInterval
  public var type: ScheduleAlarmType

  public init(
    offset: TimeInterval,
    type: ScheduleAlarmType = .relativeToStart
  ) {
    self.offset = offset
    self.type = type
  }
}

public struct Schedule: Equatable {
  public struct Recurrence: Equatable {
    public enum Frequency: String {
      case daily
      case weekly
      case monthly
      case yearly
    }

    public var frequency: Frequency
    public var interval: Int
    public var endDate: Date?

    public init(
      frequency: Frequency,
      interval: Int = 1,
      endDate: Date? = nil
    ) {
      self.frequency = frequency
      self.interval = max(interval, 1)
      self.endDate = endDate
    }
  }

  public var id: String?
  public var calendarIdentifier: String?
  public var title: String
  public var date: DateComponents
  public var time: DateComponents?
  public var duration: TimeInterval
  public var location: String?
  public var notes: String?
  public var isAllDay: Bool
  public var recurrence: Recurrence?
  public var alarms: [ScheduleAlarm]

  public init(
    id: String? = nil,
    calendarIdentifier: String? = nil,
    title: String,
    date: DateComponents,
    time: DateComponents? = nil,
    duration: TimeInterval,
    location: String? = nil,
    notes: String? = nil,
    isAllDay: Bool,
    recurrence: Recurrence? = nil,
    alarms: [ScheduleAlarm] = []
  ) {
    self.id = id
    self.calendarIdentifier = calendarIdentifier
    self.title = title
    self.date = date
    self.time = time
    self.duration = max(duration, 0)
    self.location = location
    self.notes = notes
    self.isAllDay = isAllDay
    self.recurrence = recurrence
    self.alarms = alarms
  }

  public func startDate(using calendar: Calendar = .current) -> Date? {
    var components = DateComponents(
      calendar: date.calendar ?? calendar,
      timeZone: date.timeZone ?? time?.timeZone ?? calendar.timeZone,
      year: date.year,
      month: date.month,
      day: date.day,
      hour: isAllDay ? 0 : (time?.hour ?? 0),
      minute: isAllDay ? 0 : (time?.minute ?? 0),
      second: isAllDay ? 0 : (time?.second ?? 0)
    )

    if !isAllDay, let nanosecond = time?.nanosecond {
      components.nanosecond = nanosecond
    }

    return (date.calendar ?? calendar).date(from: components)
  }

  public func endDate(using calendar: Calendar = .current) -> Date? {
    guard let startDate = startDate(using: calendar) else {
      return nil
    }

    if isAllDay {
      let dayCount = max(Int((duration / 86400).rounded(.up)), 1)
      return calendar.date(byAdding: .day, value: dayCount, to: startDate)
    }

    let appliedSeconds = max(Int(duration.rounded()), 60)
    return calendar.date(byAdding: .second, value: appliedSeconds, to: startDate)
  }
}
