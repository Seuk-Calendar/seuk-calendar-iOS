import SwiftUI

public struct HomeCalendarComponent: View {
  private let configuration: Configuration
  private let displayMode: DisplayMode
  private let weekRowHeight: CGFloat?
  private let eventListener: EventListener?

  public init(
    configuration: Configuration,
    displayMode: DisplayMode = .expanded,
    weekRowHeight: CGFloat? = nil,
    eventListener: EventListener? = nil
  ) {
    self.configuration = configuration
    self.displayMode = displayMode
    self.weekRowHeight = weekRowHeight
    self.eventListener = eventListener
  }

  public init(
    month: Date,
    selectedDate: Date,
    eventsByDay: [Date: [CalendarEvent]],
    calendar: Calendar = .current,
    showsMonthBar: Bool = true,
    displayMode: DisplayMode = .expanded,
    weekRowHeight: CGFloat? = nil,
    today: Date = Date(),
    eventListener: EventListener? = nil
  ) {
    self.configuration = HomeCalendarConfigurationBuilder.makeConfiguration(
      month: month,
      selectedDate: selectedDate,
      eventsByDay: eventsByDay,
      calendar: calendar,
      showsMonthBar: showsMonthBar,
      today: today
    )
    self.displayMode = displayMode
    self.weekRowHeight = weekRowHeight
    self.eventListener = eventListener
  }

  public var body: some View {
    VStack(spacing: Spacing.sp150) {
      if let monthBar = configuration.monthBar {
        HomeCalendarComponentMonthBar(
          monthBar: monthBar,
          eventListener: eventListener
        )
      }

      HomeCalendarComponentWeekdayBar(weekdays: configuration.weekdays)

      VStack(spacing: Spacing.sp150) {
        ForEach(configuration.weeks) { week in
          HomeCalendarComponentWeekView(
            week: week,
            displayMode: displayMode,
            weekRowHeight: weekRowHeight,
            eventListener: eventListener
          )
        }
      }
    }
  }
}

public extension HomeCalendarComponent {
  enum DisplayMode: Hashable, Sendable {
    case expanded
    case compactIndicator
  }
}

#if DEBUG
  #Preview {
    HomeCalendarComponent(
      configuration: previewConfiguration
    )
    .padding()
    .background(Color.primitives.gray50)
  }

  private let previewConfiguration: HomeCalendarComponent.Configuration = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    calendar.firstWeekday = 1

    let month = calendar.date(from: DateComponents(year: 2026, month: 2, day: 1)) ?? .now
    let selectedDate = calendar.date(from: DateComponents(year: 2026, month: 2, day: 27)) ?? month
    let today = calendar.date(from: DateComponents(year: 2026, month: 2, day: 26)) ?? month

    func makeDate(
      _ day: Int,
      hour: Int = 0
    ) -> Date {
      calendar.date(from: DateComponents(year: 2026, month: 2, day: day, hour: hour)) ?? month
    }

    let eventsByDay: [Date: [CalendarEvent]] = [
      calendar.startOfDay(for: makeDate(9)): [
        CalendarEvent(
          id: "gym",
          title: "체육관",
          startDate: makeDate(9, hour: 9),
          endDate: makeDate(9, hour: 10),
          isAllDay: false
        )
      ],
      calendar.startOfDay(for: makeDate(13)): [
        CalendarEvent(
          id: "trip",
          title: "출장",
          startDate: makeDate(13, hour: 10),
          endDate: makeDate(13, hour: 11),
          isAllDay: false
        )
      ],
      calendar.startOfDay(for: makeDate(18)): [
        CalendarEvent(
          id: "dentist",
          title: "치과",
          startDate: makeDate(18, hour: 14),
          endDate: makeDate(18, hour: 15),
          isAllDay: false
        )
      ],
      calendar.startOfDay(for: makeDate(25)): [
        CalendarEvent(
          id: "trip",
          title: "경주 여행",
          startDate: makeDate(25, hour: 9),
          endDate: makeDate(27, hour: 18),
          isAllDay: true
        )
      ],
      calendar.startOfDay(for: makeDate(26)): [
        CalendarEvent(
          id: "trip",
          title: "경주 여행",
          startDate: makeDate(25, hour: 9),
          endDate: makeDate(27, hour: 18),
          isAllDay: true
        ),
        CalendarEvent(
          id: "holiday",
          title: "휴일",
          startDate: makeDate(26, hour: 8),
          endDate: makeDate(26, hour: 9),
          isAllDay: false
        )
      ],
      calendar.startOfDay(for: makeDate(27)): [
        CalendarEvent(
          id: "trip",
          title: "경주 여행",
          startDate: makeDate(25, hour: 9),
          endDate: makeDate(27, hour: 18),
          isAllDay: true
        ),
        CalendarEvent(
          id: "cafe",
          title: "카페",
          startDate: makeDate(27, hour: 11),
          endDate: makeDate(27, hour: 12),
          isAllDay: false
        ),
        CalendarEvent(
          id: "meeting",
          title: "회의",
          startDate: makeDate(27, hour: 13),
          endDate: makeDate(27, hour: 14),
          isAllDay: false
        ),
        CalendarEvent(
          id: "review",
          title: "리뷰",
          startDate: makeDate(27, hour: 15),
          endDate: makeDate(27, hour: 16),
          isAllDay: false
        )
      ]
    ]

    return HomeCalendarConfigurationBuilder.makeConfiguration(
      month: month,
      selectedDate: selectedDate,
      eventsByDay: eventsByDay,
      calendar: calendar,
      showsMonthBar: true,
      today: today
    )
  }()
#endif
