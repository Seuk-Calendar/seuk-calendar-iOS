//
//  PLTag+Configuration.swift
//  DesignSystem
//
//  Created by YoungK on 11/3/25.
//

import SwiftUI

public extension PLTag {
  struct Colors {
    let foregroundColor: Color
    let backgroundColor: Color

    public init(foregroundColor: Color, backgroundColor: Color) {
      self.foregroundColor = foregroundColor
      self.backgroundColor = backgroundColor
    }
  }

  struct Configuration {
    let leadingIcon: ImageResource?
    let trailingIcon: ImageResource?
    let normalColors: Colors
    let selectedColors: Colors

    public init(
      leadingIcon: ImageResource? = nil,
      trailingIcon: ImageResource? = nil,
      normalColors: Colors = PLTag.Colors(
        foregroundColor: Color.labels.secondary,
        backgroundColor: Color.fills.quaternary
      ),
      selectedColors: Colors = PLTag.Colors(
        foregroundColor: Color.labels.primary,
        backgroundColor: Color.fills.primary
      )
    ) {
      self.leadingIcon = leadingIcon
      self.trailingIcon = trailingIcon
      self.normalColors = normalColors
      self.selectedColors = selectedColors
    }
  }
}
