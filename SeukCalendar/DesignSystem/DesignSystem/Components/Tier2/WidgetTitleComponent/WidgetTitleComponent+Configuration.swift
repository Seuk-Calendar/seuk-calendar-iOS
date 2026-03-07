import Foundation

public extension WidgetTitleComponent {
  struct Configuration: Hashable, Sendable {
    public let title: String
    let style: Style

    public init(title: String) {
      self.title = title
      style = .standard
    }

    init(
      title: String,
      style: Style
    ) {
      self.title = title
      self.style = style
    }
  }
}

extension WidgetTitleComponent.Configuration {
  enum Style: Hashable, Sendable {
    case standard
    case compact
  }
}
