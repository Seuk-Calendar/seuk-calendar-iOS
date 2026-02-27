import SwiftUI

public extension Image {
  func tint(_ color: Color) -> some View {
    self
      .renderingMode(.template)
      .foregroundStyle(color)
  }
}
