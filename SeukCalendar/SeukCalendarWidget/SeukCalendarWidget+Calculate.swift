import DesignSystem
import Foundation
import SwiftUI

extension SeukCalendarWidgetEntryView {
  /// 현재 기준일에 표시할 오늘 일정 목록을 반환한다.
  var todayEvents: [WidgetScheduleSnapshot.Item] {
    entry.snapshot.events(on: entry.date, calendar: calendar)
  }

  /// 현재 시점 이후에 시작하는 가장 가까운 일정을 반환한다.
  var nextEvent: WidgetScheduleSnapshot.Item? {
    entry.snapshot.nextEvent(after: entry.date)
  }

  /// 오늘 일정 중 아직 끝나지 않은 일정만 반환한다.
  var upcomingTodayEvents: [WidgetScheduleSnapshot.Item] {
    todayEvents.filter { $0.endDate > entry.date }
  }

  /// 오늘 일정 중 추가로 숨겨진 일정 수를 계산한다.
  var remainingTodayCount: Int {
    entry.snapshot.remainingEventCount(after: entry.date, on: entry.date, calendar: calendar)
  }

  /// 위젯 상단 제목에 사용하는 날짜 문자열을 반환한다.
  var widgetTitleText: String {
    WidgetFormatters.widgetTitleFormatter.string(from: entry.date)
  }

  /// small 위젯 날짜 헤더에 사용하는 날짜 문자열을 반환한다.
  var smallHeaderDateText: String {
    WidgetFormatters.smallHeaderDateFormatter.string(from: entry.date)
  }

  /// small 위젯에서 노출 순서에 맞게 정렬된 오늘 일정을 반환한다.
  var smallDisplayEvents: [WidgetScheduleSnapshot.Item] {
    todayEvents.sorted(by: compareSmallDisplayEvents)
  }

  /// small 위젯에 직접 노출할 최대 3개의 일정 목록을 반환한다.
  var smallVisibleEvents: [WidgetScheduleSnapshot.Item] {
    Array(smallDisplayEvents.prefix(3))
  }

  /// small 위젯에서 +N으로 접어둘 남은 일정 수를 반환한다.
  var smallRemainingCount: Int {
    max(smallDisplayEvents.count - smallVisibleEvents.count, 0)
  }

  /// medium 위젯에 필요한 주간 셀 구성을 생성한다.
  var mediumComponentConfiguration: WidgetMediumComponent.Configuration {
    WidgetMediumComponent.Configuration(
      title: widgetTitleText,
      dayCells: weekDates.map(makeDayCellConfiguration(for:))
    )
  }

  /// medium 위젯에 표시할 현재 주 셀 구성을 생성한다.
  var mediumCalendarWeek: [WidgetDayCell.Configuration] {
    makeWidgetDayCellConfigurations(for: weekDates)
  }

  /// Large 위젯은 날짜별 독립 정렬이 아니라, 주 단위 lane을 먼저 고정한 뒤 셀로 분배해야
  /// 연속 일정이 같은 행을 유지하고 하루 일정보다 우선 배치된다.
  var largeCalendarWeeks: [[WidgetDayCell.Configuration]] {
    monthWeeks.map(makeWidgetDayCellConfigurations(for:))
  }

  /// locale에 맞는 요일 헤더 구성을 반환한다.
  var weekdayHeaderConfiguration: WidgetCalendarWeekdayHeader.Configuration {
    WidgetCalendarWeekdayHeader.Configuration(
      locale: calendar.locale ?? Locale(identifier: "ko_KR")
    )
  }

  /// 현재 날짜가 포함된 주의 7일을 순서대로 반환한다.
  var weekDates: [Date] {
    let reference = calendar.dateInterval(of: .weekOfYear, for: entry.date)?.start ?? calendar
      .startOfDay(for: entry.date)
    return (0 ..< 7).compactMap { offset in
      calendar.date(byAdding: .day, value: offset, to: reference)
    }
  }

  /// large 위젯에 표시할 5주 x 7일 월간 그리드 날짜 배열을 생성한다.
  var monthWeeks: [[Date]] {
    let monthStart = calendar.dateInterval(of: .month, for: entry.date)?.start ?? calendar.startOfDay(for: entry.date)
    let gridStart = calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart

    return (0 ..< 5).map { weekOffset in
      (0 ..< 7).compactMap { dayOffset in
        calendar.date(byAdding: .day, value: (weekOffset * 7) + dayOffset, to: gridStart)
      }
    }
  }

