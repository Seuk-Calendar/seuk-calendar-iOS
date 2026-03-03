@testable import CalendarDomain
import CalendarDomainTestSupport
import Foundation
import Testing

struct CalendarDomainTests {
  @Test("CreateScheduleUseCase가 Repository로 생성을 위임한다")
  func createScheduleUseCaseDelegatesToRepository() async throws {
    let repository = MockScheduleRepository()
    let useCase = CreateScheduleUseCase(repository: repository)
    let input = Schedule(
      title: "신규 일정",
      date: DateComponents(year: 2026, month: 3, day: 3),
      time: DateComponents(hour: 9, minute: 30),
      duration: 3_600,
      location: "서울",
      notes: "메모",
      isAllDay: false,
      recurrence: nil
    )

    let created = try await useCase.execute(schedule: input)

    #expect(repository.createdSchedules.count == 2)
    #expect(created.title == "신규 일정")
  }

  @Test("FetchSchedulesUseCase가 단건 조회를 위임한다")
  func fetchScheduleByIdentifierDelegatesToRepository() async throws {
    let repository = MockScheduleRepository()
    let useCase = FetchSchedulesUseCase(repository: repository)
    let expected = repository.createdSchedules[0]

    let schedule = try await useCase.execute(id: expected.id ?? "")

    #expect(repository.fetchedScheduleIDs == [expected.id ?? ""])
    #expect(schedule == expected)
  }

  @Test("FetchSchedulesUseCase가 기간 조회를 위임한다")
  func fetchSchedulesInRangeDelegatesToRepository() async throws {
    let repository = MockScheduleRepository()
    let useCase = FetchSchedulesUseCase(repository: repository)
    let range = DateInterval(
      start: Date(timeIntervalSince1970: 0),
      end: Date(timeIntervalSince1970: 86_400)
    )

    let schedules = try await useCase.execute(in: range)

    #expect(repository.fetchedRanges.count == 1)
    #expect(schedules.count == repository.createdSchedules.count)
  }

  @Test("UpdateScheduleUseCase가 수정을 위임한다")
  func updateScheduleUseCaseDelegatesToRepository() async throws {
    let repository = MockScheduleRepository()
    let useCase = UpdateScheduleUseCase(repository: repository)
    var schedule = repository.createdSchedules[0]
    schedule.title = "수정된 일정"

    let updated = try await useCase.execute(schedule: schedule)

    #expect(repository.updatedSchedules.count == 1)
    #expect(updated.title == "수정된 일정")
  }

  @Test("DeleteScheduleUseCase가 삭제를 위임한다")
  func deleteScheduleUseCaseDelegatesToRepository() async throws {
    let repository = MockScheduleRepository()
    let useCase = DeleteScheduleUseCase(repository: repository)
    let id = repository.createdSchedules[0].id ?? ""

    try await useCase.execute(id: id)

    #expect(repository.deletedScheduleIDs == [id])
  }
}
