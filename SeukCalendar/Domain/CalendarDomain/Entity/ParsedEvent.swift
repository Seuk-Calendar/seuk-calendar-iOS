import Foundation

public struct ParsedEvent: Equatable, Sendable {
  public var title: String
  public var dateString: String
  public var startTime: String?
  public var durationMinutes: Int?
  public var location: String?
  public var notes: String?
  public var isAllDay: Bool
  public var alarms: [ScheduleAlarm]

  public init(
    title: String,
    dateString: String,
    startTime: String?,
    durationMinutes: Int?,
    location: String?,
    notes: String?,
    isAllDay: Bool,
    alarms: [ScheduleAlarm] = []
  ) {
    self.title = title
    self.dateString = dateString
    self.startTime = startTime
    self.durationMinutes = durationMinutes
    self.location = location
    self.notes = notes
    self.isAllDay = isAllDay
    self.alarms = alarms
  }
}
