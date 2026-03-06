import DesignSystem
import SwiftUI

struct CalendarMonthPager: View {
  let baseDate: Date
  let eventsByDay: [Date: [CalendarEvent]]
  let calendar: Calendar
  let onSelectDate: (Date) -> Void
  let onMovePeriod: (Int) -> Void

  @State private var displayedBaseDate: Date
  @State private var selectedPage: Page = .current
  @State private var measuredHeight: CGFloat = 320

  init(
    baseDate: Date,
    eventsByDay: [Date: [CalendarEvent]],
    calendar: Calendar,
    onSelectDate: @escaping (Date) -> Void,
    onMovePeriod: @escaping (Int) -> Void
  ) {
    self.baseDate = baseDate
    self.eventsByDay = eventsByDay
    self.calendar = calendar
    self.onSelectDate = onSelectDate
    self.onMovePeriod = onMovePeriod
    _displayedBaseDate = State(initialValue: baseDate)
  }

  var body: some View {
    TabView(selection: $selectedPage) {
      ForEach(Page.allCases, id: \.self) { page in
        monthPage(for: page)
          .tag(page)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .indexViewStyle(.page(backgroundDisplayMode: .never))
    .onPreferenceChange(CalendarMonthPagerHeightsPreferenceKey.self) { heights in
      guard let maxHeight = heights.values.max() else {
        return
      }

      measuredHeight = maxHeight
    }
    .onChange(of: selectedPage) { _, newValue in
      guard newValue != .current else {
        return
      }

      onMovePeriod(newValue.offset)
    }
    .frame(height: measuredHeight)
    .clipped()
    .onChange(of: baseDate) { _, newValue in
      var transaction = Transaction()
      transaction.disablesAnimations = true

      withTransaction(transaction) {
        displayedBaseDate = newValue
        selectedPage = .current
      }
    }
  }
}

private extension CalendarMonthPager {
  enum Page: String, CaseIterable {
    case previous
    case current
    case next

    var id: String { rawValue }

    var offset: Int {
      switch self {
      case .previous:
        -1
      case .current:
        0
      case .next:
        1
      }
    }
  }

  func monthPage(for page: Page) -> some View {
    let pageDate = shiftedMonthDate(by: page.offset)

    return HomeCalendarComponent(
      month: pageDate,
      selectedDate: pageDate,
      eventsByDay: eventsByDay,
      calendar: calendar,
      showsMonthBar: false,
      eventListener: { event in
        guard case let .tapDate(date) = event else {
          return
        }

        onSelectDate(date)
      }
    )
    .background(
      GeometryReader { geometry in
        Color.clear.preference(
          key: CalendarMonthPagerHeightsPreferenceKey.self,
          value: [page.id: geometry.size.height]
        )
      }
    )
  }

  func shiftedMonthDate(by offset: Int) -> Date {
    calendar.date(byAdding: .month, value: offset, to: displayedBaseDate)
      .map(calendar.startOfDay(for:)) ?? displayedBaseDate
  }
}

private struct CalendarMonthPagerHeightsPreferenceKey: PreferenceKey {
  static var defaultValue: [String: CGFloat] = [:]

  static func reduce(
    value: inout [String: CGFloat],
    nextValue: () -> [String: CGFloat]
  ) {
    value.merge(nextValue()) { _, next in next }
  }
}
