import DesignSystem
import EventKit
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
    .supportedFamilies(supportedFamilies)
  }
}

private extension SeukCalendarWidget {
  var supportedFamilies: [WidgetFamily] {
    #if os(macOS)
      return [
        .systemSmall,
        .systemMedium,
        .systemLarge,
      ]
    #else
      return [
        .systemSmall,
        .systemMedium,
        .systemLarge,
        .accessoryCircular,
        .accessoryRectangular,
        .accessoryInline,
      ]
    #endif
  }
}

#if DEBUG
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
