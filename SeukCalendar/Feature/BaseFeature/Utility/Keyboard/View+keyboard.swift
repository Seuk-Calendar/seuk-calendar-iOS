import SwiftUI

public extension View {
  func registerKeyboardResign() -> some View {
    self.onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}
