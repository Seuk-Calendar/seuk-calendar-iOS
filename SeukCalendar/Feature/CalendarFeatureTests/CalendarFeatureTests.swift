import CalendarDomain
import CalendarDomainTestSupport
@testable import CalendarFeature
import DesignSystem
import Foundation
import Testing

struct CalendarFeatureTests {
  @Test("onAppear_권한_허용시_가시_일정을_로드합니다")
  @MainActor
  func onAppear_loadsVisibleEvents_whenPermissionGranted() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .fullAccess
    mockRepository.schedulesToReturn = [CalendarFeatureTests.fixtureSchedule()]

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear).value

    #expect(viewModel.visibleEvents.count == 1)
    #expect(viewModel.permissionState == .granted)
    #expect(mockRepository.fetchedRanges.count == 1)
  }

  @Test("refreshSchedules_수동_새로고침시_일정을_다시_로드합니다")
  @MainActor
  func refreshSchedules_reloadsVisibleEvents() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .fullAccess
    mockRepository.schedulesToReturn = [CalendarFeatureTests.fixtureSchedule(title: "첫 일정")]

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear).value
    mockRepository.schedulesToReturn = [CalendarFeatureTests.fixtureSchedule(id: "event-2", title: "갱신 일정")]

    await viewModel.send(.refreshSchedules).value

    #expect(mockRepository.fetchedRanges.count == 2)
    #expect(viewModel.visibleEvents.first?.title == "갱신 일정")
    #expect(viewModel.syncStatusMessage?.contains("최근 동기화") == true)
  }

  @Test("movePeriod_월_모드에서_한달_이동합니다")
  @MainActor
  func movePeriod_shiftsMonthByOne_whenModeIsMonth() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .fullAccess

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear).value
    await viewModel.send(.movePeriod(1)).value

    #expect(Self.fixedCalendar.component(.month, from: viewModel.selectedDate) == 4)
  }

  @Test("onAppear_권한_거부시_denied_상태를_설정합니다")
  @MainActor
  func onAppear_setsDeniedState_whenPermissionDenied() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .denied

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear).value

    #expect(viewModel.permissionState.isDenied)
    #expect(mockRepository.fetchedRanges.isEmpty)
  }

  @Test("onAppear_알림_권한이_없으면_denied_상태를_설정합니다")
  @MainActor
  func onAppear_setsDeniedState_whenNotificationPermissionDenied() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .fullAccess
    mockRepository.hasNotificationPermissionValue = false

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear).value

    #expect(viewModel.permissionState.isDenied)
    #expect(mockRepository.fetchedRanges.isEmpty)
  }

  @Test("onAppear_권한_변경후_재진입시_권한을_재확인합니다")
  @MainActor
  func onAppear_retriesPermissionCheck_whenPermissionChangesToGranted() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .denied

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear).value
    #expect(viewModel.permissionState.isDenied)

    mockRepository.authorizationStatusValue = .fullAccess
    mockRepository.schedulesToReturn = [CalendarFeatureTests.fixtureSchedule()]

    await viewModel.send(.onAppear).value

    #expect(viewModel.permissionState == .granted)
    #expect(viewModel.visibleEvents.count == 1)
    #expect(mockRepository.fetchedRanges.count == 1)
  }

  @Test("onAppear_이벤트스토어_변경시_자동으로_일정을_다시_로드합니다")
  @MainActor
  func onAppear_reloadsVisibleEvents_whenEventStoreChanged() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .fullAccess
    mockRepository.schedulesToReturn = [CalendarFeatureTests.fixtureSchedule(title: "기존 일정")]

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear).value
    mockRepository.schedulesToReturn = [CalendarFeatureTests.fixtureSchedule(id: "event-2", title: "동기화 일정")]

    mockRepository.emitScheduleChange()
    try? await Task.sleep(for: .milliseconds(50))

    #expect(mockRepository.observeScheduleChangesCallCount == 1)
    #expect(mockRepository.fetchedRanges.count == 2)
    #expect(viewModel.visibleEvents.first?.title == "동기화 일정")
  }

  @Test("eventsByDay_다일_일정을_각_일자에_포함합니다")
  @MainActor
  func eventsByDay_containsMultiDayEventForEachSpannedDay() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .fullAccess
    mockRepository.schedulesToReturn = [CalendarFeatureTests.fixtureTwoDayAllDaySchedule()]

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear).value

    let firstDay = Self.fixedDate
    let secondDay = Self.fixedCalendar.date(byAdding: .day, value: 1, to: Self.fixedDate) ?? Self.fixedDate

    #expect(viewModel.eventsByDay[firstDay]?.count == 1)
    #expect(viewModel.eventsByDay[secondDay]?.count == 1)
  }

  @Test("parseNaturalLanguage_성공시_편집용_초안을_설정합니다")
  @MainActor
  func parseNaturalLanguageSetsDraftWhenSucceeded() async {
    let mockRepository = MockScheduleRepository()
    let mockParser = MockScheduleNaturalLanguageParser()
    mockParser.parseResult = .success(
      ParsedEvent(
        title: "팀 미팅",
        dateString: "2026-03-04",
        startTime: "15:00",
        durationMinutes: 60,
        location: "강남역",
        notes: "자료 준비",
        isAllDay: false,
        alarms: [ScheduleAlarm(offset: -1800)]
      )
    )
    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository,
      parser: mockParser
    )

    await viewModel.send(.updateNaturalLanguageInput("내일 오후 3시 강남역에서 팀 미팅")).value
    await viewModel.send(.parseNaturalLanguage).value

    #expect(mockParser.parseCallCount == 1)
    #expect(viewModel.parsedEventDraft?.title == "팀 미팅")
    #expect(viewModel.parsedEventDraft?.dateString == "2026-03-04")
    #expect(viewModel.parsedEventDraft?.alarms == [ScheduleAlarm(offset: -1800)])
    #expect(viewModel.parseErrorMessage == nil)
  }

  @Test("parsedEventDraft_알림_추가와_삭제를_지원합니다")
  @MainActor
  func parsedEventDraftSupportsAddingAndRemovingAlarms() async {
    let mockRepository = MockScheduleRepository()
    let mockParser = MockScheduleNaturalLanguageParser()
    mockParser.parseResult = .success(
      ParsedEvent(
        title: "회의",
        dateString: "2026-03-04",
        startTime: "15:00",
        durationMinutes: 60,
        location: nil,
        notes: nil,
        isAllDay: false
      )
    )
    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository,
      parser: mockParser
    )

    await viewModel.send(.updateNaturalLanguageInput("내일 오후 3시 회의")).value
    await viewModel.send(.parseNaturalLanguage).value
    await viewModel.send(.addParsedAlarm(.thirtyMinutesBefore)).value
    await viewModel.send(.addParsedAlarm(.oneHourBefore)).value
    await viewModel.send(.removeParsedAlarm(1)).value

    #expect(viewModel.parsedEventDraft?.alarms == [ScheduleAlarm(offset: -3600)])

    await viewModel.send(.addParsedAlarm(.none)).value
    #expect(viewModel.parsedEventDraft?.alarms.isEmpty == true)
  }

  @Test("saveParsedEvent_저장시_일정을_생성하고_목록을_갱신합니다")
  @MainActor
  func saveParsedEventCreatesScheduleAndReloadsEvents() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .fullAccess
    let mockParser = MockScheduleNaturalLanguageParser()
    mockParser.parseResult = .success(
      ParsedEvent(
        title: "팀 미팅",
        dateString: "2026-03-04",
        startTime: "15:00",
        durationMinutes: 60,
        location: "강남역",
        notes: nil,
        isAllDay: false,
        alarms: [ScheduleAlarm(offset: -1800)]
      )
    )

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository,
      parser: mockParser
    )

    await viewModel.send(.updateNaturalLanguageInput("내일 오후 3시 강남역에서 팀 미팅")).value
    await viewModel.send(.parseNaturalLanguage).value
    await viewModel.send(.saveParsedEvent).value

    #expect(mockRepository.createdSchedules.count == 2)
    #expect(mockRepository.createdSchedules.last?.title == "팀 미팅")
    #expect(mockRepository.createdSchedules.last?.alarms == [ScheduleAlarm(offset: -1800)])
    #expect(viewModel.parsedEventDraft == nil)
    #expect(viewModel.naturalLanguageInput.isEmpty)
    #expect(viewModel.visibleEvents.isEmpty == false)
  }
}

private extension CalendarFeatureTests {
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

  static func fixtureSchedule(id: String = "event-1", title: String = "테스트 일정") -> Schedule {
    let dayComponents = DateComponents(
      calendar: fixedCalendar,
      timeZone: fixedCalendar.timeZone,
      year: 2026,
      month: 3,
      day: 3
    )

    let timeComponents = DateComponents(
      calendar: fixedCalendar,
      timeZone: fixedCalendar.timeZone,
      hour: 10
    )

    return Schedule(
      id: id,
      title: title,
      date: dayComponents,
      time: timeComponents,
      duration: 3600,
      isAllDay: false
    )
  }

  static func fixtureTwoDayAllDaySchedule() -> Schedule {
    let dayComponents = DateComponents(
      calendar: fixedCalendar,
      timeZone: fixedCalendar.timeZone,
      year: 2026,
      month: 3,
      day: 3
    )

    return Schedule(
      id: "event-2",
      title: "이틀 일정",
      date: dayComponents,
      duration: 172_800,
      isAllDay: true
    )
  }
}
