import Foundation

enum WidgetSharedConstants {
  static let appGroupIdentifier = configuredValue(
    forKey: "SCWidgetAppGroupIdentifier",
    fallback: "group.com.youngkyu.SeukCalendar"
  )
  static let snapshotStorageKey = "today_schedule_widget_snapshot_v1"
  static let widgetKind = "SeukCalendarWidget"
  static let deepLinkScheme = configuredValue(
    forKey: "SCWidgetDeepLinkScheme",
    fallback: "seukcalendar"
  )
  static let deepLinkHost = "schedule"

  private static func configuredValue(forKey key: String, fallback: String) -> String {
    guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
          !value.isEmpty
    else {
      return fallback
    }

    return value
  }
}

enum WidgetDateFormatter {
  static let queryDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = .current
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}

struct WidgetScheduleDeepLink {
  let scheduleID: String?
  let date: Date

  init?(url: URL) {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          components.scheme?.lowercased() == WidgetSharedConstants.deepLinkScheme,
          components.host?.lowercased() == WidgetSharedConstants.deepLinkHost
    else {
      return nil
    }

    var queryItems: [String: String] = [:]
    for item in components.queryItems ?? [] {
      guard let value = item.value else {
        continue
      }

      queryItems[item.name] = value
    }

    if let dateString = queryItems["date"],
       let parsedDate = WidgetDateFormatter.queryDateFormatter.date(from: dateString) {
      date = parsedDate
    } else {
      date = Date()
    }

    scheduleID = queryItems["id"]
  }

  func selectedDate(using calendar: Calendar = .current) -> Date {
    calendar.startOfDay(for: date)
  }
}
