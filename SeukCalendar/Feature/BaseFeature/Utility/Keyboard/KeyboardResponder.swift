import Combine
import SwiftUI

struct KeyboardResponder: ViewModifier {
  @State private var keyboardHeight: CGFloat = 0

  func body(content: Content) -> some View {
    #if canImport(UIKit)
      return content
        .padding(.bottom, keyboardHeight)
        .onReceive(NotificationCenter.default.keyboardWillShowPublisher, perform: { height in
          keyboardHeight = height - UIApplication.shared.safeAreaInsets.bottom
        })
        .onReceive(NotificationCenter.default.keyboardWillHidePublisher, perform: { _ in
          keyboardHeight = .zero
        })
        .animation(.spring, value: keyboardHeight)
    #else
      return content
    #endif
  }
}

public extension View {
  func keyboardResponder() -> some View {
    modifier(KeyboardResponder())
  }
}
