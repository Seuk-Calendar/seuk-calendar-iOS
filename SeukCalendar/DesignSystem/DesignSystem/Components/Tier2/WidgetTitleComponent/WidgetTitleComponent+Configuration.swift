import Foundation

public extension WidgetTitleComponent {
  struct Configuration: Hashable, Sendable {
    public let title: String

    public init(title: String) {
      self.title = title
    }
  }
}
