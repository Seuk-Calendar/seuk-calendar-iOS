import SwiftUI
import UIKit

public protocol FontStyleType {
  associatedtype Family: FontFamilyType
  var weight: Family.Weight { get }
  var size: CGFloat { get }
  var lineHeight: CGFloat { get }
  var letterSpacingRatio: CGFloat { get }
}

public extension FontStyleType {
  var uiFont: UIFont {
    return UIFont(name: "\(Family.name)-\(weight)", size: size) ?? UIFont.systemFont(ofSize: size)
  }

  var lineHeightRatio: CGFloat {
    return lineHeight / size
  }

  var font: SwiftUI.Font {
    SwiftUI.Font(uiFont)
  }

  var fontLineHeight: CGFloat {
    return uiFont.lineHeight
  }
}
