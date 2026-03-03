import CalendarDomain
import Foundation

public final class MockScheduleRepository: ScheduleRepository {
  public var requestAccessResult: Result<Bool, Error> = .success(true)
  public var authorizationStatusValue: ScheduleAuthorizationStatus = .fullAccess
  public var schedulesToReturn: [Schedule] = []
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

  public private(set) var requestAccessCallCount = 0
  public private(set) var fetchAuthorizationStatusCallCount = 0
  public private(set) var hasICloudCalendarCallCount = 0

  public init() {}

  public func requestAccess() async throws -> Bool {
    requestAccessCallCount += 1
    return try requestAccessResult.get()
  }

  public func fetchAuthorizationStatus() -> ScheduleAuthorizationStatus {
    fetchAuthorizationStatusCallCount += 1
    return authorizationStatusValue
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
    if let fetched = schedulesToReturn.first(where: { $0.id == id }) {
      return fetched
    }
    return createdSchedules.first(where: { $0.id == id })
  }

  public func fetchSchedules(in range: DateInterval) async throws -> [Schedule] {
    fetchedRanges.append(range)
    if !schedulesToReturn.isEmpty {
      return schedulesToReturn
    }
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
    hasICloudCalendarCallCount += 1
    return true
  }
}
