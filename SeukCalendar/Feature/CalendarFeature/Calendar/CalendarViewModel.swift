import CalendarDomain
import Core
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

  public private(set) var naturalLanguageInput = ""
  public private(set) var parsedEventDraft: ParsedEventDraft?
  public private(set) var parseErrorMessage: String?
  public private(set) var parserStatusMessage: String?
  public private(set) var isParsingNaturalLanguage = false
  public private(set) var isSavingParsedEvent = false

  private let repository: any ScheduleRepository
  private let parseEventUseCase: ParseEventUseCase
  private let createScheduleUseCase: CreateScheduleUseCase
  private let calendar: Calendar
  private var hasLoaded = false
  private var pendingActionTask: Task<Void, Never>?

  public init(
    selectedDate: Date = Date(),
    viewMode: ViewMode = .month,
    calendar: Calendar = .current,
    repository: any ScheduleRepository,
    parser: any ScheduleNaturalLanguageParser = UnavailableScheduleNaturalLanguageParser()
  ) {
    self.selectedDate = calendar.startOfDay(for: selectedDate)
    self.viewMode = viewMode
    self.calendar = calendar
    self.repository = repository
    parseEventUseCase = ParseEventUseCase(parser: parser, calendar: calendar)
    createScheduleUseCase = CreateScheduleUseCase(repository: repository)
  }

  @discardableResult
  public func send(_ action: Action) -> Task<Void, Never> {
    let previousTask = pendingActionTask
    let task = Task { @MainActor [weak self] in
      _ = await previousTask?.result
      guard let self else { return }
      await self.handle(action)
    }

    pendingActionTask = task
    return task
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
      let endDate = calendar.date(byAdding: .day, value: 6, to: weekInterval.start) ?? weekInterval.end
      let endText = formatter.string(from: endDate)
      return "\(startText) - \(endText)"
    case .day:
      formatter.dateFormat = "yyyy년 M월 d일 EEEE"
      return formatter.string(from: selectedDate)
    }
  }

  public var eventsByDay: [Date: [CalendarEvent]] {
    var grouped: [Date: [CalendarEvent]] = [:]

    for event in visibleEvents {
      appendEvent(event, to: &grouped)
    }

    return grouped
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
  func handle(_ action: Action) async {
    switch action {
    case .onAppear:
      await loadIfNeeded()
    case let .changeMode(mode):
      await handleChangeMode(mode)
    case let .selectDate(date):
      await handleSelectDate(date)
    case let .movePeriod(offset):
      await handleMovePeriod(offset)
    case .moveToToday:
      await handleMoveToToday()
    case let .updateNaturalLanguageInput(text):
      handleUpdateNaturalLanguageInput(text)
    case .parseNaturalLanguage:
      await handleParseNaturalLanguage()
    case .clearParsedEvent:
      handleClearParsedEvent()
    case let .updateParsedTitle(title):
      updateParsedDraft { $0.title = title }
    case let .updateParsedDateString(dateString):
      updateParsedDraft { $0.dateString = dateString }
    case let .updateParsedStartTime(startTime):
      updateParsedDraft {
        $0.startTime = startTime
        if !startTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          $0.isAllDay = false
        }
      }
    case let .updateParsedDurationMinutes(durationMinutes):
      updateParsedDraft { $0.durationMinutesText = durationMinutes }
    case let .updateParsedLocation(location):
      updateParsedDraft { $0.location = location }
    case let .updateParsedNotes(notes):
      updateParsedDraft { $0.notes = notes }
    case let .updateParsedIsAllDay(isAllDay):
      updateParsedDraft {
        $0.isAllDay = isAllDay
        if isAllDay {
          $0.startTime = ""
        }
      }
    case .saveParsedEvent:
      await handleSaveParsedEvent()
    }
  }

  func handleChangeMode(_ mode: ViewMode) async {
    guard viewMode != mode else { return }

    viewMode = mode
    await reloadVisibleEvents()
  }

  func handleSelectDate(_ date: Date) async {
    let previousDate = selectedDate
    selectedDate = calendar.startOfDay(for: date)

    guard shouldReloadAfterSelectingDate(from: previousDate, to: selectedDate) else {
      return
    }

    await reloadVisibleEvents()
  }

  func handleMovePeriod(_ offset: Int) async {
    moveReferenceDate(by: offset)
    await reloadVisibleEvents()
  }

  func handleMoveToToday() async {
    selectedDate = calendar.startOfDay(for: Date())
    await reloadVisibleEvents()
  }

  func handleUpdateNaturalLanguageInput(_ text: String) {
    naturalLanguageInput = text
    parseErrorMessage = nil
    parserStatusMessage = nil
  }

  func handleParseNaturalLanguage() async {
    parseErrorMessage = nil
    parserStatusMessage = nil
    isParsingNaturalLanguage = true
    defer { isParsingNaturalLanguage = false }

    do {
      let parsedEvent = try await parseEventUseCase.execute(
        text: naturalLanguageInput,
        referenceDate: selectedDate
      )
      parsedEventDraft = ParsedEventDraft(parsedEvent: parsedEvent)
      parserStatusMessage = "파싱 결과를 확인하고 필요한 값을 수정한 뒤 저장해주세요."
    } catch {
      parsedEventDraft = nil
      parseErrorMessage = userMessage(for: error)
    }
  }

  func handleClearParsedEvent() {
    parsedEventDraft = nil
    parseErrorMessage = nil
    parserStatusMessage = nil
  }

  func handleSaveParsedEvent() async {
    guard let parsedEventDraft else {
      return
    }

    parseErrorMessage = nil
    parserStatusMessage = nil
    isSavingParsedEvent = true
    defer { isSavingParsedEvent = false }

    let isAuthorized = await ensureCalendarPermission()
    guard isAuthorized else {
      return
    }

    do {
      let schedule = try parseEventUseCase.toSchedule(from: parsedEventDraft.parsedEvent)
      _ = try await createScheduleUseCase.execute(schedule: schedule)

      naturalLanguageInput = ""
      self.parsedEventDraft = nil
      parserStatusMessage = "일정을 저장했습니다."
      await reloadVisibleEvents()
    } catch {
      parseErrorMessage = userMessage(for: error)
    }
  }

  func updateParsedDraft(_ transform: (inout ParsedEventDraft) -> Void) {
    guard var draft = parsedEventDraft else {
      return
    }

    transform(&draft)
    parsedEventDraft = draft
    parseErrorMessage = nil
    parserStatusMessage = nil
  }

  func shouldReloadAfterSelectingDate(from previousDate: Date, to currentDate: Date) -> Bool {
    switch viewMode {
    case .day:
      return true
    case .week:
      return !calendar.isDate(previousDate, equalTo: currentDate, toGranularity: .weekOfYear)
    case .month:
      return !calendar.isDate(previousDate, equalTo: currentDate, toGranularity: .month)
    }
  }

  func loadIfNeeded() async {
    let isAuthorized = await ensureCalendarPermission()
    guard isAuthorized else {
      hasLoaded = false
      visibleEvents = []
      return
    }

    guard !hasLoaded else {
      return
    }

    hasLoaded = true
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
      selectedDate = calendar.date(byAdding: .month, value: offset, to: selectedDate)
        .map(calendar.startOfDay(for:)) ?? selectedDate
    case .week:
      selectedDate = calendar.date(byAdding: .day, value: offset * 7, to: selectedDate)
        .map(calendar.startOfDay(for:)) ?? selectedDate
    case .day:
      selectedDate = calendar.date(byAdding: .day, value: offset, to: selectedDate)
        .map(calendar.startOfDay(for:)) ?? selectedDate
    }
  }

  func appendEvent(_ event: CalendarEvent, to grouped: inout [Date: [CalendarEvent]]) {
    var cursor = calendar.startOfDay(for: event.startDate)
    let effectiveEndDate = max(event.endDate, event.startDate.addingTimeInterval(1))

    while cursor < effectiveEndDate {
      grouped[cursor, default: []].append(event)

      guard let nextDay = calendar.date(byAdding: .day, value: 1, to: cursor) else {
        break
      }
      cursor = nextDay
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

  func userMessage(for error: Error) -> String {
    if let scError = error as? any SCError {
      return scError.userMessage
    }

    return "일정을 처리하지 못했습니다. 잠시 후 다시 시도해주세요."
  }
}
