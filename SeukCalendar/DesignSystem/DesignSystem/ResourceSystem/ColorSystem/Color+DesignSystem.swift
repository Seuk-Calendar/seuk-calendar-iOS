import SwiftUI

public enum PoolColor {
  public enum ColorFamily: String, CaseIterable {
    case grays
  }

  public enum Grays {
    public static let black = Color(PoolColor.ColorFamily.grays, name: "black")
    public static let white = Color(PoolColor.ColorFamily.grays, name: "white")
    public static let gray = Color(PoolColor.ColorFamily.grays, name: "gray")
    public static let gray2 = Color(PoolColor.ColorFamily.grays, name: "gray2")
    public static let gray5 = Color(PoolColor.ColorFamily.grays, name: "gray5")
    public static let gray6 = Color(PoolColor.ColorFamily.grays, name: "gray6")
    public static let gray4 = Color(PoolColor.ColorFamily.grays, name: "gray4")
    public static let gray3 = Color(PoolColor.ColorFamily.grays, name: "gray3")
  }
}

public extension Color {
  static let grays = PoolColor.Grays.self
}
