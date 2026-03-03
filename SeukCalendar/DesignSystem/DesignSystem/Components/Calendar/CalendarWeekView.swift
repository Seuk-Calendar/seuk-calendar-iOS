import SwiftUI

public struct CalendarWeekView: View {
  public let referenceDate: Date
  public let selectedDate: Date
  public let eventsByDay: [Date: [CalendarEvent]]
  public var calendar: Calendar
  public var onSelectDate: (Date) -> Void
  public var onSelectEvent: (CalendarEvent) -> Void

  public init(
    referenceDate: Date,
    selectedDate: Date,
    eventsByDay: [Date: [CalendarEvent]],
    calendar: Calendar = .current,
    onSelectDate: @escaping (Date) -> Void,
    onSelectEvent: @escaping (CalendarEvent) -> Void
  ) {
    self.referenceDate = referenceDate
    self.selectedDate = selectedDate
    self.eventsByDay = eventsByDay
    self.calendar = calendar
    self.onSelectDate = onSelectDate
    self.onSelectEvent = onSelectEvent
  }

  public var body: some View {
    VStack(spacing: 12) {
      HStack(spacing: 8) {
        ForEach(weekDates, id: \.self) { date in
          let normalizedDate = calendar.startOfDay(for: date)

          DateCell(
            dayText: "\(calendar.component(.day, from: normalizedDate))",
            isSelected: calendar.isDate(normalizedDate, inSameDayAs: selectedDate),
            isToday: calendar.isDateInToday(normalizedDate),
            isInCurrentMonth: true,
            eventCount: eventsByDay[normalizedDate]?.count ?? 0,
            action: {
              onSelectDate(normalizedDate)
            }
          )
        }
      }

      Divider()

      CalendarDayView(
        date: selectedDate,
        events: eventsForSelectedDate,
        calendar: calendar,
        showDateHeader: false,
        onSelectEvent: onSelectEvent
      )
    }
  }
}

private extension CalendarWeekView {
  var weekDates: [Date] {
    guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: referenceDate) else {
      return []
    }

    return (0..<7).compactMap {
      calendar.date(byAdding: .day, value: $0, to: weekInterval.start)
    }
  }

  var eventsForSelectedDate: [CalendarEvent] {
    let key = calendar.startOfDay(for: selectedDate)
    return eventsByDay[key] ?? []
  }
}
