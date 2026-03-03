import Foundation

public enum ScheduleAuthorizationStatus {
  case notDetermined
  case restricted
  case denied
  case writeOnly
  case fullAccess
}

public enum ScheduleRepositoryError: Error, Equatable {
  case permissionDenied
  case readAccessDenied
  case scheduleNotFound
  case calendarNotFound
  case invalidScheduleDate
}

public protocol ScheduleRepository {
  func requestAccess() async throws -> Bool
  func fetchAuthorizationStatus() -> ScheduleAuthorizationStatus

  func create(schedule: Schedule) async throws -> Schedule
  func fetchSchedule(id: String) async throws -> Schedule?
  func fetchSchedules(in range: DateInterval) async throws -> [Schedule]
  func update(schedule: Schedule) async throws -> Schedule
  func deleteSchedule(id: String) async throws

  func hasICloudCalendar() -> Bool
}
