import SwiftUI

extension Color {
  init(_ colorFamily: SCColor.ColorFamily, name: String) {
    self.init("\(colorFamily.rawValue)/\(name)", bundle: .designSystemBundle)
  }
}
