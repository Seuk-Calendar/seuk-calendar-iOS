import DesignSystem
import SwiftUI
import WidgetKit

extension WidgetBadge {
  struct Configuration: Hashable {
    enum State: Hashable {
      case allDay
      case start
      case middle
      case end
    }

    let state: State
    let title: String?
    let indicatorColor: Color
    let textColor: Color
    let backgroundColor: Color
    let showsLeadingMetadata: Bool

    init(
      state: State,
      title: String? = nil,
      indicatorColor: Color = .semanticExtensions.Content.contentWarning,
      textColor: Color = .semantic.Content.primary,
      backgroundColor: Color = .semanticExtensions.Background.backgroundLightWarning,
      showsLeadingMetadata: Bool = false
    ) {
      self.state = state
      self.title = title
      self.indicatorColor = indicatorColor
      self.textColor = textColor
      self.backgroundColor = backgroundColor
      self.showsLeadingMetadata = showsLeadingMetadata
    }
  }
}

extension WidgetBadge.Configuration {
  func resolvedIndicatorColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.9)
    }

    return indicatorColor
  }

  func resolvedTextColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.96)
    }

    return textColor
  }

  func resolvedBackgroundColor(for widgetRenderingMode: WidgetRenderingMode) -> Color {
    if widgetRenderingMode == .accented {
      return Color.white.opacity(0.18)
    }

    return backgroundColor
  }
}

extension WidgetBadge.Configuration {
  var trimmedTitle: String? {
    guard let title else {
      return nil
    }

    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedTitle.isEmpty ? nil : trimmedTitle
  }

  var showsMetadata: Bool {
    showsLeadingStrip || trimmedTitle != nil
  }

  var showsLeadingStrip: Bool {
    state.showsLeadingStrip || showsLeadingMetadata
  }

  var hasLeadingCorner: Bool {
    state.hasLeadingCorner || showsLeadingMetadata
  }

  var hasTrailingCorner: Bool {
    state.hasTrailingCorner
  }
}

private extension WidgetBadge.Configuration.State {
  var showsLeadingStrip: Bool {
    self == .start
  }

  var hasLeadingCorner: Bool {
    switch self {
    case .start:
      true
    case .middle, .end, .allDay:
      false
    }
  }

  var hasTrailingCorner: Bool {
    switch self {
    case .end:
      true
    case .start, .middle, .allDay:
      false
    }
  }
}
