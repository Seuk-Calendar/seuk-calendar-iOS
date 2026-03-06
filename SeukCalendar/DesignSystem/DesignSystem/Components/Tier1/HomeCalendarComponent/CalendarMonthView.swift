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
    HomeCalendarComponent(
      configuration: HomeCalendarConfigurationBuilder.makeConfiguration(
        month: month,
        selectedDate: selectedDate,
        eventsByDay: eventsByDay,
        calendar: calendar,
        showsMonthBar: false
      ),
      eventListener: { event in
        guard case let .tapDate(date) = event else {
          return
        }

        onSelectDate(date)
      }
    )
  }
}
