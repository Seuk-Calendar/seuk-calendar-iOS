import Foundation

enum HomeCalendarConfigurationBuilder {
  static func makeConfiguration(
    month: Date,
    selectedDate: Date,
    eventsByDay: [Date: [CalendarEvent]],
    calendar: Calendar,
    showsMonthBar: Bool,
    today: Date = Date()
  ) -> HomeCalendarComponent.Configuration {
    let normalizedMonth = calendar.startOfDay(for: month)
    let normalizedSelectedDate = calendar.startOfDay(for: selectedDate)
    let normalizedToday = calendar.startOfDay(for: today)
    let weekdaySymbols = orderedWeekdaySymbols(using: calendar)
    let dates = monthGridDates(month: normalizedMonth, calendar: calendar)
    let context = DayContext(
      month: normalizedMonth,
      selectedDate: normalizedSelectedDate,
      today: normalizedToday,
      eventsByDay: eventsByDay,
      calendar: calendar
    )

    let weeks = stride(from: 0, to: dates.count, by: 7).map { index in
      let chunk = Array(dates[index ..< min(index + 7, dates.count)])
      let days = chunk.map { date in
        day(for: date, context: context)
      }

      return HomeCalendarComponent.Configuration.Week(
        id: "week-\(index / 7)",
        days: days
      )
    }

    return HomeCalendarComponent.Configuration(
      monthBar: showsMonthBar ? monthBar(for: normalizedMonth, calendar: calendar) : nil,
      weekdays: weekdaySymbols,
      weeks: weeks
    )
  }
}

private extension HomeCalendarConfigurationBuilder {
  struct DayContext {
    let month: Date
    let selectedDate: Date
    let today: Date
    let eventsByDay: [Date: [CalendarEvent]]
    let calendar: Calendar
  }

  static func orderedWeekdaySymbols(using calendar: Calendar) -> [HomeCalendarComponent.Configuration.Weekday] {
    let symbols = calendar.veryShortStandaloneWeekdaySymbols
    guard !symbols.isEmpty else {
      return []
    }

    let firstWeekdayIndex = max(min(calendar.firstWeekday - 1, symbols.count - 1), 0)
    let reorderedIndexes = Array(firstWeekdayIndex ..< symbols.count) + Array(0 ..< firstWeekdayIndex)

    return reorderedIndexes.map { index in
      HomeCalendarComponent.Configuration.Weekday(
        id: "weekday-\(index)",
        title: symbols[index],
        role: weekdayRole(forWeekdayIndex: index)
      )
    }
  }

  static func monthGridDates(
    month: Date,
    calendar: Calendar
  ) -> [Date] {
    guard let monthInterval = calendar.dateInterval(of: .month, for: month),
          let firstWeekInterval = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
          let lastMomentOfMonth = calendar.date(byAdding: .second, value: -1, to: monthInterval.end),
          let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: lastMomentOfMonth) else {
      return []
    }

    let range = DateInterval(start: firstWeekInterval.start, end: lastWeekInterval.end)
    var dates: [Date] = []
    var cursor = range.start

    while cursor < range.end {
      dates.append(cursor)

      guard let nextDay = calendar.date(byAdding: .day, value: 1, to: cursor) else {
        break
      }

      cursor = nextDay
    }

    return dates
  }

  static func day(
    for date: Date,
    context: DayContext
  ) -> HomeCalendarComponent.Configuration.Day {
    let normalizedDate = context.calendar.startOfDay(for: date)
    let events = sortedEvents(context.eventsByDay[normalizedDate] ?? [])
    let visibleBadges = Array(events.prefix(2).enumerated()).map { index, event in
      HomeCalendarComponent.Configuration.Badge(
        id: event.id,
        title: badgeTitle(for: event),
        style: badgeStyle(for: event, index: index)
      )
    }

    return HomeCalendarComponent.Configuration.Day(
      id: normalizedDate.ISO8601Format(),
      date: normalizedDate,
      dayText: String(context.calendar.component(.day, from: normalizedDate)),
      weekdayRole: weekdayRole(for: normalizedDate, calendar: context.calendar),
      isInCurrentMonth: context.calendar.isDate(normalizedDate, equalTo: context.month, toGranularity: .month),
      isSelected: context.calendar.isDate(normalizedDate, inSameDayAs: context.selectedDate),
      isToday: context.calendar.isDate(normalizedDate, inSameDayAs: context.today),
      badges: visibleBadges,
      hiddenBadgeCount: max(events.count - visibleBadges.count, 0)
    )
  }

  static func monthBar(
    for month: Date,
    calendar: Calendar
  ) -> HomeCalendarComponent.Configuration.MonthBar {
    let currentFormatter = DateFormatter()
    currentFormatter.locale = Locale.current
    currentFormatter.dateFormat = "yyyy년 M월"

    let sideFormatter = DateFormatter()
    sideFormatter.locale = Locale.current
    sideFormatter.dateFormat = "M월"

    let previousMonth = calendar.date(byAdding: .month, value: -1, to: month) ?? month
    let nextMonth = calendar.date(byAdding: .month, value: 1, to: month) ?? month

    return HomeCalendarComponent.Configuration.MonthBar(
      previousMonthTitle: sideFormatter.string(from: previousMonth),
      currentMonthTitle: currentFormatter.string(from: month),
      nextMonthTitle: sideFormatter.string(from: nextMonth)
    )
  }

  static func weekdayRole(
    for date: Date,
    calendar: Calendar
  ) -> HomeCalendarComponent.Configuration.WeekdayRole {
    let weekday = calendar.component(.weekday, from: date) - 1
    return weekdayRole(forWeekdayIndex: weekday)
  }

  static func weekdayRole(forWeekdayIndex index: Int) -> HomeCalendarComponent.Configuration.WeekdayRole {
    switch index {
    case 0:
      .sunday
    case 6:
      .saturday
    default:
      .weekday
    }
  }

  static func sortedEvents(_ events: [CalendarEvent]) -> [CalendarEvent] {
    events.sorted { lhs, rhs in
      if lhs.startDate == rhs.startDate {
        return lhs.title < rhs.title
      }

      return lhs.startDate < rhs.startDate
    }
  }

  static func badgeTitle(for event: CalendarEvent) -> String {
    let trimmedTitle = event.title.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedTitle.isEmpty ? "일정" : trimmedTitle
  }

  static func badgeStyle(
    for event: CalendarEvent,
    index: Int
  ) -> HomeCalendarComponent.Configuration.BadgeStyle {
    let palettes: [HomeCalendarComponent.Configuration.BadgeStyle] = [
      .green,
      .blue,
      .yellow,
      .red,
      .blueSoft,
      .orange,
      .purple,
      .pink
    ]
    let seed = stableHash(for: event.id.isEmpty ? event.title : event.id)
    return palettes[(seed + index) % palettes.count]
  }

  static func stableHash(for value: String) -> Int {
    value.unicodeScalars.reduce(0) { partialResult, scalar in
      (partialResult * 31 + Int(scalar.value)) % 1_000_000_007
    }
  }
}
