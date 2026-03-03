@testable import CalendarFeature
import DesignSystem
import EventKit
import Testing

struct CalendarFeatureTests {
  @Test
  @MainActor
  func onAppear_loadsVisibleEvents_whenPermissionGranted() async {
    let mockProvider = MockCalendarScheduleProvider()
    mockProvider.authorizationStatusValue = .fullAccess
    mockProvider.eventsToReturn = [fixtureEvent()]

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      provider: mockProvider
    )

    await viewModel.send(.onAppear)

    #expect(viewModel.visibleEvents.count == 1)
    #expect(viewModel.permissionState == .granted)
    #expect(mockProvider.fetchedRanges.count == 1)
  }

  @Test
  @MainActor
  func movePeriod_shiftsMonthByOne_whenModeIsMonth() async {
    let mockProvider = MockCalendarScheduleProvider()
    mockProvider.authorizationStatusValue = .fullAccess

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      provider: mockProvider
    )

    await viewModel.send(.onAppear)
    await viewModel.send(.movePeriod(1))

    #expect(Self.fixedCalendar.component(.month, from: viewModel.selectedDate) == 4)
  }

  @Test
  @MainActor
  func onAppear_setsDeniedState_whenPermissionDenied() async {
    let mockProvider = MockCalendarScheduleProvider()
    mockProvider.authorizationStatusValue = .denied

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      provider: mockProvider
    )

    await viewModel.send(.onAppear)

    #expect(viewModel.permissionState.isDenied)
    #expect(mockProvider.fetchedRanges.isEmpty)
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

  static func fixtureEvent() -> CalendarEvent {
    let start = DateComponents(
      calendar: fixedCalendar,
      timeZone: fixedCalendar.timeZone,
      year: 2026,
      month: 3,
      day: 3,
      hour: 10
    ).date ?? fixedDate
    let end = fixedCalendar.date(byAdding: .hour, value: 1, to: start) ?? start

    return CalendarEvent(
      id: "event-1",
      title: "테스트 일정",
      startDate: start,
      endDate: end,
      isAllDay: false
    )
  }
}

@MainActor
final class MockCalendarScheduleProvider: CalendarScheduleProviding {
  var authorizationStatusValue: EKAuthorizationStatus = .notDetermined
  var requestFullAccessResult: Result<Bool, Error> = .success(true)
  var eventsToReturn: [CalendarEvent] = []

  private(set) var requestAccessCallCount = 0
  private(set) var fetchedRanges: [DateInterval] = []

  func authorizationStatus() -> EKAuthorizationStatus {
    authorizationStatusValue
  }

  func requestFullAccess() async throws -> Bool {
    requestAccessCallCount += 1
    return try requestFullAccessResult.get()
  }

  func fetchEvents(in range: DateInterval) async throws -> [CalendarEvent] {
    fetchedRanges.append(range)
    return eventsToReturn
  }
}
