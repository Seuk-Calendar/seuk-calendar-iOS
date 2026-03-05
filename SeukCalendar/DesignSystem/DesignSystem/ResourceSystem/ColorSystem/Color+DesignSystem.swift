import SwiftUI

public enum PoolColor {
  public enum ColorFamily: String, CaseIterable {
    case grays
    case primary = "Primary"
    case semantic = "Semantic"
    case calendar = "Calendar"
  }

  public enum Grays {
    public static let black = Color(PoolColor.ColorFamily.grays, name: "black")
    public static let white = Color(PoolColor.ColorFamily.grays, name: "white")
    public static let gray1 = Color(PoolColor.ColorFamily.grays, name: "gray1")
    public static let gray2 = Color(PoolColor.ColorFamily.grays, name: "gray2")
    public static let gray3 = Color(PoolColor.ColorFamily.grays, name: "gray3")
    public static let gray4 = Color(PoolColor.ColorFamily.grays, name: "gray4")
    public static let gray5 = Color(PoolColor.ColorFamily.grays, name: "gray5")
    public static let gray6 = Color(PoolColor.ColorFamily.grays, name: "gray6")
    public static let gray7 = Color(PoolColor.ColorFamily.grays, name: "gray7")
    public static let gray8 = Color(PoolColor.ColorFamily.grays, name: "gray8")
    public static let gray9 = Color(PoolColor.ColorFamily.grays, name: "gray9")

    /// Legacy token alias
    public static let gray = gray6
  }

  public enum Primary {
    public static let primary1 = Color(PoolColor.ColorFamily.primary, name: "primary1")
    public static let primary2 = Color(PoolColor.ColorFamily.primary, name: "primary2")
    public static let primary3 = Color(PoolColor.ColorFamily.primary, name: "primary3")
  }

  public enum Semantic {
    public static let success1 = Color(PoolColor.ColorFamily.semantic, name: "success1")
    public static let success2 = Color(PoolColor.ColorFamily.semantic, name: "success2")
    public static let warning1 = Color(PoolColor.ColorFamily.semantic, name: "warning1")
    public static let warning2 = Color(PoolColor.ColorFamily.semantic, name: "warning2")
    public static let error1 = Color(PoolColor.ColorFamily.semantic, name: "error1")
    public static let error2 = Color(PoolColor.ColorFamily.semantic, name: "error2")
    public static let info1 = Color(PoolColor.ColorFamily.semantic, name: "info1")
    public static let info2 = Color(PoolColor.ColorFamily.semantic, name: "info2")
  }

  public enum Calendar {
    public static let red = Color(PoolColor.ColorFamily.calendar, name: "calendar-red")
    public static let orange = Color(PoolColor.ColorFamily.calendar, name: "calendar-orange")
    public static let yellow = Color(PoolColor.ColorFamily.calendar, name: "calendar-yellow")
    public static let green = Color(PoolColor.ColorFamily.calendar, name: "calendar-green")
    public static let blue = Color(PoolColor.ColorFamily.calendar, name: "calendar-blue")
    public static let purple = Color(PoolColor.ColorFamily.calendar, name: "calendar-purple")
    public static let pink = Color(PoolColor.ColorFamily.calendar, name: "calendar-pink")
  }
}

public extension Color {
  static let grays = PoolColor.Grays.self
  static let poolPrimary = PoolColor.Primary.self
  static let poolSemantic = PoolColor.Semantic.self
  static let poolCalendar = PoolColor.Calendar.self
}
