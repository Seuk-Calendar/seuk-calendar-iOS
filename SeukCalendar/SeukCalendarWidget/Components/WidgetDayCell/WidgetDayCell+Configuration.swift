import DesignSystem
import SwiftUI
import WidgetKit

extension WidgetDayCell {
  struct Configuration: Hashable {
    static let maxVisibleBadgeSlotCount = 2

    enum State: Hashable {
      case `default`
      case saturday
      case holiday
      case otherMonth
    }

    let dayNumber: String
    let state: State
    let isToday: Bool
    let badgeSlots: [WidgetBadge.Configuration?]
    let moreCount: Int

    init(
      dayNumber: String,
      state: State,
      isToday: Bool = false,
      badgeSlots: [WidgetBadge.Configuration?] = [],
      moreCount: Int = 0
    ) {
      self.dayNumber = dayNumber
      self.state = state
      self.isToday = isToday
      self.badgeSlots = badgeSlots
      self.moreCount = moreCount
    }
  }
}

extension WidgetDayCell.Configuration {
  func resolvedDayNumberColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return state == .otherMonth ? Color.white.opacity(0.52) : Color.white.opacity(0.98)
    }

    switch state {
    case .default:
      return .semantic.Content.primary
    case .saturday:
      return .primitives.blue600
    case .holiday:
      return .primitives.red600
    case .otherMonth:
      return .primitives.gray300
    }
  }

  func resolvedMoreNumberColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.52)
    }

    return .primitives.gray500
  }

  func resolvedBackgroundColor(for widgetRenderingMode: WidgetRenderingMode) -> Color? {
    guard isToday else {
      return nil
    }

    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.16)
    }

    return .primitives.gray50
  }
}

extension WidgetDayCell.Configuration {
  var resolvedBadgeSlots: [WidgetBadge.Configuration?] {
    let normalizedSlots = Array(badgeSlots.prefix(Self.maxVisibleBadgeSlotCount))
    let missingSlotCount = max(0, Self.maxVisibleBadgeSlotCount - normalizedSlots.count)

    return normalizedSlots + Array(repeating: nil, count: missingSlotCount)
  }

  var resolvedMoreCount: Int {
    max(moreCount, 0)
  }

  var moreNumberText: String? {
    guard resolvedMoreCount > 0 else {
      return nil
    }

    return "+\(resolvedMoreCount)"
  }
}
