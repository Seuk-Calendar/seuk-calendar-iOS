import Foundation

public struct DeleteScheduleUseCase {
  private let repository: any ScheduleRepository

  public init(repository: any ScheduleRepository) {
    self.repository = repository
  }

  public func execute(id: String) async throws {
    try await repository.deleteSchedule(id: id)
  }
}
