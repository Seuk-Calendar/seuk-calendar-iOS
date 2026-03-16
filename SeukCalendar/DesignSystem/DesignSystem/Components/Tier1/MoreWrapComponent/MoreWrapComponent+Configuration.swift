import Foundation

public extension MoreWrapComponent {
  struct Configuration: Hashable, Sendable {
    public let count: Int?
    public let text: String?

    public init(
      count: Int? = nil,
      text: String? = nil
    ) {
      self.count = count
      self.text = text
    }
  }
}

extension MoreWrapComponent.Configuration {
  var displayText: String? {
    if let count {
      guard count > 0 else {
        return nil
      }

      return "+\(count)"
    }

    guard let text else {
      return nil
    }

    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : trimmed
  }
}
