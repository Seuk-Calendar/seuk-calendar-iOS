import SwiftUI

public enum PoolColor {
  public enum ColorFamily: String, CaseIterable {
    // 예전 컬러 삭제 예정
    case primary = "Primary"
    case secondary = "Secondary"
    case grayScale = "GrayScale"
    case error = "Error"

    case grays
    case backgrounds
    case backgroundsGrouped = "backgrounds_grouped"
    case colors
    case fills
    case labels
    case overlays
    case separators
    case etc = "ETC"
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

  public enum Backgrounds {
    public static let tertiary = Color(PoolColor.ColorFamily.backgrounds, name: "tertiary")
    public static let secondary = Color(PoolColor.ColorFamily.backgrounds, name: "secondary")
    public static let primary = Color(PoolColor.ColorFamily.backgrounds, name: "primary")
  }

  public enum BackgroundsGrouped {
    public static let tertiary = Color(PoolColor.ColorFamily.backgroundsGrouped, name: "tertiary")
    public static let secondary = Color(PoolColor.ColorFamily.backgroundsGrouped, name: "secondary")
    public static let primary = Color(PoolColor.ColorFamily.backgroundsGrouped, name: "primary")
  }

  public enum Colors {
    public static let purple = Color(PoolColor.ColorFamily.colors, name: "purple")
    public static let indigo = Color(PoolColor.ColorFamily.colors, name: "indigo")
    public static let cyan = Color(PoolColor.ColorFamily.colors, name: "cyan")
    public static let green = Color(PoolColor.ColorFamily.colors, name: "green")
    public static let blue = Color(PoolColor.ColorFamily.colors, name: "blue")
    public static let yellow = Color(PoolColor.ColorFamily.colors, name: "yellow")
    public static let brown = Color(PoolColor.ColorFamily.colors, name: "brown")
    public static let teal = Color(PoolColor.ColorFamily.colors, name: "teal")
    public static let pink = Color(PoolColor.ColorFamily.colors, name: "pink")
    public static let orange = Color(PoolColor.ColorFamily.colors, name: "orange")
    public static let red = Color(PoolColor.ColorFamily.colors, name: "red")
    public static let brand = Color(PoolColor.ColorFamily.colors, name: "brand")
  }

  public enum Fills {
    public static let quaternary = Color(PoolColor.ColorFamily.fills, name: "quaternary")
    public static let tertiary = Color(PoolColor.ColorFamily.fills, name: "tertiary")
    public static let secondary = Color(PoolColor.ColorFamily.fills, name: "secondary")
    public static let primary = Color(PoolColor.ColorFamily.fills, name: "primary")
  }

  public enum Labels {
    public static let quaternary = Color(PoolColor.ColorFamily.labels, name: "quaternary")
    public static let tertiary = Color(PoolColor.ColorFamily.labels, name: "tertiary")
    public static let secondary = Color(PoolColor.ColorFamily.labels, name: "secondary")
    public static let primary = Color(PoolColor.ColorFamily.labels, name: "primary")
  }

  public enum Overlays {
    public static let activityViewController = Color(PoolColor.ColorFamily.overlays, name: "activity_view_controller")
    public static let `default` = Color(PoolColor.ColorFamily.overlays, name: "default")
  }

  public enum Separators {
    public static let nonOpaque = Color(PoolColor.ColorFamily.separators, name: "non_opaque")
    public static let opaque = Color(PoolColor.ColorFamily.separators, name: "opaque")
    public static let separators = Color(PoolColor.ColorFamily.separators, name: "separators")
  }

  public enum Etc {
    public static let buttonDisabeldBg = Color(PoolColor.ColorFamily.etc, name: "button_disabeld_bg")
    public static let tabUnselected = Color(PoolColor.ColorFamily.etc, name: "tab_unselected")
    public static let textFieldOutline = Color(PoolColor.ColorFamily.etc, name: "text_field_outline")
  }
}

public extension Color {
  static let grays = PoolColor.Grays.self
  static let backgrounds = PoolColor.Backgrounds.self
  static let backgroundsGrouped = PoolColor.BackgroundsGrouped.self
  static let colors = PoolColor.Colors.self
  static let fills = PoolColor.Fills.self
  static let labels = PoolColor.Labels.self
  static let overlays = PoolColor.Overlays.self
  static let separators = PoolColor.Separators.self
  static let etc = PoolColor.Etc.self
}
