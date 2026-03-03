@testable import CalendarFeature
import CalendarDomain
import CalendarDomainTestSupport
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

  static func fixtureSchedule() -> Schedule {
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
      id: "event-1",
      title: "테스트 일정",
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
