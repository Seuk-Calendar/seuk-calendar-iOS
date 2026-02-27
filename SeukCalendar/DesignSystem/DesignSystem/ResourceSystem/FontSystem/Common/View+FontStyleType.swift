import SwiftUI
import UIKit
import Core

public extension View {
  func font(
    _ style: any FontStyleType,
    isSingleLine: Bool = true
  ) -> some View {
    let ratio: CGFloat = style.lineHeightRatio - 1 // 1.3 - 1 = 30%
    let height = style.uiFont.lineHeight * ratio // 추가로 더해질 높이
    let harf = height / 2
    let padding = harf / 2
    let letterSpacing: CGFloat = style.size * (style.letterSpacingRatio / 100)

    return self.font(style.font)
      .padding(.vertical, padding)
      .if(condition: !isSingleLine, {
        $0.lineSpacing(harf)
      })
      .kerning(letterSpacing)
  }

}
