import SwiftUI

public struct AdaptiveLayout {
  public static let defaultPadLayoutMinWidth: CGFloat = 700

  private let horizontalSizeClass: UserInterfaceSizeClass?
  private let width: CGFloat
  private let padLayoutMinWidth: CGFloat

  public init(
    horizontalSizeClass: UserInterfaceSizeClass?,
    width: CGFloat,
    padLayoutMinWidth: CGFloat = AdaptiveLayout.defaultPadLayoutMinWidth
  ) {
    self.horizontalSizeClass = horizontalSizeClass
    self.width = width
    self.padLayoutMinWidth = padLayoutMinWidth
  }

  public var usesCompactLayout: Bool {
    width < padLayoutMinWidth || horizontalSizeClass == .compact // 시스템이 제안한 .compact를 우선 존중
  }

  public var usesPadLayout: Bool {
    !usesCompactLayout
  }
}
