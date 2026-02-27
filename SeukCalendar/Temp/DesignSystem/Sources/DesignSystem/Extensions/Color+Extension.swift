import SwiftUI

public extension Color {
  init(hex: UInt32) {
    let alhpa, red, green, blue: UInt32
    if hex > 0xFFFFFF {
      // 32비트 (AARRGGBB)
      alhpa = (hex & 0xFF00_0000) >> 24
      red = (hex & 0x00FF_0000) >> 16
      green = (hex & 0x0000_FF00) >> 8
      blue = hex & 0x0000_00FF
    } else {
      // 24비트 (RRGGBB)
      alhpa = 255
      red = (hex & 0xFF0000) >> 16
      green = (hex & 0x00FF00) >> 8
      blue = hex & 0x0000FF
    }

    self.init(
      .sRGB,
      red: Double(red) / 255,
      green: Double(green) / 255,
      blue: Double(blue) / 255,
      opacity: Double(alhpa) / 255
    )
  }
}
