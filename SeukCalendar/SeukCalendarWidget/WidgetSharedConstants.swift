import SwiftUI

enum WidgetSharedConstants {
static let appGroupIdentifier = configuredValue(
  forKey: "SCWidgetAppGroupIdentifier",
  fallback: "group.com.youngkyu.SeukCalendar"
)
static let snapshotStorageKey = "today_schedule_widget_snapshot_v1"
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
