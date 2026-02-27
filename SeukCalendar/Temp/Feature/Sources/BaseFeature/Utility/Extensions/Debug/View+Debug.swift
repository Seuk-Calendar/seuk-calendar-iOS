import SwiftUI

#if DEBUG
public extension View {
  /// 디버그용 배경색 (DEBUG에서만 나타남)
  func debugBackground(_ color: Color = .random, opacity: Double = 0.3) -> some View {
    self.background(color.opacity(opacity))
  }

  /// 디버그용 테두리 (DEBUG에서만 나타남)
  func debugBorder(_ color: Color = .random, width: CGFloat = 1) -> some View {
    self.border(color, width: width)
  }
}

#else
public extension View {
  func debugBackground(_ color: Color = .clear, opacity: Double = 0) -> some View { self }
  func debugBorder(_ color: Color = .clear, width: CGFloat = 0) -> some View { self }
}
#endif

public extension Color {
  static var random: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
}
