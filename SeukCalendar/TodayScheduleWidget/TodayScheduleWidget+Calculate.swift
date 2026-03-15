import DesignSystem
import Foundation
import SwiftUI

extension TodayScheduleWidgetEntryView {
  var todayEvents: [WidgetScheduleSnapshot.Item] {
    entry.snapshot.events(on: entry.date, calendar: calendar)
  }

  var nextEvent: WidgetScheduleSnapshot.Item? {
    entry.snapshot.nextEvent(after: entry.date)
  }

  var upcomingTodayEvents: [WidgetScheduleSnapshot.Item] {
    todayEvents.filter { $0.endDate > entry.date }
  }

  var remainingTodayCount: Int {
    entry.snapshot.remainingEventCount(after: entry.date, on: entry.date, calendar: calendar)
  }

  var widgetTitleText: String {
    WidgetFormatters.widgetTitleFormatter.string(from: entry.date)
  }

  var mediumComponentConfiguration: WidgetMediumComponent.Configuration {
    WidgetMediumComponent.Configuration(
      title: widgetTitleText,
      dayCells: weekDates.map(makeDayCellConfiguration(for:))
    )
  }

  var largeCalendarWeeks: [[WidgetDayCell.Configuration]] {
    monthWeeks.map { $0.map(makeWidgetDayCellConfiguration(for:)) }
  }

  var weekdayHeaderConfiguration: WidgetCalendarWeekdayHeader.Configuration {
    WidgetCalendarWeekdayHeader.Configuration(
      locale: calendar.locale ?? Locale(identifier: "ko_KR")
    )
  }

  var weekDates: [Date] {
    let reference = calendar.dateInterval(of: .weekOfYear, for: entry.date)?.start ?? calendar
      .startOfDay(for: entry.date)
    return (0 ..< 7).compactMap { offset in
      calendar.date(byAdding: .day, value: offset, to: reference)
    }
  }

  var monthWeeks: [[Date]] {
    let monthStart = calendar.dateInterval(of: .month, for: entry.date)?.start ?? calendar.startOfDay(for: entry.date)
    let gridStart = calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart

    return (0 ..< 5).map { weekOffset in
      (0 ..< 7).compactMap { dayOffset in
        calendar.date(byAdding: .day, value: (weekOffset * 7) + dayOffset, to: gridStart)
      }
    }
  }

  func makeDayCellConfiguration(for date: Date) -> WidgetDayCellComponent.Configuration {
    WidgetDayCellComponent.Configuration(
      date: date,
      isToday: calendar.isDate(date, inSameDayAs: entry.date),
      dayTextColor: dayTextColor(for: date),
      segments: badgeSegmentConfigurations(for: date)
    )
  }

  func dayTextColor(for date: Date) -> Color {
    if calendar.isDate(date, inSameDayAs: entry.date) {
      return .semantic.Content.contentPrimary
    }

    switch calendar.component(.weekday, from: date) {
    case 1:
      return .semanticExtensions.Content.contentNegative
    case 7:
      return .semanticExtensions.Content.contentAccent
    default:
      return .semantic.Content.contentSecondary
    }
  }

  func badgeSegmentConfigurations(for date: Date) -> [BadgeSegmentComponent.Configuration] {
    entry.snapshot.events(on: date, calendar: calendar).map { event in
      let variant = badgeVariant(for: event, on: date)
      let colors = badgeColors(for: variant)

      return BadgeSegmentComponent.Configuration(
        variant: variant,
        label: variant.showsMetadata ? event.title : nil,
        foregroundColor: colors.foreground,
        backgroundColor: colors.background,
        showsLeadingStrip: variant.showsMetadata
      )
    }
  }

