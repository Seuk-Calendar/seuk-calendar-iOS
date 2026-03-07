import Foundation
import SwiftUI

public extension WidgetDayCellComponent {
  struct Configuration: Hashable, Sendable {
    public let date: Date
    public let isToday: Bool
    public let dayTextColor: Color
    public let segments: [BadgeSegmentComponent.Configuration]
    public let overflowCount: Int

    public init(
      date: Date,
      isToday: Bool,
      dayTextColor: Color,
      segments: [BadgeSegmentComponent.Configuration] = [],
      overflowCount: Int = 0
    ) {
      self.date = date
      self.isToday = isToday
      self.dayTextColor = dayTextColor
      self.segments = segments
      self.overflowCount = overflowCount
    }
  }
}

extension WidgetDayCellComponent.Configuration {
  static let maxVisibleSegments = 2

  var dayText: String {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = .autoupdatingCurrent
    calendar.timeZone = .autoupdatingCurrent
    return String(calendar.component(.day, from: date))
  }

  var visibleSegments: [BadgeSegmentComponent.Configuration] {
    Array(segments.prefix(Self.maxVisibleSegments))
  }

  var resolvedOverflowCount: Int {
    max(overflowCount, 0) + max(segments.count - visibleSegments.count, 0)
  }

  var hasSchedules: Bool {
    !segments.isEmpty || overflowCount > 0
  }
}
