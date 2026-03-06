import Foundation

public struct CalendarEvent: Identifiable, Hashable, Sendable {
  public var id: String
  public var title: String
  public var startDate: Date
  public var endDate: Date
  public var isAllDay: Bool
  public var location: String?
  public var notes: String?

  public init(
    id: String,
    title: String,
    startDate: Date,
    endDate: Date,
    isAllDay: Bool,
    location: String? = nil,
    notes: String? = nil
  ) {
    self.id = id
    self.title = title
    self.startDate = startDate
    self.endDate = endDate
    self.isAllDay = isAllDay
    self.location = location
    self.notes = notes
  }
}
