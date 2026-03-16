import DesignSystem
import Foundation
import SwiftUI
import WidgetKit

struct SeukCalendarWidget: SwiftUI.Widget {
  static let kind = "SeukCalendarWidget"

  var body: some SwiftUI.WidgetConfiguration {
    StaticConfiguration(kind: Self.kind, provider: SeukCalendarTimelineProvider()) { entry in
      SeukCalendarWidgetEntryView(entry: entry)
        .widgetURL(WidgetDeepLinkBuilder.dayURL(for: entry.date))
    }
    .configurationDisplayName("오늘 일정")
    .description("홈 화면과 잠금 화면에서 오늘의 일정을 빠르게 확인합니다.")
    .supportedFamilies([
      .systemSmall,
      .systemMedium,
      .systemLarge,
      .accessoryCircular,
      .accessoryRectangular,
      .accessoryInline,
    ])
  }
}

private struct SeukCalendarTimelineProvider: TimelineProvider {
  func placeholder(in context: Context) -> SeukCalendarEntry {
    let placeholderDate = WidgetScheduleSnapshot.placeholderReferenceDate
    return SeukCalendarEntry(
      date: placeholderDate,
      snapshot: .placeholder(for: placeholderDate),
      showsPlaceholderPreview: true
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (SeukCalendarEntry) -> Void) {
    let snapshotStore = WidgetScheduleSnapshotStore()
    let storedSnapshot = snapshotStore.load()
    let placeholderDate = WidgetScheduleSnapshot.placeholderReferenceDate
    let isPlaceholderPreview = context.isPreview && storedSnapshot == nil
    let snapshot = storedSnapshot ?? (isPlaceholderPreview ? .placeholder(for: placeholderDate) : .empty)
    let entryDate = isPlaceholderPreview ? placeholderDate : Date()

    completion(
      SeukCalendarEntry(
        date: entryDate,
        snapshot: snapshot,
        showsPlaceholderPreview: isPlaceholderPreview
      )
    )
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<SeukCalendarEntry>) -> Void) {
    let snapshot = WidgetScheduleSnapshotStore().load() ?? .empty
    let entry = SeukCalendarEntry(
      date: Date(),
      snapshot: snapshot,
      showsPlaceholderPreview: false
    )
    let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
    completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
  }
}

struct SeukCalendarEntry: TimelineEntry {
  let date: Date
  let snapshot: WidgetScheduleSnapshot
  let showsPlaceholderPreview: Bool
}

struct SeukCalendarWidgetEntryView: View {
  @Environment(\.widgetFamily) private var family
  @Environment(\.redactionReasons) private var redactionReasons

  let entry: SeukCalendarEntry

  let calendar = WidgetCalendarFactory.calendar

  var body: some View {
    Group {
      switch family {
      case .systemSmall:
        smallView
      case .systemMedium:
        mediumView
      case .systemLarge:
        largeView
      case .systemExtraLarge:
        largeView
      case .accessoryCircular:
        circularView
      case .accessoryRectangular:
        rectangularView
      case .accessoryInline:
        inlineView
      @unknown default:
        mediumView
      }
    }
    .unredactedIf(showsUnredactedPlaceholder)
  }
}

private extension SeukCalendarWidgetEntryView {
  var showsUnredactedPlaceholder: Bool {
    entry.showsPlaceholderPreview && redactionReasons == .placeholder
  }

