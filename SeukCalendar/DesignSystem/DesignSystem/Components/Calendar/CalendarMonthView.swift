import SwiftUI

public struct CalendarMonthView: View {
  public let month: Date
  public let selectedDate: Date
  public let eventsByDay: [Date: [CalendarEvent]]
  public var calendar: Calendar
  public var onSelectDate: (Date) -> Void

  public init(
    month: Date,
    selectedDate: Date,
    eventsByDay: [Date: [CalendarEvent]],
    calendar: Calendar = .current,
    onSelectDate: @escaping (Date) -> Void
  ) {
    self.month = month
    self.selectedDate = selectedDate
    self.eventsByDay = eventsByDay
    self.calendar = calendar
    self.onSelectDate = onSelectDate
  }

  public var body: some View {
    VStack(spacing: 8) {
      weekdayHeader

      LazyVGrid(columns: columns, spacing: 8) {
        ForEach(monthGridDates, id: \.self) { date in
          let normalizedDate = calendar.startOfDay(for: date)
          DateCell(
            dayText: String(calendar.component(.day, from: date)),
            isSelected: calendar.isDate(normalizedDate, inSameDayAs: selectedDate),
            isToday: calendar.isDateInToday(normalizedDate),
            isInCurrentMonth: calendar.isDate(normalizedDate, equalTo: month, toGranularity: .month),
            eventCount: eventsByDay[normalizedDate]?.count ?? 0,
            action: { onSelectDate(normalizedDate) }
          )
        }
      }
    }
  }
}

private extension CalendarMonthView {
  var columns: [GridItem] {
    Array(repeating: GridItem(.flexible(minimum: 0), spacing: 8), count: 7)
  }

  var weekdayHeader: some View {
    HStack(spacing: 8) {
      ForEach(weekdaySymbols, id: \.self) { symbol in
        Text(symbol)
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity)
      }
    }
  }

  var weekdaySymbols: [String] {
    let symbols = calendar.veryShortStandaloneWeekdaySymbols
    let firstWeekdayIndex = max(min(calendar.firstWeekday - 1, symbols.count - 1), 0)
    let head = Array(symbols[firstWeekdayIndex...])
    let tail = Array(symbols[..<firstWeekdayIndex])
    return head + tail
  }

  var monthGridDates: [Date] {
    guard let monthInterval = calendar.dateInterval(of: .month, for: month),
          let firstWeekInterval = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
          let lastMomentOfMonth = calendar.date(byAdding: .second, value: -1, to: monthInterval.end),
          let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: lastMomentOfMonth)
    else {
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
}
