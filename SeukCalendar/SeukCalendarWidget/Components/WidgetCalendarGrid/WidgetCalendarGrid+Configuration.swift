import DesignSystem
import SwiftUI
import WidgetKit

extension WidgetCalendarGrid {
  struct Configuration: Hashable {
    let weeks: [[WidgetDayCell.Configuration]]

    init(weeks: [[WidgetDayCell.Configuration]]) {
      self.weeks = weeks
    }
  }
}

extension WidgetCalendarGrid.Configuration {
  func resolvedDividerColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.22)
    }

    return .semantic.Background.secondary
  }
}
