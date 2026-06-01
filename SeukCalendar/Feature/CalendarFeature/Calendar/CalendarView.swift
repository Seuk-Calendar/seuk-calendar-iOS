import DesignSystem
import SwiftUI

public struct CalendarView: View {
  @State private var viewModel: CalendarViewModel
  @State private var path: [CalendarEvent] = []
  @State private var pendingScheduleID: String?
  @State private var detailPanelState: DetailPanelState = .hidden
  @State private var detailPanelDragOffset: CGFloat = 0
  @State private var aiInputOverlayState: AIInputOverlayState = .hidden
  @State private var isParsedEventEditorPresented = false
  @State private var aiInputDraft = ""
  @State private var deleteConfirmationEvent: CalendarEvent?
  @State private var scheduleErrorAlert: ScheduleErrorAlert?

  @MainActor
  public init(
    viewModel: CalendarViewModel,
    initialScheduleID: String? = nil
  ) {
    _viewModel = State(initialValue: viewModel)
    _pendingScheduleID = State(initialValue: initialScheduleID)
  }

  public var body: some View {
    NavigationStack(path: $path) {
      GeometryReader { geometry in
        rootContent(in: geometry)
      }
      .background(Color.primitives.white)
      #if os(iOS)
        .toolbar(.hidden, for: .navigationBar)
      #endif
        .overlay(loadingOverlay)
        .sheet(
          isPresented: $isParsedEventEditorPresented,
          onDismiss: clearParsedEventIfNeeded
        ) {
          parsedEventEditorSheet
        }
        .alert(
          "정말로 삭제하시겠습니까?",
          isPresented: deleteConfirmationBinding,
          presenting: deleteConfirmationEvent
        ) { event in
          Button("삭제", role: .destructive) {
            deleteSchedule(event)
          }

          Button("취소", role: .cancel) {
            deleteConfirmationEvent = nil
          }
        } message: { event in
          Text("'\(event.title)' 일정을 삭제합니다.")
        }
        .alert(item: $scheduleErrorAlert) { alert in
          Alert(
            title: Text("일정을 처리하지 못했습니다."),
            message: Text(alert.message),
            dismissButton: .default(Text("확인"))
          )
        }
        .task {
          await viewModel.send(.onAppear).value
          openPendingScheduleIfNeeded()
        }
        .onChange(of: viewModel.visibleEvents.map(\.id)) { _, _ in
          openPendingScheduleIfNeeded()
        }
        .navigationDestination(for: CalendarEvent.self) { event in
          ScheduleEditView(
            event: event,
            isSaving: viewModel.isSavingEditedSchedule,
            isDeleting: viewModel.isDeletingSchedule,
            errorMessage: viewModel.scheduleMutationErrorMessage,
            onSave: { draft in
              saveEditedSchedule(event, draft: draft)
            },
            onDelete: {
              await deleteScheduleFromEditor(event)
            }
          )
        }
    }
  }
}

private extension CalendarView {
  enum DetailPanelState: Equatable {
    case hidden
    case medium
    case expanded

    var isPresented: Bool {
      self != .hidden
    }

    var baseFraction: CGFloat {
      switch self {
      case .hidden:
        0
      case .medium:
        0.5
      case .expanded:
        0.86
      }
    }

    var accessibilityValue: String {
      switch self {
      case .hidden:
        "닫힘"
      case .medium:
        "절반"
      case .expanded:
        "확장됨"
      }
    }
  }

  enum AIInputOverlayState: Equatable {
    case hidden
    case presented

    var isPresented: Bool {
      self == .presented
    }
  }

  struct ScheduleErrorAlert: Identifiable {
    let id = UUID()
    let message: String
  }

  func rootContent(in geometry: GeometryProxy) -> some View {
    let panelHeight = detailPanelHeight(in: geometry)
    let topHeight = max(geometry.size.height - panelHeight, detailPanelState.isPresented ? 180 : 260)

    return ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        header
        calendarArea(height: max(topHeight - headerHeightEstimate, 180))
      }
      .frame(maxWidth: .infinity)
      .frame(height: topHeight, alignment: .top)
      .frame(maxHeight: .infinity, alignment: .top)
      .animation(.spring(response: 0.34, dampingFraction: 0.86), value: detailPanelState)