  func badgeVariant(
    for event: WidgetScheduleSnapshot.Item,
    on date: Date
  ) -> BadgeSegmentComponent.Configuration.Variant {
    let dayStart = calendar.startOfDay(for: date)
    let nextDayStart = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart

    let continuesFromPreviousDay = event.startDate < dayStart
    let continuesIntoNextDay = event.endDate > nextDayStart

    switch (continuesFromPreviousDay, continuesIntoNextDay) {
    case (false, false):
      return .startAndEnd
    case (false, true):
      return .start
    case (true, true):
      return .middle
    case (true, false):
      return .end
    }
  }

  func badgeColors(
    for variant: BadgeSegmentComponent.Configuration.Variant
  ) -> (foreground: Color, background: Color) {
    switch variant {
    case .startAndEnd:
      return (.primitives.teal800, .primitives.green50)
    case .start, .middle, .end:
      return (.primitives.blue700, .primitives.blue100)
    @unknown default:
      return (.primitives.blue700, .primitives.blue100)
    }
  }

  func timeText(for event: WidgetScheduleSnapshot.Item) -> String {
    if event.isAllDay {
      return "종일"
    }

    return WidgetFormatters.timeFormatter.string(from: event.startDate)
  }

  func makeWidgetDayCellConfiguration(for date: Date) -> WidgetDayCell.Configuration {
    WidgetDayCell.Configuration(
      dayNumber: String(calendar.component(.day, from: date)),
      state: widgetDayCellState(for: date),
      badges: widgetBadgeConfigurations(for: date)
    )
  }

  func widgetDayCellState(for date: Date) -> WidgetDayCell.Configuration.State {
    if calendar.isDate(date, inSameDayAs: entry.date) {
      return .today
    }

    if !calendar.isDate(date, equalTo: entry.date, toGranularity: .month) {
      return .otherMonth
    }

    switch calendar.component(.weekday, from: date) {
    case 1:
      return .holiday
    case 7:
      return .saturday
    default:
      return .default
    }
  }

  func widgetBadgeConfigurations(for date: Date) -> [WidgetBadge.Configuration] {
    entry.snapshot.events(on: date, calendar: calendar).map { event in
      let state = widgetBadgeState(for: event, on: date)
      let showsLeadingMetadata = isWeekSegmentStart(for: event, on: date)

      return WidgetBadge.Configuration(
        state: state,
        title: widgetBadgeTitle(
          for: event,
          state: state,
          showsLeadingMetadata: showsLeadingMetadata
        ),
        showsLeadingMetadata: showsLeadingMetadata
      )
    }
  }

  func widgetBadgeState(
    for event: WidgetScheduleSnapshot.Item,
    on date: Date
  ) -> WidgetBadge.Configuration.State {
    let dayStart = calendar.startOfDay(for: date)
    let nextDayStart = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart

    let continuesFromPreviousDay = event.startDate < dayStart
    let continuesIntoNextDay = event.endDate > nextDayStart

    switch (continuesFromPreviousDay, continuesIntoNextDay) {
    case (false, false):
      return .allDay
    case (false, true):
      return .start
    case (true, true):
      return .middle
    case (true, false):
      return .end
    }
  }

  func isWeekSegmentStart(
    for event: WidgetScheduleSnapshot.Item,
    on date: Date
  ) -> Bool {
    let dayStart = calendar.startOfDay(for: date)
    let weekStart = calendar.dateInterval(of: .weekOfYear, for: dayStart)?.start ?? dayStart

    return calendar.isDate(dayStart, inSameDayAs: weekStart) && event.startDate < dayStart
  }

  func widgetBadgeTitle(
    for event: WidgetScheduleSnapshot.Item,
    state: WidgetBadge.Configuration.State,
    showsLeadingMetadata: Bool
  ) -> String? {
    if state == .allDay || state == .start || showsLeadingMetadata {
      return event.title
    }

    return nil
  }
}

private extension BadgeSegmentComponent.Configuration.Variant {
  var showsMetadata: Bool {
    switch self {
    case .startAndEnd, .start:
      true
    case .middle, .end:
      false
    @unknown default:
      false
    }
  }
}