  /// medium 위젯 날짜 셀에 필요한 표시 정보를 생성한다.
  func makeDayCellConfiguration(for date: Date) -> WidgetDayCellComponent.Configuration {
    WidgetDayCellComponent.Configuration(
      date: date,
      isToday: calendar.isDate(date, inSameDayAs: entry.date),
      dayTextColor: dayTextColor(for: date),
      segments: badgeSegmentConfigurations(for: date)
    )
  }

  /// medium 위젯 날짜 텍스트 색상을 계산한다.
  func dayTextColor(for date: Date) -> Color {
    if calendar.isDate(date, inSameDayAs: entry.date) {
      return .semantic.Content.primary
    }

    switch calendar.component(.weekday, from: date) {
    case 1:
      return .semanticExtensions.Content.contentNegative
    case 7:
      return .semanticExtensions.Content.contentAccent
    default:
      return .semantic.Content.secondary
    }
  }

  /// medium 위젯에서 날짜별 일정 segment 구성을 생성한다.
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

  /// medium 위젯에서 하루 기준 일정 segment 형태를 계산한다.
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

  /// medium 위젯 segment variant에 맞는 전경색과 배경색을 반환한다.
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

  /// small 및 accessory 위젯에서 사용할 시간 문자열을 반환한다.
  func timeText(for event: WidgetScheduleSnapshot.Item) -> String {
    if event.isAllDay {
      return "종일"
    }

    return WidgetFormatters.timeFormatter.string(from: event.startDate)
  }

  /// small 위젯용 이벤트 row 구성을 생성한다.
  func smallEventConfiguration(
    for event: WidgetScheduleSnapshot.Item
  ) -> WidgetSmallEvent.Configuration {
    WidgetSmallEvent.Configuration(
      title: event.title,
      timeText: smallEventTimeText(for: event)
    )
  }

  /// small 위젯에서 trailing time label에 표시할 시간 문자열을 반환한다.
  func smallEventTimeText(for event: WidgetScheduleSnapshot.Item) -> String? {
    guard !event.isAllDay,
          calendar.isDate(event.startDate, inSameDayAs: entry.date)
    else {
      return nil
    }

    return WidgetFormatters.timeFormatter.string(from: event.startDate)
  }

  /// small 위젯 이벤트 정렬 우선순위를 비교한다.
  func compareSmallDisplayEvents(
    lhs: WidgetScheduleSnapshot.Item,
    rhs: WidgetScheduleSnapshot.Item
  ) -> Bool {
    let lhsHasDisplayTime = smallEventTimeText(for: lhs) != nil
    let rhsHasDisplayTime = smallEventTimeText(for: rhs) != nil

    // 시작 시간이 보이는 일정이 상단에 오도록 먼저 정렬해,
    // small 위젯에서 timed event가 all-day/연속 일정보다 먼저 노출되게 한다.
    if lhsHasDisplayTime != rhsHasDisplayTime {
      return lhsHasDisplayTime && !rhsHasDisplayTime
    }

    if lhsHasDisplayTime, rhsHasDisplayTime, lhs.startDate != rhs.startDate {
      return lhs.startDate < rhs.startDate
    }

    if lhs.isAllDay != rhs.isAllDay {
      return !lhs.isAllDay && rhs.isAllDay
    }

    if lhs.endDate != rhs.endDate {
      return lhs.endDate < rhs.endDate
    }

    if lhs.title != rhs.title {
      return lhs.title < rhs.title
    }

    return lhs.id < rhs.id
  }

  /// 주 단위 lane 배치 결과를 반영해 large 위젯 하루 셀 구성을 생성한다.
  func makeWidgetDayCellConfigurations(for week: [Date]) -> [WidgetDayCell.Configuration] {
    let weekBadgeLayout = widgetBadgeLayout(for: week)

    return week.enumerated().map { index, date in
      WidgetDayCell.Configuration(
        dayNumber: String(calendar.component(.day, from: date)),
        state: widgetDayCellState(for: date),
        isToday: calendar.isDate(date, inSameDayAs: entry.date),
        badgeSlots: weekBadgeLayout.badgeSlots[index],
        moreCount: weekBadgeLayout.moreCounts[index]
      )
    }
  }

  /// large 위젯 날짜 셀의 시각 상태를 계산한다.
  func widgetDayCellState(for date: Date) -> WidgetDayCell.Configuration.State {
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

  /// 주간 셀 전체를 기준으로 연속 일정 lane과 more count를 계산한다.
  fileprivate func widgetBadgeLayout(for week: [Date]) -> WeekBadgeLayout {
    guard let firstDate = week.first,
          let lastDate = week.last
    else {
      return WeekBadgeLayout.empty(dayCount: week.count)
    }

    let weekStart = calendar.startOfDay(for: firstDate)
    let weekEnd = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: lastDate)) ?? lastDate
    let segments = weekBadgeSegments(
      for: week,
      weekStart: weekStart,
      weekEnd: weekEnd
    )
    var laneRanges: [[ClosedRange<Int>]] = []
    var laneByEventID: [String: Int] = [:]

