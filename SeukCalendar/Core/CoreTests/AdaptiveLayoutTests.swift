@testable import Core
import SwiftUI
import Testing

struct AdaptiveLayoutTests {
  @Test("가로 폭이 기준보다 좁으면 compact 레이아웃을 사용한다")
  func usesCompactLayoutWhenWidthIsNarrow() {
    let adaptiveLayout = AdaptiveLayout(
      horizontalSizeClass: .regular,
      width: 680
    )

    #expect(adaptiveLayout.usesCompactLayout)
    #expect(!adaptiveLayout.usesPadLayout)
  }

  @Test("horizontal size class가 compact면 충분한 폭이어도 compact 레이아웃을 사용한다")
  func usesCompactLayoutWhenHorizontalSizeClassIsCompact() {
    let adaptiveLayout = AdaptiveLayout(
      horizontalSizeClass: .compact,
      width: 900
    )

    #expect(adaptiveLayout.usesCompactLayout)
    #expect(!adaptiveLayout.usesPadLayout)
  }

  @Test("가로 폭이 충분하고 horizontal size class가 compact가 아니면 pad 레이아웃을 사용한다")
  func usesPadLayoutWhenWidthIsWideEnough() {
    let adaptiveLayout = AdaptiveLayout(
      horizontalSizeClass: .regular,
      width: 900
    )

    #expect(!adaptiveLayout.usesCompactLayout)
    #expect(adaptiveLayout.usesPadLayout)
  }

  @Test("size class가 없더라도 실제 폭 기준으로 레이아웃을 결정한다")
  func fallsBackToWidthWhenSizeClassIsUnavailable() {
    let compactLayout = AdaptiveLayout(
      horizontalSizeClass: nil,
      width: 640
    )
    let padLayout = AdaptiveLayout(
      horizontalSizeClass: nil,
      width: 820
    )

    #expect(compactLayout.usesCompactLayout)
    #expect(!compactLayout.usesPadLayout)
    #expect(!padLayout.usesCompactLayout)
    #expect(padLayout.usesPadLayout)
  }
}
