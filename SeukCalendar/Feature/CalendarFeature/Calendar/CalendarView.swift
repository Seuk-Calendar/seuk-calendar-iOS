import DesignSystem
import SwiftUI

public struct CalendarView: View {
  @State private var viewModel: CalendarViewModel
  @State private var path: [CalendarEvent] = []
  @State private var pendingScheduleID: String?

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
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          modePicker
          dateHeader
          permissionDescription
          syncStatusDescription

          Group {
            switch viewModel.viewMode {
            case .month:
              monthContent
            case .week:
              weekContent
            case .day:
              dayContent
            }
          }
          .frame(maxWidth: .infinity, alignment: .topLeading)

          aiParsingSection
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
      }
      .simultaneousGesture(swipeGesture)
      .navigationTitle("캘린더")
      .navigationBarTitleDisplayMode(.inline)
      .overlay {
        if viewModel.isLoading || viewModel.isParsingNaturalLanguage || viewModel.isSavingParsedEvent {
          ProgressView()
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
      }
      .task {
        await viewModel.send(.onAppear).value
        openPendingScheduleIfNeeded()
      }
      .onChange(of: viewModel.visibleEvents.map(\.id)) { _, _ in
        openPendingScheduleIfNeeded()
      }
      .navigationDestination(for: CalendarEvent.self) { event in
        ScheduleDetailView(event: event)
      }
    }
  }
}

private extension CalendarView {
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

  var aiParsingSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("AI 일정 파싱")
        .font(.system(size: 15, weight: .semibold))

      TextField(
        "예: 다음주 화요일 오후 2시에 강남역에서 팀장님 미팅",
        text: naturalLanguageInputBinding,
        axis: .vertical
      )
      .textFieldStyle(.roundedBorder)
      .lineLimit(2 ... 4)

      HStack(spacing: 8) {
        Button("파싱") {
          viewModel.send(.parseNaturalLanguage)
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.naturalLanguageInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

        if viewModel.parsedEventDraft != nil {
          Button("초기화") {
            viewModel.send(.clearParsedEvent)
          }
          .buttonStyle(.bordered)
        }
      }

      if let parseErrorMessage = viewModel.parseErrorMessage {
        Text(parseErrorMessage)
          .font(.system(size: 12, weight: .regular))
          .foregroundStyle(.red)
      }

      if let parserStatusMessage = viewModel.parserStatusMessage {
        Text(parserStatusMessage)
          .font(.system(size: 12, weight: .regular))
          .foregroundStyle(.green)
      }

      if viewModel.parsedEventDraft != nil {
        parsedEventEditorCard
      }
    }
    .padding(12)
    .background(Color(.secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
  }

  var parsedEventEditorCard: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("파싱 결과 확인/수정")
        .font(.system(size: 14, weight: .semibold))

      TextField("제목", text: parsedTitleBinding)
        .textFieldStyle(.roundedBorder)

      TextField("날짜 (yyyy-MM-dd)", text: parsedDateStringBinding)
        .textFieldStyle(.roundedBorder)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()

      Toggle("종일 일정", isOn: parsedIsAllDayBinding)

      if !(viewModel.parsedEventDraft?.isAllDay ?? true) {
        TextField("시작 시간 (HH:mm)", text: parsedStartTimeBinding)
          .textFieldStyle(.roundedBorder)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
      }

      TextField("소요 시간(분)", text: parsedDurationMinutesBinding)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.numberPad)

      VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 8) {
          Text("알림")
            .font(.system(size: 13, weight: .semibold))
          Spacer()
          Menu {
            ForEach(CalendarViewModel.AlarmPreset.allCases) { preset in
              Button(preset.title) {
                viewModel.send(.addParsedAlarm(preset))
              }
            }
          } label: {
            Label("추가", systemImage: "plus.circle")
              .font(.system(size: 13, weight: .medium))
          }
        }

        if let alarms = viewModel.parsedEventDraft?.alarms,
           !alarms.isEmpty {
          ForEach(Array(alarms.enumerated()), id: \.offset) { index, alarm in
            HStack(spacing: 8) {
              Text(CalendarViewModel.AlarmPreset.title(for: alarm))
                .font(.system(size: 13, weight: .regular))
              Spacer()
              Button(role: .destructive) {
                viewModel.send(.removeParsedAlarm(index))
              } label: {
                Image(systemName: "minus.circle")
              }
              .buttonStyle(.plain)
            }
          }
        } else {
          Text("설정된 알림이 없습니다.")
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(.secondary)
        }
      }
      .padding(10)
      .background(Color(.secondarySystemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

      TextField("장소", text: parsedLocationBinding)
        .textFieldStyle(.roundedBorder)

      TextField("메모", text: parsedNotesBinding, axis: .vertical)
        .textFieldStyle(.roundedBorder)
        .lineLimit(2 ... 4)

      Button("일정 저장") {
        viewModel.send(.saveParsedEvent)
      }
      .buttonStyle(.borderedProminent)
      .disabled(viewModel.parsedEventDraft == nil)
    }
    .padding(12)
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
  }

  var modePicker: some View {
    Picker("뷰 모드", selection: modeBinding) {
      ForEach(CalendarViewModel.ViewMode.allCases) { mode in
        Text(mode.title)
          .tag(mode)
      }
    }
    .pickerStyle(.segmented)
  }

  var dateHeader: some View {
    HStack(spacing: 12) {
      Button {
        viewModel.send(.movePeriod(-1))
      } label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 14, weight: .semibold))
      }

      Text(viewModel.titleText)
        .font(.system(size: 17, weight: .semibold))
        .frame(maxWidth: .infinity)

      Button {
        viewModel.send(.movePeriod(1))
      } label: {
        Image(systemName: "chevron.right")
          .font(.system(size: 14, weight: .semibold))
      }

      Button("오늘") {
        viewModel.send(.moveToToday)
      }
      .font(.system(size: 14, weight: .medium))

      Button {
        viewModel.send(.refreshSchedules)
      } label: {
        Image(systemName: "arrow.clockwise")
          .font(.system(size: 14, weight: .semibold))
      }
      .accessibilityLabel("일정 새로고침")
    }
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
        .foregroundStyle(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  @ViewBuilder
  var syncStatusDescription: some View {
    if let syncStatusMessage = viewModel.syncStatusMessage {
      Text(syncStatusMessage)
        .font(.system(size: 12, weight: .regular))
        .foregroundStyle(syncStatusColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  var syncStatusColor: Color {
    switch viewModel.syncStatusTone {
    case .normal:
      return .secondary
    case .warning:
      return .orange
    case .success:
      return .green
    case .error:
      return .red
    }
  }

  var monthContent: some View {
    VStack(alignment: .leading, spacing: 14) {
      CalendarMonthPager(
        baseDate: viewModel.selectedDate,
        eventsByDay: viewModel.eventsByDay,
        calendar: viewModel.displayCalendar,
        onSelectDate: { date in
          viewModel.send(.selectDate(date))
        },
        onMovePeriod: { offset in
          viewModel.send(.movePeriod(offset))
        }
      )

      Text("선택한 날짜 일정")
        .font(.system(size: 15, weight: .semibold))

      scheduleList(for: viewModel.selectedDate)
    }
  }

  var weekContent: some View {
    CalendarWeekView(
      referenceDate: viewModel.selectedDate,
      selectedDate: viewModel.selectedDate,
      eventsByDay: viewModel.eventsByDay,
      wrapsDayContentInScrollView: false,
      onSelectDate: { date in
        viewModel.send(.selectDate(date))
      },
      onSelectEvent: openScheduleDetail
    )
  }

  var dayContent: some View {
    CalendarDayView(
      date: viewModel.selectedDate,
      events: viewModel.events(on: viewModel.selectedDate),
      wrapsContentInScrollView: false,
      onSelectEvent: openScheduleDetail
    )
  }

  @ViewBuilder
  func scheduleList(for date: Date) -> some View {
    let events = viewModel.events(on: date)

    if events.isEmpty {
      Text("일정이 없습니다.")
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
    } else {
      LazyVStack(spacing: 8) {
        ForEach(events) { event in
          ScheduleCard(event: event) {
            openScheduleDetail(event)
          }
        }
      }
    }
  }

  func openScheduleDetail(_ event: CalendarEvent) {
    path.append(event)
  }

  var modeBinding: Binding<CalendarViewModel.ViewMode> {
    Binding(
      get: { viewModel.viewMode },
      set: { mode in
        viewModel.send(.changeMode(mode))
      }
    )
  }

  var naturalLanguageInputBinding: Binding<String> {
    Binding(
      get: { viewModel.naturalLanguageInput },
      set: { viewModel.send(.updateNaturalLanguageInput($0)) }
    )
  }

  var parsedTitleBinding: Binding<String> {
    Binding(
      get: { viewModel.parsedEventDraft?.title ?? "" },
      set: { viewModel.send(.updateParsedTitle($0)) }
    )
  }

  var parsedDateStringBinding: Binding<String> {
    Binding(
      get: { viewModel.parsedEventDraft?.dateString ?? "" },
      set: { viewModel.send(.updateParsedDateString($0)) }
    )
  }

  var parsedStartTimeBinding: Binding<String> {
    Binding(
      get: { viewModel.parsedEventDraft?.startTime ?? "" },
      set: { viewModel.send(.updateParsedStartTime($0)) }
    )
  }

  var parsedDurationMinutesBinding: Binding<String> {
    Binding(
      get: { viewModel.parsedEventDraft?.durationMinutesText ?? "" },
      set: { viewModel.send(.updateParsedDurationMinutes($0)) }
    )
  }

  var parsedLocationBinding: Binding<String> {
    Binding(
      get: { viewModel.parsedEventDraft?.location ?? "" },
      set: { viewModel.send(.updateParsedLocation($0)) }
    )
  }

  var parsedNotesBinding: Binding<String> {
    Binding(
      get: { viewModel.parsedEventDraft?.notes ?? "" },
      set: { viewModel.send(.updateParsedNotes($0)) }
    )
  }

  var parsedIsAllDayBinding: Binding<Bool> {
    Binding(
      get: { viewModel.parsedEventDraft?.isAllDay ?? true },
      set: { viewModel.send(.updateParsedIsAllDay($0)) }
    )
  }

  var swipeGesture: some Gesture {
    DragGesture(minimumDistance: 20)
      .onEnded { value in
        guard viewModel.viewMode != .month else {
          return
        }

        let horizontalMovement = abs(value.translation.width)
        let verticalMovement = abs(value.translation.height)
        guard horizontalMovement > verticalMovement,
              horizontalMovement > 70
        else {
          return
        }

        let offset = value.translation.width < 0 ? 1 : -1
        viewModel.send(.movePeriod(offset))
      }
  }
}
