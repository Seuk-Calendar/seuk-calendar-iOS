import Foundation

public struct FetchSchedulesUseCase {
  private let repository: any ScheduleRepository

  public init(repository: any ScheduleRepository) {
    self.repository = repository
  }

  public func execute(id: String) async throws -> Schedule? {
    try await repository.fetchSchedule(id: id)
  }

  public func execute(in range: DateInterval) async throws -> [Schedule] {
    try await repository.fetchSchedules(in: range)
  }
}
