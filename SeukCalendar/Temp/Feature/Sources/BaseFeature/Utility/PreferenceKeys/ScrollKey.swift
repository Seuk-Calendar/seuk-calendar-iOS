import SwiftUI

public struct ScrollKey: PreferenceKey {
  public static var defaultValue: CGRect = .zero
  public static func reduce(
    value: inout CGRect,
    nextValue: () -> CGRect
  ) {
    value = nextValue()
  }
}

public extension View {
  ///  axis에 해당하는 가장 가까운 scrollView를 기준으로 Rect를 받습니다.
  /// - Parameters:
  ///   - axis: 기준 축
  ///   - completion: CGRect를 전달
  /// - Returns: View
  func didScroll(
    axis: Axis = .horizontal,
    _ completion: @escaping (CGRect) -> Void
  ) -> some View {
    self
      .overlay {
        GeometryReader {
          let rect = $0.frame(in: .scrollView(axis: axis))

          Color.clear
            .preference(key: ScrollKey.self, value: rect)
            .onPreferenceChange(ScrollKey.self, perform: completion)
        }
      }
  }
}
