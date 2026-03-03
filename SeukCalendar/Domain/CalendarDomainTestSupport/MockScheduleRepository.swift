import CalendarDomain
import Foundation

public final class MockScheduleRepository: ScheduleRepository {
  public var createdSchedules: [Schedule] = [
    Schedule(
      id: "event-1",
      title: "기본 일정",
      date: DateComponents(year: 2026, month: 3, day: 3),
      time: DateComponents(hour: 10, minute: 0),
      duration: 3_600,
      location: nil,
      notes: nil,
      isAllDay: false,
      recurrence: nil
    )
  ]
  public var updatedSchedules: [Schedule] = []
  public var deletedScheduleIDs: [String] = []
  public var fetchedScheduleIDs: [String] = []
  public var fetchedRanges: [DateInterval] = []

  public init() {}

  public func requestAccess() async throws -> Bool {
    true
  }

  public func fetchAuthorizationStatus() -> ScheduleAuthorizationStatus {
    .fullAccess
  }

  public func create(schedule: Schedule) async throws -> Schedule {
    var schedule = schedule
    if schedule.id == nil {
      schedule.id = "created-\(createdSchedules.count + 1)"
    }
    createdSchedules.append(schedule)
    return schedule
  }

  public func fetchSchedule(id: String) async throws -> Schedule? {
    fetchedScheduleIDs.append(id)
    return createdSchedules.first { $0.id == id }
  }

  public func fetchSchedules(in range: DateInterval) async throws -> [Schedule] {
    fetchedRanges.append(range)
    return createdSchedules
  }

  public func update(schedule: Schedule) async throws -> Schedule {
    updatedSchedules.append(schedule)
    return schedule
  }

  public func deleteSchedule(id: String) async throws {
    deletedScheduleIDs.append(id)
  }

  public func hasICloudCalendar() -> Bool {
    true
  }
}
