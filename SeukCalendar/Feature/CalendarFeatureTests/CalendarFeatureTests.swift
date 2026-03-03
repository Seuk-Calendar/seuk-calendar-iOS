@testable import CalendarFeature
import CalendarDomain
import DesignSystem
import Testing

struct CalendarFeatureTests {
  @Test
  @MainActor
  func onAppear_loadsVisibleEvents_whenPermissionGranted() async {
    let mockRepository = MockScheduleRepository()
    mockRepository.authorizationStatusValue = .fullAccess
    mockRepository.schedulesToReturn = [fixtureSchedule()]

    let viewModel = CalendarViewModel(
      selectedDate: Self.fixedDate,
      viewMode: .month,
      calendar: Self.fixedCalendar,
      repository: mockRepository
    )

    await viewModel.send(.onAppear)

    #expect(viewModel.visibleEvents.count == 1)
    #expect(viewModel.permissionState == .granted)
    #expect(mockRepository.fetchedRanges.count == 1)
  }

  @Test
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

    await viewModel.send(.onAppear)
    await viewModel.send(.movePeriod(1))

    #expect(Self.fixedCalendar.component(.month, from: viewModel.selectedDate) == 4)
  }

  @Test
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

    await viewModel.send(.onAppear)

    #expect(viewModel.permissionState.isDenied)
    #expect(mockRepository.fetchedRanges.isEmpty)
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
}

@MainActor
final class MockScheduleRepository: ScheduleRepository {
  var authorizationStatusValue: ScheduleAuthorizationStatus = .notDetermined
  var requestAccessResult: Result<Bool, Error> = .success(true)
  var schedulesToReturn: [Schedule] = []

  private(set) var requestAccessCallCount = 0
  private(set) var fetchedRanges: [DateInterval] = []

  func requestAccess() async throws -> Bool {
    requestAccessCallCount += 1
    return try requestAccessResult.get()
  }

  func fetchAuthorizationStatus() -> ScheduleAuthorizationStatus {
    authorizationStatusValue
  }

  func create(schedule: Schedule) async throws -> Schedule {
    schedule
  }

  func fetchSchedule(id: String) async throws -> Schedule? {
    schedulesToReturn.first(where: { $0.id == id })
  }

  func fetchSchedules(in range: DateInterval) async throws -> [Schedule] {
    fetchedRanges.append(range)
    return schedulesToReturn
  }

  func update(schedule: Schedule) async throws -> Schedule {
    schedule
  }

  func deleteSchedule(id: String) async throws {}

  func hasICloudCalendar() -> Bool {
    false
  }
}