      if detailPanelState.isPresented {
        SelectedDateDetailPanel(
          selectedDate: viewModel.selectedDate,
          events: viewModel.events(on: viewModel.selectedDate),
          height: panelHeight,
          panelAccessibilityValue: detailPanelState.accessibilityValue,
          onHandleDragChanged: handleDetailPanelDragChanged,
          onHandleDragEnded: handleDetailPanelDragEnded,
          onExpand: expandDetailPanel,
          onCollapse: collapseDetailPanel,
          onTapAIAdd: openAIInputOverlay,
          onTapEvent: openScheduleEditor,
          onRequestDelete: requestScheduleDeletion
        )
        .transition(.move(edge: .bottom).combined(with: .opacity))
      }

      if aiInputOverlayState.isPresented {
        NaturalLanguageInputOverlay(
          text: $aiInputDraft,
          isLoading: viewModel.isParsingNaturalLanguage,
          errorMessage: viewModel.parseErrorMessage,
          onCancel: cancelAIInputOverlay,
          onConfirm: confirmAIInput
        )
        .transition(.opacity)
        .zIndex(2)
      }
    }
  }

  var deleteConfirmationBinding: Binding<Bool> {
    Binding(
      get: { deleteConfirmationEvent != nil },
      set: { isPresented in
        if !isPresented {
          deleteConfirmationEvent = nil
        }
      }
    )
  }

  var headerHeightEstimate: CGFloat { 124 }

  var header: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(spacing: 16) {
        Button {
          viewModel.send(.movePeriod(-1))
        } label: {
          Image(systemName: "chevron.left")
            .font(.system(size: 18, weight: .semibold))
        }
        .accessibilityLabel("이전 달")

        Spacer(minLength: 0)

        Text(viewModel.titleText)
          .font(.system(size: 34, weight: .bold))
          .foregroundStyle(Color.primitives.black)
          .lineLimit(1)

        Spacer(minLength: 0)

        Button {
          viewModel.send(.refreshSchedules)
        } label: {
          Image(systemName: "arrow.clockwise")
            .font(.system(size: 18, weight: .semibold))
        }
        .accessibilityLabel("일정 새로고침")

        Button {
          viewModel.send(.movePeriod(1))
        } label: {
          Image(systemName: "chevron.right")
            .font(.system(size: 18, weight: .semibold))
        }
        .accessibilityLabel("다음 달")
      }
      .foregroundStyle(Color.primitives.black)

      HStack(spacing: 8) {
        Button("오늘") {
          viewModel.send(.moveToToday)
          closeDetailPanel()
        }
        .font(.system(size: 14, weight: .semibold))
        .buttonStyle(.bordered)

        permissionDescription
        syncStatusDescription
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 18)
    .padding(.top, 18)
    .padding(.bottom, 8)
  }

  func calendarArea(height: CGFloat) -> some View {
    let weekCount = calendarWeekCount(for: viewModel.selectedDate)
    let rowHeight = weekRowHeight(availableHeight: height, weekCount: weekCount)

    return HomeCalendarComponent(
      month: viewModel.selectedDate,
      selectedDate: viewModel.selectedDate,
      eventsByDay: viewModel.eventsByDay,
      showsMonthBar: false,
      displayMode: detailPanelState.isPresented ? .compactIndicator : .expanded,
      weekRowHeight: rowHeight,
      eventListener: { event in
        guard case let .tapDate(date) = event else {
          return
        }

        selectDateAndOpenDetail(date)
      }
    )
    .padding(.horizontal, 14)
    .padding(.top, 4)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .contentShape(Rectangle())
    .simultaneousGesture(calendarSwipeGesture)
  }

  @ViewBuilder
  var permissionDescription: some View {
    switch viewModel.permissionState {
    case .idle:
      EmptyView()
    case .granted:
      EmptyView()
    case let .denied(message):
      Text(message)
        .font(.system(size: 13, weight: .regular))
        .foregroundStyle(Color.calendar.red)
        .lineLimit(2)
    }
  }

  @ViewBuilder
  var syncStatusDescription: some View {
    if let syncStatusMessage = viewModel.syncStatusMessage {
      Text(syncStatusMessage)
        .font(.system(size: 12, weight: .regular))
        .foregroundStyle(syncStatusColor)
        .lineLimit(1)
        .minimumScaleFactor(0.75)
    }
  }

  var syncStatusColor: Color {
    switch viewModel.syncStatusTone {
    case .normal:
      return Color.primitives.gray600
    case .warning:
      return .orange
    case .success:
      return .green
    case .error:
      return Color.calendar.red
    }
  }

  @ViewBuilder
  var loadingOverlay: some View {
    if viewModel.isLoading {
      ProgressView()
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
  }

  var parsedEventEditorSheet: some View {
    ParsedEventEditorSheet(
      draft: viewModel.parsedEventDraft,
      isSaving: viewModel.isSavingParsedEvent,
      errorMessage: viewModel.parseErrorMessage,
      onUpdateTitle: { viewModel.send(.updateParsedTitle($0)) },
      onUpdateDateString: { viewModel.send(.updateParsedDateString($0)) },
      onUpdateStartTime: { viewModel.send(.updateParsedStartTime($0)) },
      onUpdateDurationMinutes: { viewModel.send(.updateParsedDurationMinutes($0)) },
      onUpdateLocation: { viewModel.send(.updateParsedLocation($0)) },
      onUpdateNotes: { viewModel.send(.updateParsedNotes($0)) },
      onUpdateIsAllDay: { viewModel.send(.updateParsedIsAllDay($0)) },
      onAddAlarm: { viewModel.send(.addParsedAlarm($0)) },
      onRemoveAlarm: { viewModel.send(.removeParsedAlarm($0)) },
      onCancel: cancelParsedEventEditor,
      onSave: saveParsedEvent
    )
  }

  var calendarSwipeGesture: some Gesture {
    DragGesture(minimumDistance: 20)
      .onEnded { value in
        handleCalendarDrag(value.translation)
      }
  }

  func handleCalendarDrag(_ translation: CGSize) {
    let horizontalMovement = abs(translation.width)
    let verticalMovement = abs(translation.height)

    if horizontalMovement > verticalMovement,
       horizontalMovement > 70 {
      let offset = translation.width < 0 ? 1 : -1
      viewModel.send(.movePeriod(offset))
      return
    }

    guard verticalMovement > horizontalMovement,
          verticalMovement > 60
    else {
      return
    }

    if translation.height < 0 {
      openDetailPanel()
    } else {
      closeDetailPanel()
    }
  }

  func selectDateAndOpenDetail(_ date: Date) {
    viewModel.send(.selectDate(date))
    openDetailPanel()
  }

  func openDetailPanel() {
    withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
      detailPanelState = .medium
    }
  }

  func closeDetailPanel() {
    withAnimation(.spring(response: 0.3, dampingFraction: 0.88)) {
      detailPanelState = .hidden
      detailPanelDragOffset = 0
    }
  }

  func expandDetailPanel() {
    guard detailPanelState.isPresented else {
      openDetailPanel()
      return
    }

    withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
      detailPanelState = .expanded
      detailPanelDragOffset = 0
    }
  }

  func collapseDetailPanel() {
    withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
      if detailPanelState == .expanded {
        detailPanelState = .medium
      } else {
        detailPanelState = .hidden
      }
      detailPanelDragOffset = 0
    }
  }

  func openAIInputOverlay() {
    aiInputDraft = ""
    viewModel.send(.clearParsedEvent)
    withAnimation(.easeInOut(duration: 0.18)) {
      aiInputOverlayState = .presented
    }
  }

  func cancelAIInputOverlay() {
    aiInputDraft = ""
    viewModel.send(.clearParsedEvent)
    withAnimation(.easeInOut(duration: 0.18)) {
      aiInputOverlayState = .hidden
    }
  }

  func confirmAIInput() {
    let text = aiInputDraft.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !text.isEmpty else {
      return
    }

    Task { @MainActor in
      await viewModel.send(.updateNaturalLanguageInput(text)).value
      await viewModel.send(.parseNaturalLanguage).value

      guard viewModel.parsedEventDraft != nil else {
        return
      }

      withAnimation(.easeInOut(duration: 0.18)) {
        aiInputOverlayState = .hidden
      }
      aiInputDraft = ""
      await Task.yield()
      isParsedEventEditorPresented = true
    }
  }

  func cancelParsedEventEditor() {
    viewModel.send(.clearParsedEvent)
    isParsedEventEditorPresented = false
  }

  func saveParsedEvent() {
    Task { @MainActor in
      await viewModel.send(.saveParsedEvent).value

      guard viewModel.parsedEventDraft == nil else {
        return
      }

      isParsedEventEditorPresented = false
      openDetailPanel()
    }
  }

  func clearParsedEventIfNeeded() {
    guard viewModel.parsedEventDraft != nil else {
      return
    }

    viewModel.send(.clearParsedEvent)
  }

  func openPendingScheduleIfNeeded() {
    guard let pendingScheduleID else {
      return
    }

    let targetDate = viewModel.selectedDate
    let events = viewModel.events(on: targetDate)

    guard let event = events.first(where: { $0.id == pendingScheduleID }) else {
      return
    }

    path = [event]
    self.pendingScheduleID = nil
  }

  func openScheduleEditor(_ event: CalendarEvent) {
    path.append(event)
  }

  func requestScheduleDeletion(_ event: CalendarEvent) {
    deleteConfirmationEvent = event
  }

  func saveEditedSchedule(
    _ event: CalendarEvent,
    draft: CalendarViewModel.ScheduleEditDraft
  ) {
    Task { @MainActor in
      await viewModel.send(.updateSchedule(event, draft)).value

      if let message = viewModel.scheduleMutationErrorMessage {
        scheduleErrorAlert = ScheduleErrorAlert(message: message)
        return
      }

      path.removeAll { $0.id == event.id }
      openDetailPanel()
    }
  }

  func deleteSchedule(_ event: CalendarEvent) {
    Task { @MainActor in
      await viewModel.send(.deleteSchedule(event.id)).value
      deleteConfirmationEvent = nil

      if let message = viewModel.scheduleMutationErrorMessage {
        scheduleErrorAlert = ScheduleErrorAlert(message: message)
      }
    }
  }

  func deleteScheduleFromEditor(_ event: CalendarEvent) async -> Bool {
    await viewModel.send(.deleteSchedule(event.id)).value

    if let message = viewModel.scheduleMutationErrorMessage {
      scheduleErrorAlert = ScheduleErrorAlert(message: message)
      return false
    }

    path.removeAll { $0.id == event.id }
    openDetailPanel()
    return true
  }

  func detailPanelHeight(in geometry: GeometryProxy) -> CGFloat {
    guard detailPanelState.isPresented else {
      return 0
    }

    let screenHeight = geometry.size.height
    let minimumHeight = min(max(screenHeight * 0.32, 220), screenHeight * 0.5)
    let maximumHeight = screenHeight * 0.9
    let baseHeight = screenHeight * detailPanelState.baseFraction
    return min(max(baseHeight - detailPanelDragOffset, minimumHeight), maximumHeight)
  }

  func handleDetailPanelDragChanged(_ translationHeight: CGFloat) {
    guard detailPanelState.isPresented else {
      return
    }

    detailPanelDragOffset = translationHeight
  }

  func handleDetailPanelDragEnded(_ translationHeight: CGFloat) {
    guard detailPanelState.isPresented else {
      return
    }

    withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
      detailPanelDragOffset = 0

      if translationHeight < -70 {
        detailPanelState = .expanded
      } else if translationHeight > 110 {
        detailPanelState = detailPanelState == .expanded ? .medium : .hidden
      } else {
        detailPanelState = detailPanelState == .expanded ? .expanded : .medium
      }
    }
  }

  func calendarWeekCount(for date: Date) -> Int {
    var calendar = Calendar.current
    calendar.firstWeekday = Calendar.current.firstWeekday

    guard let monthInterval = calendar.dateInterval(of: .month, for: date),
          let firstWeekInterval = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
          let lastMomentOfMonth = calendar.date(byAdding: .second, value: -1, to: monthInterval.end),
          let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: lastMomentOfMonth)
    else {
      return 6
    }

    let dayCount = calendar.dateComponents([.day], from: firstWeekInterval.start, to: lastWeekInterval.end).day ?? 42
    return max(dayCount / 7, 1)
  }

  func weekRowHeight(
    availableHeight: CGFloat,
    weekCount: Int
  ) -> CGFloat {
    let weekdayReserve: CGFloat = 46
    let weekSpacing = CGFloat(max(weekCount - 1, 0)) * 6
    let usableHeight = max(availableHeight - weekdayReserve - weekSpacing, 160)
    return max(usableHeight / CGFloat(max(weekCount, 1)), detailPanelState.isPresented ? 30 : 54)
  }
}