  var smallView: some View {
    VStack(alignment: .leading, spacing: Spacing.sp250) {
      VStack(alignment: .leading, spacing: Spacing.sp050) {
        Text("오늘")
          .font(Widget.Large.xLarge)
          .foregroundStyle(Color.semantic.Content.primary)

        Text(smallHeaderDateText)
          .font(Widget.Large.medium)
          .foregroundStyle(Color.primitives.gray500)
      }

      if smallVisibleEvents.isEmpty {
        Text("등록된 일정이 없습니다")
          .font(Widget.Large.medium)
          .foregroundStyle(Color.primitives.gray500)
          .lineLimit(1)
      } else {
        VStack(alignment: .leading, spacing: Spacing.sp250) {
          ForEach(smallVisibleEvents) { event in
            WidgetSmallEvent(
              configuration: smallEventConfiguration(for: event)
            )
          }

          if smallRemainingCount > 0 {
            Text("+\(smallRemainingCount)")
              .font(Widget.Large.medium)
              .foregroundStyle(Color.primitives.gray500)
              .lineLimit(1)
          }
        }
      }

      Spacer(minLength: 0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      Color.semantic.Background.primary
    }
  }

  var mediumView: some View {
    VStack(alignment: .leading, spacing: Spacing.sp050) {
      Text(widgetTitleText)
        .font(Widget.Large.xLarge)
        .foregroundStyle(Color.semantic.Content.primary)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .frame(maxWidth: .infinity, alignment: .leading)

      WidgetCalendarWeekdayHeader(configuration: weekdayHeaderConfiguration)

      HStack(alignment: .top, spacing: 0) {
        ForEach(Array(mediumCalendarWeek.enumerated()), id: \.offset) { _, dayCell in
          WidgetDayCell(configuration: dayCell)
            .frame(maxWidth: .infinity)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Spacer(minLength: 0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      Color.semantic.Background.primary
    }
  }

  var largeView: some View {
    VStack(alignment: .leading, spacing: Spacing.sp050) {
      Text(widgetTitleText)
        .font(Widget.Large.xLarge)
        .foregroundStyle(Color.semantic.Content.primary)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(maxWidth: .infinity, alignment: .leading)

      WidgetCalendarWeekdayHeader(configuration: weekdayHeaderConfiguration)

      WidgetCalendarGrid(
        configuration: .init(weeks: largeCalendarWeeks)
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      Color.semantic.Background.primary
    }
  }

  var circularView: some View {
    ZStack {
      AccessoryWidgetBackground()
      VStack(spacing: 2) {
        Image(systemName: "calendar")
          .font(.system(size: 12, weight: .semibold))
        Text("\(remainingTodayCount)")
          .font(.system(size: 14, weight: .bold))
      }
    }
    .containerBackground(for: .widget) {
      Color.clear
    }
    .widgetLabel {
      Text("남은 일정 \(remainingTodayCount)개")
    }
  }

  var rectangularView: some View {
    VStack(alignment: .leading, spacing: 2) {
      if upcomingTodayEvents.isEmpty {
        Text("- 일정 없음")
          .font(.system(size: 12, weight: .semibold))
          .lineLimit(1)
      } else {
        ForEach(upcomingTodayEvents.prefix(2)) { event in
          Text("- \(event.title) \(timeText(for: event))")
            .font(.system(size: 12, weight: .semibold))
            .lineLimit(1)
            .multilineTextAlignment(.leading)
        }

        if upcomingTodayEvents.count > 2 {
          Text("- ...")
            .font(.system(size: 12, weight: .semibold))
            .lineLimit(1)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      Color.clear
    }
  }

  var inlineView: some View {
    Group {
      if let nextEvent {
        Text("\(timeText(for: nextEvent)) \(nextEvent.title)")
      } else {
        Text("오늘 일정 없음")
      }
    }
    .containerBackground(for: .widget) {
      Color.clear
    }
  }
}

private enum WidgetDeepLinkBuilder {
  static func scheduleURL(for event: WidgetScheduleSnapshot.Item) -> URL {
    url(date: event.startDate, scheduleID: event.id)
  }

  static func dayURL(for date: Date) -> URL {
    url(date: date, scheduleID: nil)
  }

  static func url(date: Date, scheduleID: String?) -> URL {
    var components = URLComponents()
    components.scheme = WidgetSharedConstants.deepLinkScheme
    components.host = WidgetSharedConstants.deepLinkHost

    var queryItems = [
      URLQueryItem(
        name: "date",
        value: WidgetFormatters.queryDateFormatter.string(from: date)
      )
    ]

    if let scheduleID {
      queryItems.append(URLQueryItem(name: "id", value: scheduleID))
    }

    components.queryItems = queryItems
    if let url = components.url {
      return url
    }

    var fallback = URLComponents()
    fallback.scheme = WidgetSharedConstants.deepLinkScheme
    fallback.host = WidgetSharedConstants.deepLinkHost
    return fallback.url ?? URL(fileURLWithPath: "/")
  }
}

enum WidgetFormatters {
  static let queryDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = .current
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    return formatter
  }()

  static let widgetTitleFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = WidgetCalendarFactory.calendar
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = .current
    formatter.dateFormat = "yyyy년 M월 d일 EEEE"
    return formatter
  }()

  static let smallHeaderDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = WidgetCalendarFactory.calendar
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = .current
    formatter.dateFormat = "M월 d일 EEEE"
    return formatter
  }()
}

enum WidgetCalendarFactory {
  static var calendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.timeZone = .current
    calendar.firstWeekday = 1
    return calendar
  }
}

private enum WidgetSharedConstants {
  static let appGroupIdentifier = "group.com.youngkyu.SeukCalendar"
  static let snapshotStorageKey = "today_schedule_widget_snapshot_v1"
  static let deepLinkScheme = "seukcalendar"
  static let deepLinkHost = "schedule"
}

private extension View {
  @ViewBuilder
  func unredactedIf(_ condition: Bool) -> some View {
    if condition {
      unredacted()
    } else {
      self
    }
  }
}

private struct WidgetScheduleSnapshotStore {
  private let userDefaults: UserDefaults?
  private let decoder: JSONDecoder

  init(appGroupIdentifier: String = WidgetSharedConstants.appGroupIdentifier) {
    userDefaults = UserDefaults(suiteName: appGroupIdentifier)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    self.decoder = decoder
  }

  func load() -> WidgetScheduleSnapshot? {
    guard let userDefaults,
          let data = userDefaults.data(forKey: WidgetSharedConstants.snapshotStorageKey)
    else {
      return nil
    }

    return try? decoder.decode(WidgetScheduleSnapshot.self, from: data)
  }
}

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

#if DEBUG
  private enum SeukCalendarWidgetPreviewFactory {
    static var calendar: Calendar {
      var calendar = Calendar(identifier: .gregorian)
      calendar.locale = Locale(identifier: "ko_KR")
      calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
      calendar.firstWeekday = 1
      return calendar
    }

    static var previewDate: Date {
      date(month: 3, day: 15, hour: 9)
    }

    static var mediumPreviewDate: Date {
      date(month: 3, day: 3, hour: 9)
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
          title: "삼일절",
          month: 3,
          day: 1
        ),
        timedItem(
          id: "preview-holiday-2",
          title: "가족 점심",
          month: 3,
          day: 1,
          startHour: 12,
          endHour: 13
        ),
        timedItem(
          id: "preview-holiday-3",
          title: "추가 일정",
          month: 3,
          day: 1,
          startHour: 16,
          endHour: 17
        ),
        allDayItem(
          id: "preview-saturday",
          title: "토요 일정",
          month: 3,
          day: 7
        ),
        spanningItem(
          id: "preview-week-span",
          title: "제주도 여행",
          startMonth: 3,
          startDay: 8,
          endMonth: 3,
          endDay: 11
        ),
        timedItem(
          id: "preview-single-1",
          title: "디자인 리뷰",
          month: 3,
          day: 12,
          startHour: 10,
          endHour: 11
        ),
        timedItem(
          id: "preview-single-2",
          title: "알바",
          month: 3,
          day: 12,
          startHour: 15,
          endHour: 16
        ),
        spanningItem(
          id: "preview-spanning-2",
          title: "테스트4",
          startMonth: 3,
          startDay: 13,
          endMonth: 3,
          endDay: 18
        ),
        spanningItem(
          id: "preview-spanning-3",
          title: "테스트5",
          startMonth: 3,
          startDay: 14,
          endMonth: 3,
          endDay: 16
        ),
        timedItem(
          id: "preview-overflow-today",
          title: "주간 회고",
          month: 3,
          day: 15,
          startHour: 13,
          endHour: 14
        ),
        timedItem(
          id: "preview-single-3",
          title: "저녁 약속",
          month: 3,
          day: 18,
          startHour: 18,
          endHour: 19
        ),
        spanningItem(
          id: "preview-spanning-4",
          title: "테스트6",
          startMonth: 3,
          startDay: 20,
          endMonth: 4,
          endDay: 1
        ),
        timedItem(
          id: "preview-single-4",
          title: "알바 대타",
          month: 3,
          day: 22,
          startHour: 12,
          endHour: 13
        ),
        allDayItem(
          id: "preview-single-5",
          title: "엄마 생일",
          month: 3,
          day: 25
        ),
        allDayItem(
          id: "preview-single-6",
          title: "월말 정리",
          month: 3,
          day: 29
        ),
        timedItem(
          id: "preview-other-month",
          title: "다음 달 준비",
          month: 4,
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
        allDayItem(id: "medium-01-1", title: "하루 일정", month: 3, day: 1),
        allDayItem(id: "medium-01-2", title: "하루 일정", month: 3, day: 1),
        timedItem(id: "medium-01-3", title: "하루 일정", month: 3, day: 1, startHour: 12, endHour: 13),
        timedItem(id: "medium-01-4", title: "하루 일정", month: 3, day: 1, startHour: 15, endHour: 16),

        allDayItem(id: "medium-02-1", title: "하루 일정", month: 3, day: 2),
        allDayItem(id: "medium-02-2", title: "하루 일정", month: 3, day: 2),
        timedItem(id: "medium-02-3", title: "하루 일정", month: 3, day: 2, startHour: 12, endHour: 13),
        timedItem(id: "medium-02-4", title: "하루 일정", month: 3, day: 2, startHour: 15, endHour: 16),

        allDayItem(id: "medium-03-1", title: "하루 일정", month: 3, day: 3),
        allDayItem(id: "medium-03-2", title: "하루 일정", month: 3, day: 3),
        timedItem(id: "medium-03-3", title: "하루 일정", month: 3, day: 3, startHour: 12, endHour: 13),
        timedItem(id: "medium-03-4", title: "하루 일정", month: 3, day: 3, startHour: 15, endHour: 16),

        spanningItem(
          id: "medium-span-1",
          title: "연속 시작",
          startMonth: 3,
          startDay: 4,
          endMonth: 3,
          endDay: 6
        ),
        allDayItem(id: "medium-04-1", title: "하루 일정", month: 3, day: 4),
        timedItem(id: "medium-04-2", title: "하루 일정", month: 3, day: 4, startHour: 12, endHour: 13),
        timedItem(id: "medium-04-3", title: "하루 일정", month: 3, day: 4, startHour: 15, endHour: 16),

        allDayItem(id: "medium-05-1", title: "하루 일정", month: 3, day: 5),
        timedItem(id: "medium-05-2", title: "하루 일정", month: 3, day: 5, startHour: 12, endHour: 13),
        timedItem(id: "medium-05-3", title: "하루 일정", month: 3, day: 5, startHour: 15, endHour: 16),

        allDayItem(id: "medium-06-1", title: "하루 일정", month: 3, day: 6),
        timedItem(id: "medium-06-2", title: "하루 일정", month: 3, day: 6, startHour: 12, endHour: 13),
        timedItem(id: "medium-06-3", title: "하루 일정", month: 3, day: 6, startHour: 15, endHour: 16),

        allDayItem(id: "medium-07-1", title: "하루 일정", month: 3, day: 7),
        allDayItem(id: "medium-07-2", title: "하루 일정", month: 3, day: 7),
        timedItem(id: "medium-07-3", title: "하루 일정", month: 3, day: 7, startHour: 12, endHour: 13),
        timedItem(id: "medium-07-4", title: "하루 일정", month: 3, day: 7, startHour: 15, endHour: 16),
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
          month: 3,
          day: 3,
          startHour: 11,
          endHour: 12
        ),
        timedItem(
          id: "small-02",
          title: "저녁 약속",
          month: 3,
          day: 3,
          startHour: 17,
          endHour: 18
        ),
        allDayItem(
          id: "small-03",
          title: "시작 시간 없는 종일 일정",
          month: 3,
          day: 3
        ),
        allDayItem(
          id: "small-04",
          title: "추가 일정 1",
          month: 3,
          day: 3
        ),
        allDayItem(
          id: "small-05",
          title: "추가 일정 2",
          month: 3,
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

  #Preview("Today Schedule Large", as: .systemLarge) {
    SeukCalendarWidget()
  } timeline: {
    SeukCalendarWidgetPreviewFactory.largePreviewEntry
  }

  #Preview("Today Schedule Medium", as: .systemMedium) {
    SeukCalendarWidget()
  } timeline: {
    SeukCalendarWidgetPreviewFactory.mediumPreviewEntry
  }

  #Preview("Today Schedule Small", as: .systemSmall) {
    SeukCalendarWidget()
  } timeline: {
    SeukCalendarWidgetPreviewFactory.smallPreviewEntry
  }
#endif
