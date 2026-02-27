//
//  ContextPopup+Configuration.swift
//  DesignSystem
//
//  Created by YoungK on 11/5/25.
//

import SwiftUI

public extension PLContextPopup {
  struct Configuration {
    let vPadding: CGFloat
    let spacing: CGFloat
    let backgroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat

    public init(
      vPadding: CGFloat = 10,
      spacing: CGFloat = 5,
      backgroundColor: Color = Color.backgrounds.primary,
      borderColor: Color = Color.labels.tertiary,
      borderWidth: CGFloat = 1
    ) {
      self.vPadding = vPadding
      self.spacing = spacing
      self.backgroundColor = backgroundColor
      self.borderColor = borderColor
      self.borderWidth = borderWidth
    }
  }
}
