import SwiftUI
import WidgetKit

struct WidgetScheduleSnapshot: Codable {
  struct Item: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
    let location: String?
  }

  let generatedAt: Date
  let items: [Item]

  static let empty = WidgetScheduleSnapshot(generatedAt: Date(), items: [])

  static var placeholderReferenceDate: Date {
    let calendar = WidgetCalendarFactory.calendar
    let today = Date()
    let components = calendar.dateComponents([.year, .month], from: today)

    return calendar.date(
      from: DateComponents(
        year: components.year,
        month: components.month,
        day: 3,
        hour: 9
      )
    ) ?? today
  }

  static func placeholder(for referenceDate: Date) -> WidgetScheduleSnapshot {
    let calendar = WidgetCalendarFactory.calendar
    let dayStart = calendar.startOfDay(for: referenceDate)
    let weekStart = calendar.dateInterval(of: .weekOfYear, for: dayStart)?.start ?? dayStart

    func date(
      dayOffset: Int,
      hour: Int,
      minute: Int = 0
    ) -> Date {
      let baseDate = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) ?? weekStart
      return calendar.date(
        bySettingHour: hour,
        minute: minute,
        second: 0,
        of: baseDate
      ) ?? baseDate
    }

    return WidgetScheduleSnapshot(
      generatedAt: referenceDate,
      items: [
        Item(
          id: "placeholder-single-1",
          title: "하루 일정",
          startDate: date(dayOffset: 0, hour: 10),
          endDate: date(dayOffset: 0, hour: 11),
          isAllDay: false,
          location: nil
        ),
        Item(
          id: "placeholder-multi",
          title: "연속 시작",
          startDate: date(dayOffset: 2, hour: 9),
          endDate: date(dayOffset: 4, hour: 18),
          isAllDay: false,
          location: nil
        ),
        Item(
          id: "placeholder-single-2",
          title: "하루 일정",
          startDate: date(dayOffset: 4, hour: 10),
          endDate: date(dayOffset: 4, hour: 11),
          isAllDay: false,
          location: nil
        ),
        Item(
          id: "placeholder-overflow-1",
          title: "추가 일정",
          startDate: date(dayOffset: 4, hour: 12),
          endDate: date(dayOffset: 4, hour: 13),
          isAllDay: false,
          location: nil
        ),
        Item(
          id: "placeholder-overflow-2",
          title: "추가 일정",
          startDate: date(dayOffset: 4, hour: 14),
          endDate: date(dayOffset: 4, hour: 15),
          isAllDay: false,
          location: nil
        ),
        Item(
          id: "placeholder-next-week",
          title: "다음 주 일정",
          startDate: date(dayOffset: 8, hour: 11),
          endDate: date(dayOffset: 8, hour: 12),
          isAllDay: false,
          location: nil
        )
      ]
    )
  }

  func events(on date: Date, calendar: Calendar = .current) -> [Item] {
    let dayStart = calendar.startOfDay(for: date)
    let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart

    return items
      .filter { item in
        item.startDate < dayEnd && item.endDate > dayStart
      }
      .sorted(by: { lhs, rhs in
        if lhs.startDate == rhs.startDate {
          return lhs.title < rhs.title
        }
        return lhs.startDate < rhs.startDate
      })
  }

  func nextEvent(after referenceDate: Date) -> Item? {
    items
      .filter { $0.endDate > referenceDate }
      .sorted(by: { $0.startDate < $1.startDate })
      .first
  }

  func remainingEventCount(
    after referenceDate: Date,
    on date: Date,
    calendar: Calendar = .current
  ) -> Int {
    events(on: date, calendar: calendar)
      .filter { $0.endDate > referenceDate }
      .count
  }
}
