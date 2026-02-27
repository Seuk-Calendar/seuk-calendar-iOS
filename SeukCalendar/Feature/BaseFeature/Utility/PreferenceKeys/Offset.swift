import SwiftUI

public struct OffsetKey: PreferenceKey {
  public static var defaultValue: CGFloat = .zero
  public static func reduce(
    value: inout CGFloat,
    nextValue: () -> CGFloat
  ) {
    value = nextValue()
  }
}

public extension View {

  /// 해당 좌표계에서, 특정 edge에 해당되는 값을 얻음
  /// - Parameters:
  ///   - coordinateSpace: 좌표게 네임스페이스
  ///   - edge: CGRectEdge
  ///   - offset: 핸들러 함수
  /// - Returns: edge값
  @ViewBuilder
  func offset(
    coordinateSpace: String,
    edge: CGRectEdge,
    offset: @escaping ((CGFloat) -> Void)
  ) -> some View {
    self
      .overlay {
        GeometryReader { proxy in
          let frame = proxy.frame(in: .named(coordinateSpace))

          let value: CGFloat = switch edge {
          case .minXEdge: frame.minX
          case .maxXEdge: frame.maxX
          case .minYEdge: frame.minY
          case .maxYEdge: frame.maxY
          }

          Color.clear
            .preference(key: OffsetKey.self, value: value)
            .onPreferenceChange(OffsetKey.self) {
              offset($0)
            }
        }
      }
  }
}
