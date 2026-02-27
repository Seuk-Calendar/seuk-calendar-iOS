import SwiftUI

extension Color {
  init(_ colorFamily: PoolColor.ColorFamily, name: String) {
    self.init("\(colorFamily.rawValue)/\(name)", bundle: .designSystemBundle)
  }
}
