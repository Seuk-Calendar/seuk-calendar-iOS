import Foundation
import SwiftUI
import WidgetKit

struct TodayScheduleWidget: Widget {
  static let kind = "TodayScheduleWidget"

  var body: some WidgetConfiguration {
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
    TodayScheduleEntry(
      date: Date(),
      snapshot: .placeholder
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (TodayScheduleEntry) -> Void) {
    let snapshot = WidgetScheduleSnapshotStore().load() ?? .placeholder
    completion(TodayScheduleEntry(date: Date(), snapshot: snapshot))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<TodayScheduleEntry>) -> Void) {
    let snapshot = WidgetScheduleSnapshotStore().load() ?? .empty
    let entry = TodayScheduleEntry(date: Date(), snapshot: snapshot)
    let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
    completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
  }
}

private struct TodayScheduleEntry: TimelineEntry {
  let date: Date
  let snapshot: WidgetScheduleSnapshot
}

private struct TodayScheduleWidgetEntryView: View {
  @Environment(\.widgetFamily) private var family

  let entry: TodayScheduleEntry

  private let calendar = Calendar.current

  var body: some View {
    switch family {
    case .systemSmall:
      smallView
    case .systemMedium:
      mediumView
    case .systemLarge:
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
}

private extension TodayScheduleWidgetEntryView {
  var todayEvents: [WidgetScheduleSnapshot.Item] {
    entry.snapshot.events(on: entry.date, calendar: calendar)
  }

  var tomorrowEvents: [WidgetScheduleSnapshot.Item] {
    guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: entry.date) else {
      return []
    }

    return entry.snapshot.events(on: tomorrow, calendar: calendar)
  }

  var nextEvent: WidgetScheduleSnapshot.Item? {
    entry.snapshot.nextEvent(after: entry.date)
  }

  var remainingTodayCount: Int {
    entry.snapshot.remainingEventCount(after: entry.date, on: entry.date, calendar: calendar)
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
    VStack(alignment: .leading, spacing: 10) {
      Text("오늘 일정")
        .font(.system(size: 14, weight: .semibold))

      if todayEvents.isEmpty {
        Text("오늘은 예정된 일정이 없습니다")
          .font(.system(size: 13, weight: .regular))
          .foregroundStyle(.secondary)
      } else {
        VStack(alignment: .leading, spacing: 8) {
          ForEach(todayEvents.prefix(3)) { event in
            scheduleRow(event)
          }

          if todayEvents.count > 3 {
            Text("+\(todayEvents.count - 3)개 더")
              .font(.system(size: 12, weight: .medium))
              .foregroundStyle(.secondary)
          }
        }
      }

      Spacer(minLength: 0)
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }

  var largeView: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("오늘 일정")
        .font(.system(size: 16, weight: .bold))

      if todayEvents.isEmpty {
        Text("오늘 일정이 없습니다")
          .font(.system(size: 14, weight: .medium))
          .foregroundStyle(.secondary)
      } else {
        VStack(alignment: .leading, spacing: 8) {
          ForEach(todayEvents.prefix(6)) { event in
            scheduleRow(event)
          }

          if todayEvents.count > 6 {
            Text("+\(todayEvents.count - 6)개 더")
              .font(.system(size: 12, weight: .medium))
              .foregroundStyle(.secondary)
          }
        }
      }

      Divider()

      VStack(alignment: .leading, spacing: 4) {
        Text("내일 미리보기")
          .font(.system(size: 13, weight: .semibold))
          .foregroundStyle(.secondary)

        if let tomorrowNext = tomorrowEvents.first {
          Link(destination: WidgetDeepLinkBuilder.scheduleURL(for: tomorrowNext)) {
            HStack(spacing: 6) {
              Text(timeText(for: tomorrowNext))
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.blue)
              Text(tomorrowNext.title)
                .font(.system(size: 13, weight: .regular))
                .lineLimit(1)
            }
          }
          .buttonStyle(.plain)
        } else {
          Text("내일 일정이 없습니다")
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(.secondary)
        }
      }

      Spacer(minLength: 0)
    }
    .containerBackground(.fill.tertiary, for: .widget)
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
    .widgetLabel {
      Text("남은 일정 \(remainingTodayCount)개")
    }
  }

  var rectangularView: some View {
    VStack(alignment: .leading, spacing: 2) {
      if let nextEvent {
        Text("다음 일정")
          .font(.caption2)
          .foregroundStyle(.secondary)
        Text(nextEvent.title)
          .font(.system(size: 12, weight: .semibold))
          .lineLimit(1)
        Text(timeText(for: nextEvent))
          .font(.system(size: 11, weight: .medium))
          .foregroundStyle(.secondary)
      } else {
        Text("오늘 일정 없음")
          .font(.system(size: 12, weight: .semibold))
        Text("앱에서 일정을 추가해보세요")
          .font(.system(size: 11, weight: .regular))
          .foregroundStyle(.secondary)
      }
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
  }

  func scheduleRow(_ event: WidgetScheduleSnapshot.Item) -> some View {
    Link(destination: WidgetDeepLinkBuilder.scheduleURL(for: event)) {
      HStack(alignment: .center, spacing: 8) {
        Text(timeText(for: event))
          .font(.system(size: 12, weight: .semibold))
          .foregroundStyle(.blue)
          .frame(minWidth: 52, alignment: .leading)

        VStack(alignment: .leading, spacing: 2) {
          Text(event.title)
            .font(.system(size: 12, weight: .medium))
            .lineLimit(1)

          if let location = event.location, !location.isEmpty {
            Text(location)
              .font(.system(size: 11, weight: .regular))
              .foregroundStyle(.secondary)
              .lineLimit(1)
          }
        }

        Spacer(minLength: 0)
      }
    }
    .buttonStyle(.plain)
  }

  func timeText(for event: WidgetScheduleSnapshot.Item) -> String {
    if event.isAllDay {
      return "종일"
    }

    return WidgetFormatters.timeFormatter.string(from: event.startDate)
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

private enum WidgetFormatters {
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
}

private enum WidgetSharedConstants {
  static let appGroupIdentifier = "group.com.youngkyu.SeukCalendar"
  static let snapshotStorageKey = "today_schedule_widget_snapshot_v1"
  static let deepLinkScheme = "seukcalendar"
  static let deepLinkHost = "schedule"
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

private struct WidgetScheduleSnapshot: Codable {
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

  static let placeholder = WidgetScheduleSnapshot(
    generatedAt: Date(),
    items: [
      Item(
        id: "placeholder-1",
        title: "팀 스탠드업",
        startDate: Date(),
        endDate: Date().addingTimeInterval(3600),
        isAllDay: false,
        location: "회의실 A"
      )
    ]
  )

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
