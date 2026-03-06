import DesignSystem
import SwiftUI

struct CalendarMonthPager: View {
  let baseDate: Date
  let eventsByDay: [Date: [CalendarEvent]]
  let calendar: Calendar
  let onSelectDate: (Date) -> Void
  let onMovePeriod: (Int) -> Void

  @State private var displayedBaseDate: Date
  @State private var activatedPageID: String? = Self.currentPageID
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
    GeometryReader { geometry in
      ScrollView(.horizontal) {
        LazyHStack(spacing: 0) {
          ForEach(pageModels) { page in
            monthPage(for: page)
              .id(page.id)
              .frame(width: geometry.size.width)
          }
        }
        .scrollTargetLayout()
      }
      .scrollPosition(id: $activatedPageID)
      .scrollIndicators(.hidden)
      .scrollTargetBehavior(.paging)
      .onPreferenceChange(CalendarMonthPagerHeightsPreferenceKey.self) { heights in
        guard let maxHeight = heights.values.max() else {
          return
        }

        measuredHeight = maxHeight
      }
      .onChange(of: activatedPageID) { _, newValue in
        guard let newValue,
              newValue != Self.currentPageID
        else {
          return
        }

        onMovePeriod(newValue == Self.nextPageID ? 1 : -1)
      }
    }
    .frame(height: measuredHeight)
    .clipped()
    .onChange(of: baseDate) { _, newValue in
      var transaction = Transaction()
      transaction.disablesAnimations = true

      withTransaction(transaction) {
        displayedBaseDate = newValue
        activatedPageID = Self.currentPageID
      }
    }
  }
}

private extension CalendarMonthPager {
  struct PageModel: Identifiable {
    let id: String
    let offset: Int
  }

  static let previousPageID = "previous"
  static let currentPageID = "current"
  static let nextPageID = "next"

  var pageModels: [PageModel] {
    [
      .init(id: Self.previousPageID, offset: -1),
      .init(id: Self.currentPageID, offset: 0),
      .init(id: Self.nextPageID, offset: 1)
    ]
  }

  func monthPage(for page: PageModel) -> some View {
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
