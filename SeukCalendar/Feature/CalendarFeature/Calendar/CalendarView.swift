import DesignSystem
import SwiftUI

public struct CalendarView: View {
  @State private var viewModel: CalendarViewModel
  @State private var path: [CalendarEvent] = []

  @MainActor
  public init(viewModel: CalendarViewModel) {
    _viewModel = State(initialValue: viewModel)
  }

  public var body: some View {
    NavigationStack(path: $path) {
      VStack(spacing: 16) {
        modePicker
        dateHeader
        permissionDescription

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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .gesture(swipeGesture)
      }
      .padding(16)
      .navigationTitle("캘린더")
      .navigationBarTitleDisplayMode(.inline)
      .overlay {
        if viewModel.isLoading {
          ProgressView()
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
      }
      .task {
        viewModel.send(.onAppear)
      }
      .navigationDestination(for: CalendarEvent.self) { event in
        ScheduleDetailView(event: event)
      }
    }
  }
}

private extension CalendarView {
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

  var monthContent: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 14) {
        CalendarMonthView(
          month: viewModel.selectedDate,
          selectedDate: viewModel.selectedDate,
          eventsByDay: viewModel.eventsByDay,
          onSelectDate: { date in
            viewModel.send(.selectDate(date))
          }
        )

        Text("선택한 날짜 일정")
          .font(.system(size: 15, weight: .semibold))

        scheduleList(for: viewModel.selectedDate)
      }
    }
  }

  var weekContent: some View {
    CalendarWeekView(
      referenceDate: viewModel.selectedDate,
      selectedDate: viewModel.selectedDate,
      eventsByDay: viewModel.eventsByDay,
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

  var swipeGesture: some Gesture {
    DragGesture(minimumDistance: 20)
      .onEnded { value in
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
