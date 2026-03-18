import SwiftUI

#if canImport(UIKit)
  import UIKit

  public typealias PlatformFont = UIFont
#elseif canImport(AppKit)
  import AppKit

  public typealias PlatformFont = NSFont
#endif

public protocol FontStyleType {
  associatedtype Family: FontFamilyType
  var weight: Family.Weight { get }
  var size: CGFloat { get }
  var lineHeight: CGFloat { get }
  var letterSpacingRatio: CGFloat { get }
}

public extension FontStyleType {
  var fontName: String {
    "\(Family.name)-\(weight.rawValue)"
  }

  var uiFont: PlatformFont {
    return PlatformFont(name: fontName, size: size) ?? PlatformFont.systemFont(ofSize: size)
  }

  var lineHeightRatio: CGFloat {
    return lineHeight / size
  }

  var font: SwiftUI.Font {
    SwiftUI.Font(uiFont)
  }

  var fontLineHeight: CGFloat {
    #if canImport(UIKit)
      return uiFont.lineHeight
    #elseif canImport(AppKit)
      return ceil(uiFont.ascender - uiFont.descender + uiFont.leading)
    #else
      return lineHeight
    #endif
  }
}