    // 주 안에서 먼저 lane을 배정해 두면, 각 날짜 셀은 같은 이벤트를 같은 세로 위치에 유지할 수 있다.
    for segment in segments {
      let assignedLane = firstAvailableLane(
        for: segment.dayRange,
        laneRanges: laneRanges
      )

      laneByEventID[segment.event.id] = assignedLane

      if laneRanges.indices.contains(assignedLane) {
        laneRanges[assignedLane].append(segment.dayRange)
      } else {
        laneRanges.append([segment.dayRange])
      }
    }

    var badgeSlots = Array(
      repeating: Array(
        repeating: WidgetBadge.Configuration?.none,
        count: WidgetDayCell.Configuration.maxVisibleBadgeSlotCount
      ),
      count: week.count
    )
    var moreCounts = Array(repeating: 0, count: week.count)

    // lane이 가시 슬롯(2개)을 넘는 일정만 moreCount로 밀어내고,
    // 보이는 lane은 비어 있는 날에도 slot을 유지해 줄이 섞이지 않게 한다.
    for segment in segments {
      guard let lane = laneByEventID[segment.event.id] else {
        continue
      }

      for dayIndex in segment.dayRange {
        let badgeConfiguration = widgetBadgeConfiguration(
          for: segment.event,
          on: week[dayIndex]
        )

        if lane < WidgetDayCell.Configuration.maxVisibleBadgeSlotCount {
          // 날짜별로 compactMap 하지 않고 slot 위치를 그대로 유지해야
          // 다음 날에도 같은 연속 일정이 같은 세로 줄에 남는다.
          badgeSlots[dayIndex][lane] = badgeConfiguration
        } else {
          // 가시 슬롯을 넘어간 일정은 해당 날짜에서만 moreCount에 누적한다.
          moreCounts[dayIndex] += 1
        }
      }
    }

