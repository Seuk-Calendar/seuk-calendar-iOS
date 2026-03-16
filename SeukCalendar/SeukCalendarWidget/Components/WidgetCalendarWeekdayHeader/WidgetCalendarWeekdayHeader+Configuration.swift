import DesignSystem
import Foundation
import SwiftUI
import WidgetKit

extension WidgetCalendarWeekdayHeader {
  struct Configuration: Hashable {
    let locale: Locale

    init(locale: Locale = Locale(identifier: "ko_KR")) {
      self.locale = locale
    }
  }
}

extension WidgetCalendarWeekdayHeader.Configuration {
  func resolvedForegroundColor(
    for role: WeekdayItem.Role,
    widgetRenderingMode: WidgetRenderingMode
  ) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.78)
    }

    switch role {
    case .sunday:
      return .semanticExtensions.Content.contentNegative
    case .weekday:
      return .semantic.Content.secondary
    case .saturday:
      return .semanticExtensions.Content.contentAccent
    }
  }

  func resolvedDividerColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.22)
    }

    return .semantic.Background.secondary
  }
}

extension WidgetCalendarWeekdayHeader.Configuration {
  struct WeekdayItem: Hashable {
    enum Role: Hashable {
      case sunday
      case weekday
      case saturday
    }

    let title: String
    let role: Role
  }

  var weekdayItems: [WeekdayItem] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = locale
    calendar.firstWeekday = 1

    return calendar.shortStandaloneWeekdaySymbols.enumerated().map { index, title in
      let role: WeekdayItem.Role
      switch index {
      case 0:
        role = .sunday
      case 6:
        role = .saturday
      default:
        role = .weekday
      }

      return WeekdayItem(title: title, role: role)
    }
  }
}
