import Core
import Foundation

public enum ScheduleAuthorizationStatus {
  case notDetermined
  case restricted
  case denied
  case writeOnly
  case fullAccess
}

public enum ScheduleRepositoryError: SCError, Equatable {
  case permissionDenied
  case readAccessDenied
  case scheduleNotFound
  case calendarNotFound
  case invalidScheduleDate

  public var errorDescription: String {
    switch self {
    case .permissionDenied:
      "캘린더 전체 접근 권한이 없어 일정 변경을 수행할 수 없습니다."
    case .readAccessDenied:
      "캘린더 읽기 권한이 없어 일정을 조회할 수 없습니다."
    case .scheduleNotFound:
      "요청한 일정을 찾을 수 없습니다."
    case .calendarNotFound:
      "저장 가능한 캘린더를 찾을 수 없습니다."
    case .invalidScheduleDate:
      "일정 날짜 또는 시간이 올바르지 않습니다."
    }
  }

  public var userMessage: String {
    switch self {
    case .permissionDenied, .readAccessDenied:
      "캘린더 접근 권한을 확인해주세요."
    case .scheduleNotFound:
      "일정을 찾을 수 없습니다."
    case .calendarNotFound:
      "저장할 캘린더를 찾을 수 없습니다."
    case .invalidScheduleDate:
      "일정 시간을 다시 확인해주세요."
    }
  }
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
