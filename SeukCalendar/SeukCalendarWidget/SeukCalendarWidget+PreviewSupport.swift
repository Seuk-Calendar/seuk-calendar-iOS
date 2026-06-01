import SwiftUI

enum SeukCalendarWidgetPreviewFactory {
  static var calendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    calendar.firstWeekday = 1
    return calendar
  }

  static var previewDate: Date {
    date(month: 5, day: 15, hour: 9)
  }

  static var mediumPreviewDate: Date {
    date(month: 5, day: 15, hour: 9)
  }

  static var mediumPreviewEntry: SeukCalendarEntry {
    SeukCalendarEntry(
      date: mediumPreviewDate,
      snapshot: mediumPreviewSnapshot,
      showsPlaceholderPreview: false
    )
  }

  static var smallPreviewEntry: SeukCalendarEntry {
    SeukCalendarEntry(
      date: mediumPreviewDate,
      snapshot: smallPreviewSnapshot,
      showsPlaceholderPreview: false
    )
  }

  static var largePreviewEntry: SeukCalendarEntry {
    SeukCalendarEntry(
      date: previewDate,
      snapshot: largePreviewSnapshot,
      showsPlaceholderPreview: false
    )
  }

  static var largePreviewSnapshot: WidgetScheduleSnapshot {
    WidgetScheduleSnapshot(
      generatedAt: previewDate,
      items: previewItems
    )
  }

  static var mediumPreviewSnapshot: WidgetScheduleSnapshot {
    WidgetScheduleSnapshot(
      generatedAt: mediumPreviewDate,
      items: mediumPreviewItems
    )
  }

  static var smallPreviewSnapshot: WidgetScheduleSnapshot {
    WidgetScheduleSnapshot(
      generatedAt: mediumPreviewDate,
      items: smallPreviewItems
    )
  }

  static var previewItems: [WidgetScheduleSnapshot.Item] {
    [
      allDayItem(
        id: "preview-holiday-1",
        title: "노동절",
        month: 5,
        day: 1
      ),
      timedItem(
        id: "preview-holiday-2",
        title: "가족 점심",
        month: 5,
        day: 1,
        startHour: 12,
        endHour: 13
      ),
      timedItem(
        id: "preview-holiday-3",
        title: "추가 일정",
        month: 5,
        day: 1,
        startHour: 16,
        endHour: 17
      ),
      allDayItem(
        id: "preview-saturday",
        title: "토요 일정",
        month: 5,
        day: 9
      ),
      spanningItem(
        id: "preview-week-span",
        title: "제주도 여행",
        startMonth: 5,
        startDay: 3,
        endMonth: 5,
        endDay: 6
      ),
      timedItem(
        id: "preview-single-1",
        title: "디자인 리뷰",
        month: 5,
        day: 12,
        startHour: 10,
        endHour: 11
      ),
      timedItem(
        id: "preview-single-2",
        title: "알바",
        month: 5,
        day: 12,
        startHour: 15,
        endHour: 16
      ),
      spanningItem(
        id: "preview-spanning-2",
        title: "테스트4",
        startMonth: 5,
        startDay: 13,
        endMonth: 3,
        endDay: 18
      ),
      spanningItem(
        id: "preview-spanning-3",
        title: "테스트5",
        startMonth: 5,
        startDay: 14,
        endMonth: 3,
        endDay: 16
      ),
      timedItem(
        id: "preview-overflow-today",
        title: "주간 회고",
        month: 5,
        day: 15,
        startHour: 13,
        endHour: 14
      ),
      timedItem(
        id: "preview-single-3",
        title: "저녁 약속",
        month: 5,
        day: 18,
        startHour: 18,
        endHour: 19
      ),
      spanningItem(
        id: "preview-spanning-4",
        title: "테스트6",
        startMonth: 5,
        startDay: 20,
        endMonth: 4,
        endDay: 1
      ),
      timedItem(
        id: "preview-single-4",
        title: "알바 대타",
        month: 5,
        day: 22,
        startHour: 12,
        endHour: 13
      ),
      allDayItem(
        id: "preview-single-5",
        title: "엄마 생일",
        month: 5,
        day: 25
      ),
      allDayItem(
        id: "preview-single-6",
        title: "월말 정리",
        month: 5,
        day: 29
      ),
      timedItem(
        id: "preview-other-month",
        title: "다음 달 준비",
        month: 5,
        day: 2,
        startHour: 10,
        endHour: 11
      ),
    ].sorted { lhs, rhs in
      if lhs.startDate == rhs.startDate {
        return lhs.title < rhs.title
      }
      return lhs.startDate < rhs.startDate
    }
  }

  static var mediumPreviewItems: [WidgetScheduleSnapshot.Item] {
    [
      allDayItem(id: "medium-01-1", title: "하루 일정", month: 5, day: 1),
      allDayItem(id: "medium-01-2", title: "하루 일정", month: 5, day: 1),
      timedItem(id: "medium-01-3", title: "하루 일정", month: 5, day: 1, startHour: 12, endHour: 13),
      timedItem(id: "medium-01-4", title: "하루 일정", month: 5, day: 1, startHour: 15, endHour: 16),

      allDayItem(id: "medium-02-1", title: "하루 일정", month: 5, day: 2),
      allDayItem(id: "medium-02-2", title: "하루 일정", month: 5, day: 2),
      timedItem(id: "medium-02-3", title: "하루 일정", month: 5, day: 2, startHour: 12, endHour: 13),
      timedItem(id: "medium-02-4", title: "하루 일정", month: 5, day: 2, startHour: 15, endHour: 16),

      allDayItem(id: "medium-03-1", title: "하루 일정", month: 5, day: 3),
      allDayItem(id: "medium-03-2", title: "하루 일정", month: 5, day: 3),
      timedItem(id: "medium-03-3", title: "하루 일정", month: 5, day: 3, startHour: 12, endHour: 13),
      timedItem(id: "medium-03-4", title: "하루 일정", month: 5, day: 3, startHour: 15, endHour: 16),

      spanningItem(
        id: "medium-span-1",
        title: "연속 시작",
        startMonth: 5,
        startDay: 4,
        endMonth: 5,
        endDay: 6
      ),
      allDayItem(id: "medium-04-1", title: "하루 일정", month: 5, day: 4),
      timedItem(id: "medium-04-2", title: "하루 일정", month: 5, day: 4, startHour: 12, endHour: 13),
      timedItem(id: "medium-04-3", title: "하루 일정", month: 5, day: 4, startHour: 15, endHour: 16),

      allDayItem(id: "medium-05-1", title: "하루 일정", month: 5, day: 5),
      timedItem(id: "medium-05-2", title: "하루 일정", month: 5, day: 5, startHour: 12, endHour: 13),
      timedItem(id: "medium-05-3", title: "하루 일정", month: 5, day: 5, startHour: 15, endHour: 16),

      allDayItem(id: "medium-06-1", title: "하루 일정", month: 5, day: 6),
      timedItem(id: "medium-06-2", title: "하루 일정", month: 5, day: 6, startHour: 12, endHour: 13),
      timedItem(id: "medium-06-3", title: "하루 일정", month: 5, day: 6, startHour: 15, endHour: 16),

      allDayItem(id: "medium-07-1", title: "하루 일정", month: 5, day: 7),
      allDayItem(id: "medium-07-2", title: "하루 일정", month: 5, day: 7),
      timedItem(id: "medium-07-3", title: "하루 일정", month: 5, day: 7, startHour: 12, endHour: 13),
      timedItem(id: "medium-07-4", title: "하루 일정", month: 5, day: 7, startHour: 15, endHour: 16),
    ].sorted { lhs, rhs in
      if lhs.startDate == rhs.startDate {
        return lhs.title < rhs.title
      }
      return lhs.startDate < rhs.startDate
    }
  }

  static var smallPreviewItems: [WidgetScheduleSnapshot.Item] {
    [
      timedItem(
        id: "small-01",
        title: "제목 길이 테스트",
        month: 5,
        day: 3,
        startHour: 11,
        endHour: 12
      ),
      timedItem(
        id: "small-02",
        title: "저녁 약속",
        month: 5,
        day: 3,
        startHour: 17,
        endHour: 18
      ),
      allDayItem(
        id: "small-03",
        title: "시작 시간 없는 종일 일정",
        month: 5,
        day: 3
      ),
      allDayItem(
        id: "small-04",
        title: "추가 일정 1",
        month: 5,
        day: 3
      ),
      allDayItem(
        id: "small-05",
        title: "추가 일정 2",
        month: 5,
        day: 3
      ),
    ].sorted { lhs, rhs in
      if lhs.startDate == rhs.startDate {
        return lhs.title < rhs.title
      }
      return lhs.startDate < rhs.startDate
    }
  }

  static func allDayItem(
    id: String,
    title: String,
    month: Int,
    day: Int
  ) -> WidgetScheduleSnapshot.Item {
    let targetDate = date(month: month, day: day, hour: 0)

    return WidgetScheduleSnapshot.Item(
      id: id,
      title: title,
      startDate: allDayStart(on: targetDate),
      endDate: allDayEnd(on: targetDate),
      isAllDay: true,
      location: nil
    )
  }

  static func timedItem(
    id: String,
    title: String,
    month: Int,
    day: Int,
    startHour: Int,
    endHour: Int
  ) -> WidgetScheduleSnapshot.Item {
    WidgetScheduleSnapshot.Item(
      id: id,
      title: title,
      startDate: date(month: month, day: day, hour: startHour),
      endDate: date(month: month, day: day, hour: endHour),
      isAllDay: false,
      location: nil
    )
  }

  static func spanningItem(
    id: String,
    title: String,
    startMonth: Int,
    startDay: Int,
    endMonth: Int,
    endDay: Int
  ) -> WidgetScheduleSnapshot.Item {
    WidgetScheduleSnapshot.Item(
      id: id,
      title: title,
      startDate: date(month: startMonth, day: startDay, hour: 9),
      endDate: date(month: endMonth, day: endDay, hour: 18),
      isAllDay: false,
      location: nil
    )
  }

  static func allDayStart(on date: Date) -> Date {
    calendar.startOfDay(for: date)
  }

  static func allDayEnd(on date: Date) -> Date {
    calendar.date(bySettingHour: 23, minute: 59, second: 0, of: date) ?? date
  }

  static func date(month: Int, day: Int, hour: Int) -> Date {
    calendar.date(
      from: DateComponents(
        year: 2026,
        month: month,
        day: day,
        hour: hour,
        minute: 0
      )
    ) ?? previewDate
  }
}
