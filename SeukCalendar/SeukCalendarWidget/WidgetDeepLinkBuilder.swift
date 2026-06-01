import SwiftUI
import WidgetKit

enum WidgetDeepLinkBuilder {
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
