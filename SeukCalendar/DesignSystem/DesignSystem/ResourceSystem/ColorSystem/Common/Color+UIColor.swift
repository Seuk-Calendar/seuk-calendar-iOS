import SwiftUI

#if canImport(UIKit)
  import UIKit

  public extension Color {
    func uiColor() -> UIColor {
      return UIColor(self)
    }
  }
#endif
