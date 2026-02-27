import SwiftUI

public extension Binding {
  static func get(_ get: @escaping () -> Value) -> Binding<Value> {
    Binding(
      get: get,
      set: { _ in }
    )
  }
}
