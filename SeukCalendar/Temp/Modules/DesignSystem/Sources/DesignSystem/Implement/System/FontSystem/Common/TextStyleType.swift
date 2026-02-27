//
//  TextStyleType.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 7/15/25.
//

import SwiftUI
import UIKit

public protocol FontStyleType {
  associatedtype Family: FontFamilyType
  var weight: Family.Weight { get }
  var size: CGFloat { get }
  var lineHeightRatio: CGFloat { get }
  var letterSpacingRatio: CGFloat { get }
}

public extension FontStyleType {
  var uiFont: UIFont {
    return UIFont(name: "\(Family.name)-\(weight)", size: size) ?? UIFont.systemFont(ofSize: size)
  }

  var font: SwiftUI.Font {
    SwiftUI.Font(uiFont)
  }

  var fontLineHeight: CGFloat {
    return uiFont.lineHeight
  }
}
