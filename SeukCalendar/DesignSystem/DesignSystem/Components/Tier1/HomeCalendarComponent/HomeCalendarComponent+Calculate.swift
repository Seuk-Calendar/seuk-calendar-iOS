import Foundation

enum HomeCalendarConfigurationBuilder {
  static let maxVisibleBadgeRows = 3

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
      return week(
        for: chunk,
        weekIndex: index / 7,
        context: context
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

  struct EventIdentity: Hashable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
  }

  struct PositionedBadgeSegment: Hashable {
    let id: String
    let badge: HomeCalendarComponent.Configuration.Badge
    let startIndex: Int
    let endIndex: Int
    let eventStartDate: Date
    let position: HomeCalendarComponent.Configuration.BadgeSegmentPosition

    var span: Int {
      endIndex - startIndex + 1
    }

    func overlaps(with other: PositionedBadgeSegment) -> Bool {
      !(endIndex < other.startIndex || other.endIndex < startIndex)
    }
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
    hiddenBadgeCount: Int,
    context: DayContext
  ) -> HomeCalendarComponent.Configuration.Day {
    let normalizedDate = context.calendar.startOfDay(for: date)
    let events = sortedEvents(context.eventsByDay[normalizedDate] ?? [])
    let visibleBadges = Array(events.prefix(maxVisibleBadgeRows)).map { event in
      HomeCalendarComponent.Configuration.Badge(
        id: event.id,
        title: badgeTitle(for: event),
        style: badgeStyle(for: event)
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
      hiddenBadgeCount: hiddenBadgeCount
    )
  }

  static func week(
    for dates: [Date],
    weekIndex: Int,
    context: DayContext
  ) -> HomeCalendarComponent.Configuration.Week {
    let (badgeRows, hiddenBadgeCounts) = badgeRows(
      for: dates,
      context: context
    )
    let days = dates.enumerated().map { index, date in
      day(
        for: date,
        hiddenBadgeCount: hiddenBadgeCounts[index],
        context: context
      )
    }

    return HomeCalendarComponent.Configuration.Week(
      id: "week-\(weekIndex)",
      days: days,
      badgeRows: badgeRows
    )
  }

  static func badgeRows(
    for dates: [Date],
    context: DayContext
  ) -> ([HomeCalendarComponent.Configuration.BadgeRow], [Int]) {
    let segments = positionedSegments(
      for: dates,
      context: context
    )
    let lanes = badgeLanes(for: segments)
    let visibleLanes = Array(lanes.prefix(maxVisibleBadgeRows))
    let rows = visibleLanes.enumerated().map { index, lane in
      HomeCalendarComponent.Configuration.BadgeRow(
        id: "badge-row-\(index)-\(dates.first?.ISO8601Format() ?? "week")",
        segments: lane.map { segment in
          HomeCalendarComponent.Configuration.BadgeSegment(
            id: segment.id,
            badge: segment.badge,
            startIndex: segment.startIndex,
            span: segment.span,
            position: segment.position
          )
        }
      )
    }
    let hiddenCounts = hiddenBadgeCounts(
      for: lanes,
      dayCount: dates.count
    )

    return (rows, hiddenCounts)
  }

  static func positionedSegments(
    for dates: [Date],
    context: DayContext
  ) -> [PositionedBadgeSegment] {
    let normalizedDates = dates.map(context.calendar.startOfDay(for:))
    var eventsByIdentity: [EventIdentity: (event: CalendarEvent, indexes: Set<Int>)] = [:]

    for (index, date) in normalizedDates.enumerated() {
      for event in context.eventsByDay[date] ?? [] {
        let identity = eventIdentity(for: event, calendar: context.calendar)
        if eventsByIdentity[identity] == nil {
          eventsByIdentity[identity] = (event, [index])
        } else {
          eventsByIdentity[identity]?.indexes.insert(index)
        }
      }
    }

    return eventsByIdentity.values.compactMap {
      makePositionedBadgeSegment(
        event: $0.event,
        indexes: $0.indexes,
        normalizedDates: normalizedDates,
        calendar: context.calendar
      )
    }
    .sorted { lhs, rhs in
      if lhs.startIndex == rhs.startIndex {
        if lhs.span == rhs.span {
          if lhs.eventStartDate == rhs.eventStartDate {
            return lhs.badge.title < rhs.badge.title
          }

          return lhs.eventStartDate < rhs.eventStartDate
        }

        return lhs.span > rhs.span
      }

      return lhs.startIndex < rhs.startIndex
    }
  }

  static func badgeLanes(
    for segments: [PositionedBadgeSegment]
  ) -> [[PositionedBadgeSegment]] {
    var lanes: [[PositionedBadgeSegment]] = []

    for segment in segments {
      if let laneIndex = lanes.firstIndex(where: { lane in
        lane.allSatisfy { !$0.overlaps(with: segment) }
      }) {
        lanes[laneIndex].append(segment)
      } else {
        lanes.append([segment])
      }
    }

    return lanes
  }

  static func badgeSegmentPosition(
    eventStartDate: Date,
    eventEndDate: Date,
    visibleStartDate: Date,
    visibleEndDate: Date
  ) -> HomeCalendarComponent.Configuration.BadgeSegmentPosition {
    let startsInVisibleRange = eventStartDate == visibleStartDate
    let endsInVisibleRange = eventEndDate == visibleEndDate

    switch (startsInVisibleRange, endsInVisibleRange) {
    case (true, true):
      return .startAndEnd
    case (true, false):
      return .start
    case (false, true):
      return .end
    case (false, false):
      return .middle
    }
  }

  static func makePositionedBadgeSegment(
    event: CalendarEvent,
    indexes: Set<Int>,
    normalizedDates: [Date],
    calendar: Calendar
  ) -> PositionedBadgeSegment? {
    let sortedIndexes = indexes.sorted()
    guard let startIndex = sortedIndexes.first,
          let endIndex = sortedIndexes.last else {
      return nil
    }

    let eventStartDate = calendar.startOfDay(for: event.startDate)
    let eventEndDate = calendar.startOfDay(for: event.endDate)
    let visibleStartDate = normalizedDates[startIndex]
    let visibleEndDate = normalizedDates[endIndex]
    let badge = HomeCalendarComponent.Configuration.Badge(
      id: event.id,
      title: badgeTitle(for: event),
      style: badgeStyle(for: event)
    )

    return PositionedBadgeSegment(
      id: segmentID(for: event, weekStart: visibleStartDate),
      badge: badge,
      startIndex: startIndex,
      endIndex: endIndex,
      eventStartDate: eventStartDate,
      position: badgeSegmentPosition(
        eventStartDate: eventStartDate,
        eventEndDate: eventEndDate,
        visibleStartDate: visibleStartDate,
        visibleEndDate: visibleEndDate
      )
    )
  }

  static func hiddenBadgeCounts(
    for lanes: [[PositionedBadgeSegment]],
    dayCount: Int
  ) -> [Int] {
    guard dayCount > 0 else {
      return []
    }

    let visibleLanes = Array(lanes.prefix(maxVisibleBadgeRows))
    var totalCounts = Array(repeating: 0, count: dayCount)
    var visibleCounts = Array(repeating: 0, count: dayCount)

    for lane in lanes {
      applyCounts(of: lane, to: &totalCounts)
    }

    for lane in visibleLanes {
      applyCounts(of: lane, to: &visibleCounts)
    }

    return zip(totalCounts, visibleCounts).map { total, visible in
      max(total - visible, 0)
    }
  }

  static func applyCounts(
    of lane: [PositionedBadgeSegment],
    to counts: inout [Int]
  ) {
    for segment in lane {
      for index in segment.startIndex ... segment.endIndex {
        counts[index] += 1
      }
    }
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

  static func badgeStyle(for event: CalendarEvent) -> HomeCalendarComponent.Configuration.BadgeStyle {
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
    return palettes[seed % palettes.count]
  }

  static func eventIdentity(
    for event: CalendarEvent,
    calendar: Calendar
  ) -> EventIdentity {
    EventIdentity(
      id: event.id,
      title: event.title,
      startDate: calendar.startOfDay(for: event.startDate),
      endDate: calendar.startOfDay(for: event.endDate),
      isAllDay: event.isAllDay
    )
  }

  static func segmentID(
    for event: CalendarEvent,
    weekStart: Date
  ) -> String {
    let base = event.id.isEmpty ? event.title : event.id
    return "\(base)-\(weekStart.ISO8601Format())"
  }

  static func stableHash(for value: String) -> Int {
    value.unicodeScalars.reduce(0) { partialResult, scalar in
      (partialResult * 31 + Int(scalar.value)) % 1_000_000_007
    }
  }
}
