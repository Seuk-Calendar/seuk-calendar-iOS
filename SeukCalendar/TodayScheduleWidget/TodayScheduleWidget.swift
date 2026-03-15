import DesignSystem
import Foundation
import SwiftUI
import WidgetKit

struct TodayScheduleCalendarWidget: SwiftUI.Widget {
  static let kind = "TodayScheduleWidget"

  var body: some SwiftUI.WidgetConfiguration {
    StaticConfiguration(kind: Self.kind, provider: TodayScheduleTimelineProvider()) { entry in
      TodayScheduleWidgetEntryView(entry: entry)
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

private struct TodayScheduleTimelineProvider: TimelineProvider {
  func placeholder(in context: Context) -> TodayScheduleEntry {
    let placeholderDate = WidgetScheduleSnapshot.placeholderReferenceDate
    return TodayScheduleEntry(
      date: placeholderDate,
      snapshot: .placeholder(for: placeholderDate),
      showsPlaceholderPreview: true
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (TodayScheduleEntry) -> Void) {
    let snapshotStore = WidgetScheduleSnapshotStore()
    let storedSnapshot = snapshotStore.load()
    let placeholderDate = WidgetScheduleSnapshot.placeholderReferenceDate
    let isPlaceholderPreview = context.isPreview && storedSnapshot == nil
    let snapshot = storedSnapshot ?? (isPlaceholderPreview ? .placeholder(for: placeholderDate) : .empty)
    let entryDate = isPlaceholderPreview ? placeholderDate : Date()

    completion(
      TodayScheduleEntry(
        date: entryDate,
        snapshot: snapshot,
        showsPlaceholderPreview: isPlaceholderPreview
      )
    )
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<TodayScheduleEntry>) -> Void) {
    let snapshot = WidgetScheduleSnapshotStore().load() ?? .empty
    let entry = TodayScheduleEntry(
      date: Date(),
      snapshot: snapshot,
      showsPlaceholderPreview: false
    )
    let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
    completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
  }
}

struct TodayScheduleEntry: TimelineEntry {
  let date: Date
  let snapshot: WidgetScheduleSnapshot
  let showsPlaceholderPreview: Bool
}

struct TodayScheduleWidgetEntryView: View {
  private enum Metrics {
    static let largeContentSpacing = Spacing.sp050
  }

  @Environment(\.widgetFamily) private var family
  @Environment(\.redactionReasons) private var redactionReasons

  let entry: TodayScheduleEntry

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

private extension TodayScheduleWidgetEntryView {
  var showsUnredactedPlaceholder: Bool {
    entry.showsPlaceholderPreview && redactionReasons == .placeholder
  }

  var smallView: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("오늘 일정")
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(.secondary)

      if let nextEvent {
        Text(timeText(for: nextEvent))
          .font(.system(size: 14, weight: .bold))
          .foregroundStyle(.blue)
        Text(nextEvent.title)
          .font(.system(size: 13, weight: .medium))
          .lineLimit(3)
      } else {
        Spacer(minLength: 0)
        Text("등록된 일정이 없습니다")
          .font(.system(size: 13, weight: .medium))
          .foregroundStyle(.secondary)
          .lineLimit(2)
      }

      Spacer(minLength: 0)
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }

  var mediumView: some View {
    WidgetMediumComponent(configuration: mediumComponentConfiguration)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .containerBackground(for: .widget) {
        Color.semantic.Background.backgroundPrimary
      }
  }

  var largeView: some View {
    VStack(alignment: .leading, spacing: Metrics.largeContentSpacing) {
      Text(widgetTitleText)
        .font(Widget.Large.xLarge)
        .foregroundStyle(Color.semantic.Content.contentPrimary)
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
      Color.semantic.Background.backgroundPrimary
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
  private enum TodayScheduleWidgetPreviewFactory {
    static var calendar: Calendar {
      var calendar = Calendar(identifier: .gregorian)
      calendar.locale = Locale(identifier: "ko_KR")
      calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
      calendar.firstWeekday = 1
      return calendar
    }

    static var previewDate: Date {
      date(month: 3, day: 12, hour: 9)
    }

    static var largePreviewEntry: TodayScheduleEntry {
      TodayScheduleEntry(
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

    static var previewItems: [WidgetScheduleSnapshot.Item] {
      let baseItems = gridDates.flatMap(makeBaseDayEvents(on:))
      let mixedItems = [
        spanningItem(
          id: "preview-spanning-1",
          title: "연속 일정",
          startMonth: 3,
          startDay: 3,
          endMonth: 3,
          endDay: 5
        ),
        spanningItem(
          id: "preview-spanning-2",
          title: "출장 일정",
          startMonth: 3,
          startDay: 11,
          endMonth: 3,
          endDay: 13
        ),
        spanningItem(
          id: "preview-spanning-3",
          title: "월말 연속 일정",
          startMonth: 3,
          startDay: 30,
          endMonth: 4,
          endDay: 2
        ),
      ]

      return (baseItems + mixedItems).sorted { lhs, rhs in
        if lhs.startDate == rhs.startDate {
          return lhs.title < rhs.title
        }
        return lhs.startDate < rhs.startDate
      }
    }

    static var gridDates: [Date] {
      let monthStart = calendar.dateInterval(of: .month, for: previewDate)?.start ?? previewDate
      let gridStart = calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart

      return (0 ..< 35).compactMap { dayOffset in
        calendar.date(byAdding: .day, value: dayOffset, to: gridStart)
      }
    }

    static func makeBaseDayEvents(on targetDate: Date) -> [WidgetScheduleSnapshot.Item] {
      let day = calendar.component(.day, from: targetDate)
      let month = calendar.component(.month, from: targetDate)
      let dateKey = "\(month)-\(day)"

      return [
        WidgetScheduleSnapshot.Item(
          id: "preview-all-day-\(dateKey)",
          title: "하루 일정",
          startDate: allDayStart(on: targetDate),
          endDate: allDayEnd(on: targetDate),
          isAllDay: true,
          location: nil
        ),
        WidgetScheduleSnapshot.Item(
          id: "preview-single-1-\(dateKey)",
          title: "하루 일정",
          startDate: date(month: month, day: day, hour: 10),
          endDate: date(month: month, day: day, hour: 11),
          isAllDay: false,
          location: nil
        ),
        WidgetScheduleSnapshot.Item(
          id: "preview-overflow-1-\(dateKey)",
          title: "추가 일정",
          startDate: date(month: month, day: day, hour: 13),
          endDate: date(month: month, day: day, hour: 14),
          isAllDay: false,
          location: nil
        ),
        WidgetScheduleSnapshot.Item(
          id: "preview-overflow-2-\(dateKey)",
          title: "추가 일정",
          startDate: date(month: month, day: day, hour: 15),
          endDate: date(month: month, day: day, hour: 16),
          isAllDay: false,
          location: nil
        ),
      ]
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
    TodayScheduleCalendarWidget()
  } timeline: {
    TodayScheduleWidgetPreviewFactory.largePreviewEntry
  }
#endif
