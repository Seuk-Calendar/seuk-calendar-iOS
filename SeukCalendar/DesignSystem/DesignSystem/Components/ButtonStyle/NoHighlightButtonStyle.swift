//
//  NoHighlightButtonStyle.swift
//  Pool
//
//  Created by yongbeomkwak on 7/12/25.
//

import SwiftUI

public struct NoHighlightButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 1.0 : 1.0) // 클릭 시 변화 없음
      .animation(nil, value: configuration.isPressed) // 애니메이션 제거
  }
}
