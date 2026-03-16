import DesignSystem
import SwiftUI
import WidgetKit

extension WidgetSmallEvent {
  struct Configuration: Hashable {
    let title: String
    let timeText: String?
    let dotColor: Color

    init(
      title: String,
      timeText: String? = nil,
      dotColor: Color = .semanticExtensions.Content.contentWarning
    ) {
      self.title = title
      self.timeText = timeText
      self.dotColor = dotColor
    }
  }
}

extension WidgetSmallEvent.Configuration {
  func resolvedDotColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.9)
    }

    return dotColor
  }

  func resolvedTitleColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.96)
    }

    return .semantic.Content.primary
  }

  func resolvedTimeColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.52)
    }

    return .primitives.gray500
  }
}

extension WidgetSmallEvent.Configuration {
  var trimmedTitle: String {
    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedTitle.isEmpty ? title : trimmedTitle
  }

  var trimmedTimeText: String? {
    guard let timeText else {
      return nil
    }

    let trimmedTimeText = timeText.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedTimeText.isEmpty ? nil : trimmedTimeText
  }
}
