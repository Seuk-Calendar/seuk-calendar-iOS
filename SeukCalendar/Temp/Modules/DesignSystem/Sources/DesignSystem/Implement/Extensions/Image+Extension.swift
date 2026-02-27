//
//  Image+Extension.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 9/25/25.
//

import SwiftUI

public extension Image {
  func tint(_ color: Color) -> some View {
    self
      .renderingMode(.template)
      .foregroundStyle(color)
  }
}