    return WeekBadgeLayout(
      badgeSlots: badgeSlots,
      moreCounts: moreCounts
    )
  }

  /// 현재 주와 실제로 겹치는 일정만 잘라서 주간 segment 목록으로 변환한다.
  fileprivate func weekBadgeSegments(
    for week: [Date],
    weekStart: Date,
    weekEnd: Date
  ) -> [WeekBadgeSegment] {
    entry.snapshot.items
      .compactMap { event in
        guard event.startDate < weekEnd, event.endDate > weekStart else {
          return nil
        }

        // 주 경계에서 잘린 구간만 비교해야, 다음 주로 넘어간 연속 일정도
        // 해당 주의 첫 셀에서 다시 시작 구간처럼 렌더링할 수 있다.
        let clippedStart = max(event.startDate, weekStart)
        let clippedEnd = min(event.endDate, weekEnd)
        let startIndex = dayIndex(for: clippedStart, relativeTo: weekStart)
        let endIndex = dayIndex(for: clippedEnd.addingTimeInterval(-1), relativeTo: weekStart)

        guard week.indices.contains(startIndex),
              week.indices.contains(endIndex),
              startIndex <= endIndex
        else {
          return nil
        }

        return WeekBadgeSegment(
          event: event,
          dayRange: startIndex ... endIndex,
          isContinuous: isContinuousEvent(event)
        )
      }
      .sorted(by: compareWeekBadgeSegments)
  }

  /// 겹치지 않는 첫 번째 lane 인덱스를 반환한다.
  func firstAvailableLane(
    for dayRange: ClosedRange<Int>,
    laneRanges: [[ClosedRange<Int>]]
  ) -> Int {
    for (laneIndex, ranges) in laneRanges.enumerated() {
      let overlapsExistingRange = ranges.contains { existingRange in
        rangesOverlap(existingRange, dayRange)
      }

      if !overlapsExistingRange {
        return laneIndex
      }
    }

    return laneRanges.count
  }

  /// 주간 segment를 안정적으로 배치하기 위한 정렬 우선순위를 정의한다.
  fileprivate func compareWeekBadgeSegments(
    lhs: WeekBadgeSegment,
    rhs: WeekBadgeSegment
  ) -> Bool {
    // 연속 일정을 먼저 배치해 상단 lane을 선점하게 하고,
    // 그 다음 시작일과 span 길이로 정렬해 주 단위 배치가 안정적으로 유지되게 한다.
    if lhs.isContinuous != rhs.isContinuous {
      return lhs.isContinuous && !rhs.isContinuous
    }

    if lhs.dayRange.lowerBound != rhs.dayRange.lowerBound {
      return lhs.dayRange.lowerBound < rhs.dayRange.lowerBound
    }

    if lhs.event.startDate != rhs.event.startDate {
      return lhs.event.startDate < rhs.event.startDate
    }

    let lhsSpanLength = lhs.dayRange.upperBound - lhs.dayRange.lowerBound
    let rhsSpanLength = rhs.dayRange.upperBound - rhs.dayRange.lowerBound
    if lhsSpanLength != rhsSpanLength {
      return lhsSpanLength > rhsSpanLength
    }

    if lhs.event.endDate != rhs.event.endDate {
      return lhs.event.endDate > rhs.event.endDate
    }

    if lhs.event.title != rhs.event.title {
      return lhs.event.title < rhs.event.title
    }

    return lhs.event.id < rhs.event.id
  }

  /// large 위젯 날짜 셀에서 사용할 badge 구성을 생성한다.
  func widgetBadgeConfiguration(
    for event: WidgetScheduleSnapshot.Item,
    on date: Date
  ) -> WidgetBadge.Configuration {
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

  /// large 위젯 badge의 날짜별 segment 상태를 계산한다.
  func widgetBadgeState(
    for event: WidgetScheduleSnapshot.Item,
    on date: Date
  ) -> WidgetBadge.Configuration.State {
    let dayStart = calendar.startOfDay(for: date)
    let nextDayStart = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart

    let continuesFromPreviousDay = event.startDate < dayStart
    let continuesIntoNextDay = event.endDate > nextDayStart

    // large 위젯은 단일 일정을 allDay badge 형태로 보여주고,
    // 다일 일정만 start/middle/end segment로 나눠 렌더링한다.
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

  /// 주의 첫 날에서 이어지는 연속 일정 제목을 다시 보여줘야 하는지 판단한다.
  func isWeekSegmentStart(
    for event: WidgetScheduleSnapshot.Item,
    on date: Date
  ) -> Bool {
    let dayStart = calendar.startOfDay(for: date)
    let weekStart = calendar.dateInterval(of: .weekOfYear, for: dayStart)?.start ?? dayStart

    // 실제 일정 시작일은 이전 주여도, 현재 셀이 주의 첫 날이면 제목과 leading strip을 다시 보여준다.
    return calendar.isDate(dayStart, inSameDayAs: weekStart) && event.startDate < dayStart
  }

  /// 주 시작일 기준으로 특정 날짜가 몇 번째 칸인지 계산한다.
  func dayIndex(
    for date: Date,
    relativeTo weekStart: Date
  ) -> Int {
    calendar.dateComponents(
      [.day],
      from: calendar.startOfDay(for: weekStart),
      to: calendar.startOfDay(for: date)
    ).day ?? 0
  }

  /// 일정이 하루를 넘겨 이어지는 연속 일정인지 판단한다.
  func isContinuousEvent(_ event: WidgetScheduleSnapshot.Item) -> Bool {
    let startDay = calendar.startOfDay(for: event.startDate)
    let endDay = calendar.startOfDay(for: event.endDate.addingTimeInterval(-1))
    return startDay < endDay
  }

  /// 두 날짜 범위가 같은 lane에서 충돌하는지 확인한다.
  func rangesOverlap(
    _ lhs: ClosedRange<Int>,
    _ rhs: ClosedRange<Int>
  ) -> Bool {
    lhs.overlaps(rhs)
  }

  /// badge 상태와 주간 경계 조건에 따라 제목 노출 여부를 결정한다.
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

private extension SeukCalendarWidgetEntryView {
  /// 주간 lane 배치에 사용하는 이벤트 단위 segment 정보다.
  struct WeekBadgeSegment {
    let event: WidgetScheduleSnapshot.Item
    let dayRange: ClosedRange<Int>
    let isContinuous: Bool
  }

  /// 주간 셀 렌더링에 필요한 badge slot과 more count 결과다.
  struct WeekBadgeLayout {
    let badgeSlots: [[WidgetBadge.Configuration?]]
    let moreCounts: [Int]

    /// 표시할 일정이 없을 때 사용할 빈 주간 레이아웃을 생성한다.
    static func empty(dayCount: Int) -> Self {
      Self(
        badgeSlots: Array(
          repeating: Array(
            repeating: WidgetBadge.Configuration?.none,
            count: WidgetDayCell.Configuration.maxVisibleBadgeSlotCount
          ),
          count: dayCount
        ),
        moreCounts: Array(repeating: 0, count: dayCount)
      )
    }
  }
}

private extension BadgeSegmentComponent.Configuration.Variant {
  /// variant가 제목과 leading strip을 함께 보여주는 형태인지 반환한다.
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
