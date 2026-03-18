@testable import DesignSystem
import Foundation
import Testing

struct WidgetComponentTests {
  @Test("WidgetWeekdayRowConfiguration_기본값은_한국어_요일입니다")
  func widgetWeekdayRowDefaultsToKoreanWeekdays() {
    let configuration = WidgetWeekdayRowComponent.Configuration()

    #expect(configuration.weekdayItems.map(\.title) == ["일", "월", "화", "수", "목", "금", "토"])
  }

  @Test("WidgetWeekdayRowConfiguration_로케일에_맞는_요일을_생성합니다")
  func widgetWeekdayRowBuildsWeekdaysForLocale() {
    let configuration = WidgetWeekdayRowComponent.Configuration(locale: Locale(identifier: "en_US"))

    #expect(configuration.weekdayItems.map(\.title) == ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
  }

  @Test("WidgetDayCellConfiguration_직접_노출_일정은_두_개로_제한하고_overflow를_합산합니다")
  func widgetDayCellLimitsVisibleSegmentsAndCombinesOverflow() {
    let configuration = WidgetDayCellComponent.Configuration(
      date: Self.sampleDate,
      isToday: false,
      dayTextColor: .semantic.Content.primary,
      segments: [
        Self.segment(label: "첫 일정"),
        Self.segment(label: "둘 일정"),
        Self.segment(label: "셋 일정")
      ],
      overflowCount: 2
    )

    #expect(configuration.visibleSegments.count == 2)
    #expect(configuration.resolvedOverflowCount == 3)
    #expect(configuration.hasSchedules == true)
  }

  @Test("WidgetMediumConfiguration_모든_셀에_일정이_없으면_empty_state입니다")
  func widgetMediumRecognizesEmptyStateFromConfiguration() {
    let configuration = WidgetMediumComponent.Configuration(
      title: "2026년 3월 3일 화요일",
      dayCells: [0, 1, 2, 3, 4, 5, 6].map { index in
        WidgetDayCellComponent.Configuration(
          date: Self.calendar.date(byAdding: .day, value: index, to: Self.sampleDate) ?? Self.sampleDate,
          isToday: false,
          dayTextColor: .semantic.Content.secondary
        )
      }
    )

    #expect(configuration.isEmptyState == true)
  }

  @Test("WidgetLargeConfiguration_기준_월이_아닌_날짜는_숨김_처리합니다")
  func widgetLargeHidesDatesOutsidePrimaryMonth() {
    let baseDate = Self.calendar.date(from: DateComponents(year: 2026, month: 3, day: 1)) ?? Self.sampleDate
    let configuration = WidgetLargeComponent.Configuration(
      title: "2026년 3월 3일 화요일",
      weeks: [0, 1, 2, 3, 4].map { weekIndex in
        [0, 1, 2, 3, 4, 5, 6].map { dayIndex in
          WidgetDayCellComponent.Configuration(
            date: Self.calendar.date(byAdding: .day, value: (weekIndex * 7) + dayIndex, to: baseDate) ?? baseDate,
            isToday: false,
            dayTextColor: .semantic.Content.secondary
          )
        }
      }
    )

    #expect(configuration.visibleWeeks.last != nil)
    guard let lastWeek = configuration.visibleWeeks.last else { return }

    #expect(lastWeek.prefix(3).compactMap { $0?.dayText } == ["29", "30", "31"])
    #expect(lastWeek.suffix(4).allSatisfy { $0 == nil })
  }

  @Test("MoreWrapConfiguration_count가_0이하면_표시_텍스트가_nil입니다")
  func moreWrapHidesNonPositiveCounts() {
    #expect(MoreWrapComponent.Configuration(count: 0).displayText == nil)
    #expect(MoreWrapComponent.Configuration(count: -1).displayText == nil)
    #expect(MoreWrapComponent.Configuration(count: 3).displayText == "+3")
  }
}

private extension WidgetComponentTests {
  static var calendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    return calendar
  }

  static let sampleDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 3)) ?? .now

  static func segment(label: String) -> BadgeSegmentComponent.Configuration {
    BadgeSegmentComponent.Configuration(
      variant: .startAndEnd,
      label: label,
      foregroundColor: .primitives.teal800,
      backgroundColor: .primitives.green50,
      showsLeadingStrip: true
    )
  }
}
