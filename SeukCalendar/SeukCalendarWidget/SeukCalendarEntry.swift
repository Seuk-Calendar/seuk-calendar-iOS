import WidgetKit
import SwiftUI

struct SeukCalendarEntry: TimelineEntry {
  let date: Date
  let snapshot: WidgetScheduleSnapshot
  let showsPlaceholderPreview: Bool
}
