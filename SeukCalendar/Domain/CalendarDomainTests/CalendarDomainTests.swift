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
      duration: 3600,
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
      end: Date(timeIntervalSince1970: 86400)
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

  @Test("ParseEventUseCase_execute_파서를_호출합니다")
  func parseEventUseCaseCallsParser() async throws {
    let parser = MockScheduleNaturalLanguageParser()
    let useCase = ParseEventUseCase(parser: parser, calendar: Self.fixedCalendar)
    let input = "내일 오후 3시 회의"

    _ = try await useCase.execute(text: input, referenceDate: Self.fixedDate)

    #expect(parser.parseCallCount == 1)
    #expect(parser.parsedInputs.first?.text == input)
  }

  @Test("ParseEventUseCase_toSchedule_시간있는_일정을_생성합니다")
  func parseEventUseCaseCreatesTimedScheduleFromParsedEvent() throws {
    let parser = MockScheduleNaturalLanguageParser()
    let useCase = ParseEventUseCase(parser: parser, calendar: Self.fixedCalendar)
    let parsedEvent = ParsedEvent(
      title: "팀 미팅",
      dateString: "2026-03-10",
      startTime: "15:30",
      durationMinutes: 90,
      location: "강남역",
      notes: "준비물 확인",
      isAllDay: false
    )

    let schedule = try useCase.toSchedule(from: parsedEvent)

    #expect(schedule.isAllDay == false)
    #expect(schedule.time?.hour == 15)
    #expect(schedule.time?.minute == 30)
    #expect(schedule.duration == 5400)
    #expect(schedule.location == "강남역")
    #expect(schedule.alarms.isEmpty)
  }

  @Test("ParseEventUseCase_toSchedule_시간이_없으면_종일로_처리합니다")
  func parseEventUseCaseTreatsNoTimeAsAllDay() throws {
    let parser = MockScheduleNaturalLanguageParser()
    let useCase = ParseEventUseCase(parser: parser, calendar: Self.fixedCalendar)
    let parsedEvent = ParsedEvent(
      title: "연차",
      dateString: "2026-03-11",
      startTime: nil,
      durationMinutes: nil,
      location: nil,
      notes: nil,
      isAllDay: false
    )

    let schedule = try useCase.toSchedule(from: parsedEvent)

    #expect(schedule.isAllDay == true)
    #expect(schedule.time == nil)
    #expect(schedule.duration == 86400)
  }

  @Test("ParseEventUseCase_toSchedule_알림_오프셋을_보존합니다")
  func parseEventUseCasePreservesAlarmOffsets() throws {
    let parser = MockScheduleNaturalLanguageParser()
    let useCase = ParseEventUseCase(parser: parser, calendar: Self.fixedCalendar)
    let parsedEvent = ParsedEvent(
      title: "점검 회의",
      dateString: "2026-03-12",
      startTime: "09:00",
      durationMinutes: 30,
      location: nil,
      notes: nil,
      isAllDay: false,
      alarms: [
        ScheduleAlarm(offset: -3600),
        ScheduleAlarm(offset: -1800)
      ]
    )

    let schedule = try useCase.toSchedule(from: parsedEvent)

    #expect(schedule.alarms == parsedEvent.alarms)
  }
}

private extension CalendarDomainTests {
  static var fixedCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
    return calendar
  }

  static var fixedDate: Date {
    let components = DateComponents(
      calendar: fixedCalendar,
      timeZone: fixedCalendar.timeZone,
      year: 2026,
      month: 3,
      day: 3
    )
    return components.date ?? .init(timeIntervalSince1970: 0)
  }
}
