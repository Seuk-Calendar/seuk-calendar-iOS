import Core
import SwiftUI

public extension View {
  func font(
    _ style: any FontStyleType,
    isSingleLine: Bool = true
  ) -> some View {
    let extraLineHeight = max(style.lineHeight - style.fontLineHeight, 0)
    let verticalPadding = extraLineHeight / 2
    let letterSpacing: CGFloat = style.size * (style.letterSpacingRatio / 100)

    return self.font(style.font)
      .padding(.vertical, verticalPadding)
      .if(condition: !isSingleLine) {
        $0.lineSpacing(extraLineHeight)
      }
      .kerning(letterSpacing)
  }
}
