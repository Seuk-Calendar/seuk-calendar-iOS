import SwiftUI

public extension BadgeSegmentComponent {
  struct Configuration: Hashable, Sendable {
    public enum Variant: Hashable, Sendable {
      case startAndEnd
      case start
      case middle
      case end
    }

    public let variant: Variant
    public let label: String?
    public let foregroundColor: Color
    public let backgroundColor: Color
    public let showsLeadingStrip: Bool

    public init(
      variant: Variant,
      label: String? = nil,
      foregroundColor: Color,
      backgroundColor: Color,
      showsLeadingStrip: Bool = false
    ) {
      self.variant = variant
      self.label = label
      self.foregroundColor = foregroundColor
      self.backgroundColor = backgroundColor
      self.showsLeadingStrip = showsLeadingStrip
    }
  }
}

extension BadgeSegmentComponent.Configuration {
  var trimmedLabel: String? {
    guard let label else {
      return nil
    }

    let trimmed = label.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : trimmed
  }

  var showsMetadata: Bool {
    showsLeadingStrip || trimmedLabel != nil
  }
}

extension BadgeSegmentComponent.Configuration.Variant {
  var hasLeadingCorner: Bool {
    switch self {
    case .startAndEnd, .start:
      true
    case .middle, .end:
      false
    }
  }

  var hasTrailingCorner: Bool {
    switch self {
    case .startAndEnd, .end:
      true
    case .start, .middle:
      false
    }
  }
}
