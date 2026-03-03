import CalendarDomain
import DesignSystem
import Foundation
import Observation

@MainActor
@Observable
public final class CalendarViewModel {
  public private(set) var selectedDate: Date
  public private(set) var viewMode: ViewMode
  public private(set) var permissionState: PermissionState = .idle
  public private(set) var isLoading = false
  public private(set) var visibleEvents: [CalendarEvent] = []

  private let repository: any ScheduleRepository
  private let calendar: Calendar
  private var hasLoaded = false

  public init(
    selectedDate: Date = Date(),
    viewMode: ViewMode = .month,
    calendar: Calendar = .current,
    repository: any ScheduleRepository
  ) {
    self.selectedDate = calendar.startOfDay(for: selectedDate)
    self.viewMode = viewMode
    self.calendar = calendar
    self.repository = repository
  }

  public func send(_ action: Action) async {
    switch action {
    case .onAppear:
      await loadIfNeeded()
    case let .changeMode(mode):
      guard viewMode != mode else { return }
      viewMode = mode
      await reloadVisibleEvents()
    case let .selectDate(date):
      let previousDate = selectedDate
      selectedDate = calendar.startOfDay(for: date)

      switch viewMode {
      case .day:
        await reloadVisibleEvents()
      case .week:
        let isSameWeek = calendar.isDate(previousDate, equalTo: selectedDate, toGranularity: .weekOfYear)
        if !isSameWeek {
          await reloadVisibleEvents()
        }
      case .month:
        let isSameMonth = calendar.isDate(previousDate, equalTo: selectedDate, toGranularity: .month)
        if !isSameMonth {
          await reloadVisibleEvents()
        }
      }
    case let .movePeriod(offset):
      moveReferenceDate(by: offset)
      await reloadVisibleEvents()
    case .moveToToday:
      selectedDate = calendar.startOfDay(for: Date())
      await reloadVisibleEvents()
    }
  }

  public var titleText: String {
    let formatter = DateFormatter()
    formatter.locale = Locale.current

    switch viewMode {
    case .month:
      formatter.dateFormat = "yyyy년 M월"
      return formatter.string(from: selectedDate)
    case .week:
      guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else {
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: selectedDate)
      }

      formatter.dateFormat = "M월 d일"
      let startText = formatter.string(from: weekInterval.start)
      let endText = formatter.string(from: calendar.date(byAdding: .day, value: 6, to: weekInterval.start) ?? weekInterval.end)
      return "\(startText) - \(endText)"
    case .day:
      formatter.dateFormat = "yyyy년 M월 d일 EEEE"
      return formatter.string(from: selectedDate)
    }
  }

  public var eventsByDay: [Date: [CalendarEvent]] {
    Dictionary(grouping: visibleEvents) { event in
      calendar.startOfDay(for: event.startDate)
    }
  }

  public func events(on date: Date) -> [CalendarEvent] {
    let dayStart = calendar.startOfDay(for: date)
    guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else {
      return []
    }

    return visibleEvents
      .filter {
        $0.startDate < dayEnd && $0.endDate > dayStart
      }
      .sorted(by: { $0.startDate < $1.startDate })
  }
}

private extension CalendarViewModel {
  func loadIfNeeded() async {
    guard !hasLoaded else {
      return
    }

    hasLoaded = true

    let isAuthorized = await ensureCalendarPermission()
    guard isAuthorized else {
      return
    }

    await reloadVisibleEvents()
  }

  func ensureCalendarPermission() async -> Bool {
    switch repository.fetchAuthorizationStatus() {
    case .fullAccess:
      permissionState = .granted
      return true
    case .notDetermined:
      do {
        let granted = try await repository.requestAccess()
        permissionState = granted ? .granted : .denied("캘린더 접근 권한이 필요합니다.")
        return granted
      } catch {
        permissionState = .denied("캘린더 권한 요청 중 오류가 발생했습니다.")
        return false
      }
    case .writeOnly:
      permissionState = .denied("일정 조회를 위해 읽기 권한이 필요합니다.")
      return false
    case .restricted, .denied:
      permissionState = .denied("설정에서 캘린더 접근 권한을 허용해주세요.")
      return false
    @unknown default:
      permissionState = .denied("알 수 없는 권한 상태입니다.")
      return false
    }
  }

  func reloadVisibleEvents() async {
    guard permissionState == .granted else {
      return
    }

    isLoading = true
    defer { isLoading = false }

    do {
      let schedules = try await repository.fetchSchedules(in: visibleRange())
      visibleEvents = toCalendarEvents(from: schedules)
    } catch {
      visibleEvents = []
      if let repositoryError = error as? ScheduleRepositoryError {
        permissionState = .denied(repositoryError.userMessage)
      } else {
        permissionState = .denied("일정을 불러오지 못했습니다. 잠시 후 다시 시도해주세요.")
      }
    }
  }

  func visibleRange() -> DateInterval {
    switch viewMode {
    case .month:
      guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
            let start = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start)?.start,
            let monthEndMinusOne = calendar.date(byAdding: .second, value: -1, to: monthInterval.end),
            let end = calendar.dateInterval(of: .weekOfYear, for: monthEndMinusOne)?.end
      else {
        return DateInterval(start: selectedDate, duration: 0)
      }

      return DateInterval(start: start, end: end)
    case .week:
      guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else {
        return DateInterval(start: selectedDate, duration: 0)
      }
      return weekInterval
    case .day:
      let dayStart = calendar.startOfDay(for: selectedDate)
      let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
      return DateInterval(start: dayStart, end: dayEnd)
    }
  }

  func moveReferenceDate(by offset: Int) {
    guard offset != 0 else { return }

    switch viewMode {
    case .month:
      selectedDate = calendar.date(byAdding: .month, value: offset, to: selectedDate).map(calendar.startOfDay(for:)) ?? selectedDate
    case .week:
      selectedDate = calendar.date(byAdding: .day, value: offset * 7, to: selectedDate).map(calendar.startOfDay(for:)) ?? selectedDate
    case .day:
      selectedDate = calendar.date(byAdding: .day, value: offset, to: selectedDate).map(calendar.startOfDay(for:)) ?? selectedDate
    }
  }

  func toCalendarEvents(from schedules: [Schedule]) -> [CalendarEvent] {
    schedules
      .compactMap(toCalendarEvent)
      .sorted { lhs, rhs in
        if lhs.startDate == rhs.startDate {
          return lhs.title < rhs.title
        }

        return lhs.startDate < rhs.startDate
      }
  }

  func toCalendarEvent(schedule: Schedule) -> CalendarEvent? {
    guard let startDate = schedule.startDate(using: calendar),
          let endDate = schedule.endDate(using: calendar)
    else {
      return nil
    }

    return CalendarEvent(
      id: schedule.id ?? UUID().uuidString,
      title: schedule.title.isEmpty ? "제목 없음" : schedule.title,
      startDate: startDate,
      endDate: endDate,
      isAllDay: schedule.isAllDay,
      location: schedule.location,
      notes: schedule.notes
    )
  }
}
