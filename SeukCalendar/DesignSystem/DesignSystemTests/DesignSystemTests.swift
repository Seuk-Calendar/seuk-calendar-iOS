@testable import DesignSystem
import Foundation
import Testing

struct DesignSystemTests {
  @Test("DesignSystem_번들에_포함된_모든_폰트가_등록됩니다")
  func registersAllBundledFonts() {
    FontManager.shared.register()

    let bundledFontNames = Self.bundledFontNames
    let unresolvedFontNames = bundledFontNames.filter { PlatformFont(name: $0, size: 12) == nil }

    #expect(bundledFontNames.isEmpty == false)
    #expect(unresolvedFontNames.isEmpty)
  }

  @Test("makeConfiguration_월간_그리드와_선택일_상태를_생성합니다")
  func makeConfigurationBuildsMonthGridAndSelectionState() {
    let configuration = HomeCalendarConfigurationBuilder.makeConfiguration(
      month: Self.month,
      selectedDate: Self.selectedDate,
      eventsByDay: Self.eventsByDay,
      calendar: Self.fixedCalendar,
      showsMonthBar: true,
      today: Self.today
    )

    let days = configuration.weeks.flatMap(\.days)
    let selectedDay = days.first(where: { $0.date == Self.selectedDate })
    let todayDay = days.first(where: { $0.date == Self.today })
    let tripWeek = configuration.weeks.first(where: { week in
      week.days.contains(where: { $0.date == Self.today })
    })
    let tripSegment = tripWeek?.badgeRows
      .flatMap(\.segments)
      .first(where: { $0.badge.id == "trip" })
    let carryoverFirstWeek = configuration.weeks.first(where: { week in
      week.days.contains(where: { Self.fixedCalendar.component(.day, from: $0.date) == 14 })
    })
    let carryoverSecondWeek = configuration.weeks.first(where: { week in
      week.days.contains(where: { Self.fixedCalendar.component(.day, from: $0.date) == 15 })
    })
    let carryoverStartSegment = carryoverFirstWeek?.badgeRows
      .flatMap(\.segments)
      .first(where: { $0.badge.id == "carryover-trip" })
    let carryoverEndSegment = carryoverSecondWeek?.badgeRows
      .flatMap(\.segments)
      .first(where: { $0.badge.id == "carryover-trip" })

    #expect(configuration.monthBar?.previousMonthTitle == "1월")
    #expect(configuration.monthBar?.currentMonthTitle == "2026년 2월")
    #expect(configuration.monthBar?.nextMonthTitle == "3월")
    #expect(configuration.weekdays.map(\.title) == ["일", "월", "화", "수", "목", "금", "토"])
    #expect(configuration.weeks.count == 4)
    #expect(selectedDay?.isSelected == true)
    #expect(selectedDay?.badges.count == 3)
    #expect(selectedDay?.hiddenBadgeCount == 1)
    #expect(todayDay?.isToday == true)
    #expect(tripSegment?.startIndex == 4)
    #expect(tripSegment?.span == 3)
    #expect(tripSegment?.position == .startAndEnd)
    #expect(carryoverStartSegment?.position == .start)
    #expect(carryoverEndSegment?.startIndex == 0)
    #expect(carryoverEndSegment?.span == 1)
    #expect(carryoverEndSegment?.position == .end)
  }

  @Test("makeConfiguration_월바를_숨기면_nil을_반환합니다")
  func makeConfigurationOmitsMonthBarWhenHidden() {
    let configuration = HomeCalendarConfigurationBuilder.makeConfiguration(
      month: Self.month,
      selectedDate: Self.selectedDate,
      eventsByDay: [:],
      calendar: Self.fixedCalendar,
      showsMonthBar: false,
      today: Self.today
    )

    #expect(configuration.monthBar == nil)
    #expect(configuration.weeks.count == 4)
  }
}

private extension DesignSystemTests {
  static var bundledFontNames: [String] {
    guard let fontsRootURL = Bundle.designSystemBundle.resourceURL?
      .appendingPathComponent("Fonts", isDirectory: true)
    else {
      return []
    }

    var fontURLs: [URL] = []
    let enumerator = FileManager.default.enumerator(
      at: fontsRootURL,
      includingPropertiesForKeys: nil,
      options: [.skipsHiddenFiles]
    )

    while let url = enumerator?.nextObject() as? URL {
      guard ["otf", "ttf"].contains(url.pathExtension.lowercased()) else { continue }
      fontURLs.append(url)
    }

    return fontURLs
      .map { $0.deletingPathExtension().lastPathComponent }
      .sorted()
  }

  static var fixedCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    calendar.firstWeekday = 1
    return calendar
  }

  static let month = fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 1)) ?? .now
  static let selectedDate = fixedCalendar.startOfDay(
    for: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 27)) ?? .now
  )
  static let today = fixedCalendar.startOfDay(
    for: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 26)) ?? .now
  )

  static var eventsByDay: [Date: [CalendarEvent]] {
    let trip = CalendarEvent(
      id: "trip",
      title: "경주 여행",
      startDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 26, hour: 9)) ?? month,
      endDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 28, hour: 18)) ?? month,
      isAllDay: true
    )
    let scheduleEvents = [
      CalendarEvent(
        id: "cafe",
        title: "카페",
        startDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 27, hour: 11)) ?? month,
        endDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 27, hour: 12)) ?? month,
        isAllDay: false
      ),
      CalendarEvent(
        id: "meeting",
        title: "회의",
        startDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 27, hour: 13)) ?? month,
        endDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 27, hour: 14)) ?? month,
        isAllDay: false
      ),
      CalendarEvent(
        id: "review",
        title: "리뷰",
        startDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 27, hour: 15)) ?? month,
        endDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 27, hour: 16)) ?? month,
        isAllDay: false
      )
    ]
    let carryoverTrip = CalendarEvent(
      id: "carryover-trip",
      title: "테스트4",
      startDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 13, hour: 9)) ?? month,
      endDate: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 15, hour: 18)) ?? month,
      isAllDay: true
    )

    let nextDay = fixedCalendar.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
    let previousDay = fixedCalendar.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
    let carryoverSecondDay = fixedCalendar.startOfDay(
      for: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 14)) ?? month
    )
    let carryoverThirdDay = fixedCalendar.startOfDay(
      for: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 15)) ?? month
    )

    return [
      fixedCalendar.startOfDay(
        for: fixedCalendar.date(from: DateComponents(year: 2026, month: 2, day: 13)) ?? month
      ): [carryoverTrip],
      carryoverSecondDay: [carryoverTrip],
      carryoverThirdDay: [carryoverTrip],
      previousDay: [trip],
      selectedDate: [trip] + scheduleEvents,
      nextDay: [trip]
    ]
  }
}
