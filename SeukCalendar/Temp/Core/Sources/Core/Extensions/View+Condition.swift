import SwiftUI

public extension View {
  @ViewBuilder
  func `if`<Content: View>(
    condition: Bool,
    _ transform: (Self) -> Content
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  @ViewBuilder
  func ifLet<Value, Content: View>(
    value: Value?,
    _ transform: (Self, Value) -> Content
  ) -> some View {
    if let value {
      transform(self, value)
    } else {
      self
    }
  }
}
