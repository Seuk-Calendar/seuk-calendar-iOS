import SwiftUI

public extension EdgeInsets {
  init(
    vertical: CGFloat = .zero,
    horizontal: CGFloat = .zero
  ) {
    self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
  }
}
