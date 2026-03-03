import Foundation

public struct UpdateScheduleUseCase {
  private let repository: any ScheduleRepository

  public init(repository: any ScheduleRepository) {
    self.repository = repository
  }

  public func execute(schedule: Schedule) async throws -> Schedule {
    try await repository.update(schedule: schedule)
  }
}
