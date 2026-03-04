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
  public private(set) var syncStatusMessage: String?
  public private(set) var syncStatusTone: SyncStatusTone = .normal

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
  private var changeObservationTask: Task<Void, Never>?

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
    if await handleCalendarFlowAction(action) {
      return
    }

    if await handleParserFlowAction(action) {
      return
    }

    handleDraftMutationAction(action)
  }

  func handleCalendarFlowAction(_ action: Action) async -> Bool {
    switch action {
    case .onAppear:
      await loadIfNeeded()
      return true
    case .refreshSchedules:
      await handleRefreshSchedules()
      return true
    case let .changeMode(mode):
      await handleChangeMode(mode)
      return true
    case let .selectDate(date):
      await handleSelectDate(date)
      return true
    case let .movePeriod(offset):
      await handleMovePeriod(offset)
      return true
    case .moveToToday:
      await handleMoveToToday()
      return true
    default:
      return false
    }
  }

  func handleParserFlowAction(_ action: Action) async -> Bool {
    switch action {
    case let .updateNaturalLanguageInput(text):
      handleUpdateNaturalLanguageInput(text)
      return true
    case .parseNaturalLanguage:
      await handleParseNaturalLanguage()
      return true
    case .clearParsedEvent:
      handleClearParsedEvent()
      return true
    case .saveParsedEvent:
      await handleSaveParsedEvent()
      return true
    default:
      return false
    }
  }

  func handleDraftMutationAction(_ action: Action) {
    if handleDraftTextFieldMutation(action) {
      return
    }

    handleDraftAlarmAndFlagMutation(action)
  }

  func handleDraftTextFieldMutation(_ action: Action) -> Bool {
    switch action {
    case let .updateParsedTitle(title):
      updateParsedDraft { $0.title = title }
      return true
    case let .updateParsedDateString(dateString):
      updateParsedDraft { $0.dateString = dateString }
      return true
    case let .updateParsedStartTime(startTime):
      updateParsedDraft {
        $0.startTime = startTime
        if !startTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          $0.isAllDay = false
        }
      }
      return true
    case let .updateParsedDurationMinutes(durationMinutes):
      updateParsedDraft { $0.durationMinutesText = durationMinutes }
      return true
    case let .updateParsedLocation(location):
      updateParsedDraft { $0.location = location }
      return true
    case let .updateParsedNotes(notes):
      updateParsedDraft { $0.notes = notes }
      return true
    default:
      return false
    }
  }

  func handleDraftAlarmAndFlagMutation(_ action: Action) {
    switch action {
    case let .addParsedAlarm(preset):
      handleAddParsedAlarm(preset)
    case let .removeParsedAlarm(index):
      handleRemoveParsedAlarm(at: index)
    case .clearParsedAlarms:
      updateParsedDraft { $0.alarms = [] }
    case let .updateParsedIsAllDay(isAllDay):
      updateParsedDraft {
        $0.isAllDay = isAllDay
        if isAllDay {
          $0.startTime = ""
        }
      }
    default:
      return
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

  func handleRefreshSchedules() async {
    let isAuthorized = await ensureCalendarPermission()
    guard isAuthorized else {
      return
    }

    syncStatusMessage = "일정을 새로고침하는 중입니다..."
    syncStatusTone = .normal

    if await reloadVisibleEvents() {
      applySyncedStatusMessage()
    } else {
      syncStatusMessage = "일정을 새로고침하지 못했습니다. 잠시 후 다시 시도해주세요."
      syncStatusTone = .error
    }
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
    draft.alarms = ParsedEventDraft.normalizedAlarms(draft.alarms)
    parsedEventDraft = draft
    parseErrorMessage = nil
    parserStatusMessage = nil
  }

  func handleAddParsedAlarm(_ preset: AlarmPreset) {
    updateParsedDraft { draft in
      guard let alarm = preset.alarm else {
        draft.alarms = []
        return
      }

      draft.alarms.append(alarm)
    }
  }

  func handleRemoveParsedAlarm(at index: Int) {
    updateParsedDraft { draft in
      guard draft.alarms.indices.contains(index) else {
        return
      }

      draft.alarms.remove(at: index)
    }
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

    startObservingScheduleChangesIfNeeded()

    guard !hasLoaded else {
      return
    }

    hasLoaded = true
    if await reloadVisibleEvents() {
      applySyncedStatusMessage()
    }
  }

  func ensureCalendarPermission() async -> Bool {
    switch repository.fetchAuthorizationStatus() {
    case .fullAccess:
      permissionState = .granted
      applyICloudAvailabilityMessageIfNeeded()
      return true
    case .notDetermined:
      do {
        let granted = try await repository.requestAccess()
        if granted {
          permissionState = .granted
          applyICloudAvailabilityMessageIfNeeded()
        } else {
          permissionState = .denied("캘린더 접근 권한이 필요합니다.")
        }
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

  @discardableResult
  func reloadVisibleEvents() async -> Bool {
    guard permissionState == .granted else {
      return false
    }

    isLoading = true
    defer { isLoading = false }

    do {
      let schedules = try await repository.fetchSchedules(in: visibleRange())
      visibleEvents = toCalendarEvents(from: schedules)
      return true
    } catch {
      visibleEvents = []
      if let repositoryError = error as? ScheduleRepositoryError {
        permissionState = .denied(repositoryError.userMessage)
      } else {
        permissionState = .denied("일정을 불러오지 못했습니다. 잠시 후 다시 시도해주세요.")
      }
      return false
    }
  }

  func startObservingScheduleChangesIfNeeded() {
    guard changeObservationTask == nil else {
      return
    }

    syncStatusMessage = "iCloud 변경 사항을 모니터링하고 있습니다."
    syncStatusTone = .normal

    let repository = self.repository
    changeObservationTask = Task { [weak self] in
      for await _ in repository.observeScheduleChanges() {
        if Task.isCancelled {
          break
        }
        guard let self else {
          break
        }
        await self.handleExternalScheduleChange()
      }
    }
  }

  func handleExternalScheduleChange() async {
    syncStatusMessage = "iCloud 변경 사항을 반영하는 중입니다..."
    syncStatusTone = .normal

    if await reloadVisibleEvents() {
      applySyncedStatusMessage()
    } else {
      syncStatusMessage = "변경 사항 동기화에 실패했습니다. 잠시 후 다시 시도해주세요."
      syncStatusTone = .error
    }
  }

  func applyICloudAvailabilityMessageIfNeeded() {
    guard !repository.hasICloudCalendar() else {
      return
    }

    syncStatusMessage = "iCloud 캘린더를 찾지 못해 로컬 일정만 보일 수 있습니다."
    syncStatusTone = .warning
  }

  func applySyncedStatusMessage() {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateFormat = "a h:mm"
    syncStatusMessage = "최근 동기화: \(formatter.string(from: Date()))"
    syncStatusTone = .success
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
