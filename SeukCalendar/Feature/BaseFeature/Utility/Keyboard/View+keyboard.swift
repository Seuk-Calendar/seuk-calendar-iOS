import SwiftUI

public extension View {
  func registerKeyboardResign() -> some View {
    #if canImport(UIKit)
      self.onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
    #else
      self
    #endif
  }
}
