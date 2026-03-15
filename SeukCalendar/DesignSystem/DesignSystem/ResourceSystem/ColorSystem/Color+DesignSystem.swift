import SwiftUI

public enum SCColor {
  public enum ColorFamily: String, CaseIterable {
    case primitives = "Primitives"
    case core = "Core"
    case semantic = "Semantic" // TODO: 제거 필요
    case semanticBackground = "Semantic/Background"
    case semanticContent = "Semantic/Content"
    case semanticExtensions = "SemanticExtensions"
  }

  public enum Primitives {
    public static let amber100 = Color(SCColor.ColorFamily.primitives, name: "amber100")
    public static let amber200 = Color(SCColor.ColorFamily.primitives, name: "amber200")
    public static let amber300 = Color(SCColor.ColorFamily.primitives, name: "amber300")
    public static let amber400 = Color(SCColor.ColorFamily.primitives, name: "amber400")
    public static let amber50 = Color(SCColor.ColorFamily.primitives, name: "amber50")
    public static let amber500 = Color(SCColor.ColorFamily.primitives, name: "amber500")
    public static let amber600 = Color(SCColor.ColorFamily.primitives, name: "amber600")
    public static let amber700 = Color(SCColor.ColorFamily.primitives, name: "amber700")
    public static let amber800 = Color(SCColor.ColorFamily.primitives, name: "amber800")
    public static let amber900 = Color(SCColor.ColorFamily.primitives, name: "amber900")
    public static let black = Color(SCColor.ColorFamily.primitives, name: "black")
    public static let blue100 = Color(SCColor.ColorFamily.primitives, name: "blue100")
    public static let blue200 = Color(SCColor.ColorFamily.primitives, name: "blue200")
    public static let blue300 = Color(SCColor.ColorFamily.primitives, name: "blue300")
    public static let blue400 = Color(SCColor.ColorFamily.primitives, name: "blue400")
    public static let blue50 = Color(SCColor.ColorFamily.primitives, name: "blue50")
    public static let blue500 = Color(SCColor.ColorFamily.primitives, name: "blue500")
    public static let blue600 = Color(SCColor.ColorFamily.primitives, name: "blue600")
    public static let blue700 = Color(SCColor.ColorFamily.primitives, name: "blue700")
    public static let blue800 = Color(SCColor.ColorFamily.primitives, name: "blue800")
    public static let blue900 = Color(SCColor.ColorFamily.primitives, name: "blue900")
    public static let green100 = Color(SCColor.ColorFamily.primitives, name: "green100")
    public static let green200 = Color(SCColor.ColorFamily.primitives, name: "green200")
    public static let green300 = Color(SCColor.ColorFamily.primitives, name: "green300")
    public static let green400 = Color(SCColor.ColorFamily.primitives, name: "green400")
    public static let green50 = Color(SCColor.ColorFamily.primitives, name: "green50")
    public static let green500 = Color(SCColor.ColorFamily.primitives, name: "green500")
    public static let green600 = Color(SCColor.ColorFamily.primitives, name: "green600")
    public static let green700 = Color(SCColor.ColorFamily.primitives, name: "green700")
    public static let green800 = Color(SCColor.ColorFamily.primitives, name: "green800")
    public static let green900 = Color(SCColor.ColorFamily.primitives, name: "green900")
    public static let gray100 = Color(SCColor.ColorFamily.primitives, name: "gray100")
    public static let gray200 = Color(SCColor.ColorFamily.primitives, name: "gray200")
    public static let gray300 = Color(SCColor.ColorFamily.primitives, name: "gray300")
    public static let gray400 = Color(SCColor.ColorFamily.primitives, name: "gray400")
    public static let gray50 = Color(SCColor.ColorFamily.primitives, name: "gray50")
    public static let gray500 = Color(SCColor.ColorFamily.primitives, name: "gray500")
    public static let gray600 = Color(SCColor.ColorFamily.primitives, name: "gray600")
    public static let gray700 = Color(SCColor.ColorFamily.primitives, name: "gray700")
    public static let gray800 = Color(SCColor.ColorFamily.primitives, name: "gray800")
    public static let gray900 = Color(SCColor.ColorFamily.primitives, name: "gray900")
    public static let lime100 = Color(SCColor.ColorFamily.primitives, name: "lime100")
    public static let lime200 = Color(SCColor.ColorFamily.primitives, name: "lime200")
    public static let lime300 = Color(SCColor.ColorFamily.primitives, name: "lime300")
    public static let lime400 = Color(SCColor.ColorFamily.primitives, name: "lime400")
    public static let lime50 = Color(SCColor.ColorFamily.primitives, name: "lime50")
    public static let lime500 = Color(SCColor.ColorFamily.primitives, name: "lime500")
    public static let lime600 = Color(SCColor.ColorFamily.primitives, name: "lime600")
    public static let lime700 = Color(SCColor.ColorFamily.primitives, name: "lime700")
    public static let lime800 = Color(SCColor.ColorFamily.primitives, name: "lime800")
    public static let lime900 = Color(SCColor.ColorFamily.primitives, name: "lime900")
    public static let magenta100 = Color(SCColor.ColorFamily.primitives, name: "magenta100")
    public static let magenta200 = Color(SCColor.ColorFamily.primitives, name: "magenta200")
    public static let magenta300 = Color(SCColor.ColorFamily.primitives, name: "magenta300")
    public static let magenta400 = Color(SCColor.ColorFamily.primitives, name: "magenta400")
    public static let magenta50 = Color(SCColor.ColorFamily.primitives, name: "magenta50")
    public static let magenta500 = Color(SCColor.ColorFamily.primitives, name: "magenta500")
    public static let magenta600 = Color(SCColor.ColorFamily.primitives, name: "magenta600")
    public static let magenta700 = Color(SCColor.ColorFamily.primitives, name: "magenta700")
    public static let magenta800 = Color(SCColor.ColorFamily.primitives, name: "magenta800")
    public static let magenta900 = Color(SCColor.ColorFamily.primitives, name: "magenta900")
    public static let orange100 = Color(SCColor.ColorFamily.primitives, name: "orange100")
    public static let orange200 = Color(SCColor.ColorFamily.primitives, name: "orange200")
    public static let orange300 = Color(SCColor.ColorFamily.primitives, name: "orange300")
    public static let orange400 = Color(SCColor.ColorFamily.primitives, name: "orange400")
    public static let orange50 = Color(SCColor.ColorFamily.primitives, name: "orange50")
    public static let orange500 = Color(SCColor.ColorFamily.primitives, name: "orange500")
    public static let orange600 = Color(SCColor.ColorFamily.primitives, name: "orange600")
    public static let orange700 = Color(SCColor.ColorFamily.primitives, name: "orange700")
    public static let orange800 = Color(SCColor.ColorFamily.primitives, name: "orange800")
    public static let orange900 = Color(SCColor.ColorFamily.primitives, name: "orange900")
    public static let purple100 = Color(SCColor.ColorFamily.primitives, name: "purple100")
    public static let purple200 = Color(SCColor.ColorFamily.primitives, name: "purple200")
    public static let purple300 = Color(SCColor.ColorFamily.primitives, name: "purple300")
    public static let purple400 = Color(SCColor.ColorFamily.primitives, name: "purple400")
    public static let purple50 = Color(SCColor.ColorFamily.primitives, name: "purple50")
    public static let purple500 = Color(SCColor.ColorFamily.primitives, name: "purple500")
    public static let purple600 = Color(SCColor.ColorFamily.primitives, name: "purple600")
    public static let purple700 = Color(SCColor.ColorFamily.primitives, name: "purple700")
    public static let purple800 = Color(SCColor.ColorFamily.primitives, name: "purple800")
    public static let purple900 = Color(SCColor.ColorFamily.primitives, name: "purple900")
    public static let red100 = Color(SCColor.ColorFamily.primitives, name: "red100")
    public static let red200 = Color(SCColor.ColorFamily.primitives, name: "red200")
    public static let red300 = Color(SCColor.ColorFamily.primitives, name: "red300")
    public static let red400 = Color(SCColor.ColorFamily.primitives, name: "red400")
    public static let red50 = Color(SCColor.ColorFamily.primitives, name: "red50")
    public static let red500 = Color(SCColor.ColorFamily.primitives, name: "red500")
    public static let red600 = Color(SCColor.ColorFamily.primitives, name: "red600")
    public static let red700 = Color(SCColor.ColorFamily.primitives, name: "red700")
    public static let red800 = Color(SCColor.ColorFamily.primitives, name: "red800")
    public static let red900 = Color(SCColor.ColorFamily.primitives, name: "red900")
    public static let teal100 = Color(SCColor.ColorFamily.primitives, name: "teal100")
    public static let teal200 = Color(SCColor.ColorFamily.primitives, name: "teal200")
    public static let teal300 = Color(SCColor.ColorFamily.primitives, name: "teal300")
    public static let teal400 = Color(SCColor.ColorFamily.primitives, name: "teal400")
    public static let teal50 = Color(SCColor.ColorFamily.primitives, name: "teal50")
    public static let teal500 = Color(SCColor.ColorFamily.primitives, name: "teal500")
    public static let teal600 = Color(SCColor.ColorFamily.primitives, name: "teal600")
    public static let teal700 = Color(SCColor.ColorFamily.primitives, name: "teal700")
    public static let teal800 = Color(SCColor.ColorFamily.primitives, name: "teal800")
    public static let teal900 = Color(SCColor.ColorFamily.primitives, name: "teal900")
    public static let white = Color(SCColor.ColorFamily.primitives, name: "white")
    public static let yellow100 = Color(SCColor.ColorFamily.primitives, name: "yellow100")
    public static let yellow200 = Color(SCColor.ColorFamily.primitives, name: "yellow200")
    public static let yellow300 = Color(SCColor.ColorFamily.primitives, name: "yellow300")
    public static let yellow400 = Color(SCColor.ColorFamily.primitives, name: "yellow400")
    public static let yellow50 = Color(SCColor.ColorFamily.primitives, name: "yellow50")
    public static let yellow500 = Color(SCColor.ColorFamily.primitives, name: "yellow500")
    public static let yellow600 = Color(SCColor.ColorFamily.primitives, name: "yellow600")
    public static let yellow700 = Color(SCColor.ColorFamily.primitives, name: "yellow700")
    public static let yellow800 = Color(SCColor.ColorFamily.primitives, name: "yellow800")
    public static let yellow900 = Color(SCColor.ColorFamily.primitives, name: "yellow900")
  }

  public enum Core {
    public static let accent = Primitives.blue600
    public static let negative = Primitives.red600
    public static let positive = Primitives.green600
    public static let primaryA = Primitives.black
    public static let primaryB = Primitives.white
    public static let warning = Primitives.yellow300
  }

  public enum Semantic {
    public enum Background {
      public static let primary = Color(SCColor.ColorFamily.semanticBackground, name: "Primary")
      public static let secondary = Color(SCColor.ColorFamily.semanticBackground, name: "Secondary")
      public static let tertiary = Color(SCColor.ColorFamily.semanticBackground, name: "Tertiary")
    }

    public enum Border {
      public static let borderInverseOpaque = Primitives.gray800
      public static let borderInverseSelected = Primitives.white
      public static let borderInverseTransparent = Primitives.white.opacity(0.2)
      public static let borderOpaque = Primitives.gray100
      public static let borderSelected = Primitives.black
      public static let borderTransparent = Primitives.black.opacity(0.08)
    }

    public enum Content {
      public static let primary = Color(SCColor.ColorFamily.semanticContent, name: "Primary")
      public static let secondary = Color(SCColor.ColorFamily.semanticContent, name: "Secondary")
      public static let tertiary = Color(SCColor.ColorFamily.semanticContent, name: "Tertiary")
    }
  }

  public enum SemanticExtensions {
    public enum Background {
      public static let backgroundAccent = Primitives.blue600
      public static let backgroundAlwaysDark = Primitives.black
      public static let backgroundAlwaysLight = Primitives.white
      public static let backgroundLightAccent = Primitives.blue50
      public static let backgroundLightNegative = Primitives.red50
      public static let backgroundLightPositive = Primitives.green50
      public static let backgroundLightWarning = Primitives.yellow50
      public static let backgroundNegative = Primitives.red600
      public static let backgroundOverlayArt = Primitives.black.opacity(0)
      public static let backgroundOverlayDark = Primitives.black.opacity(0.5)
      public static let backgroundOverlayElevation = Primitives.black.opacity(0)
      public static let backgroundPositive = Primitives.green600
      public static let backgroundStateDisabled = Primitives.gray50
      public static let backgroundWarning = Primitives.yellow300
    }

    public enum Border {
      public static let borderAccent = Primitives.blue600
      public static let borderAccentLight = Primitives.blue200
      public static let borderNegative = Primitives.red600
      public static let borderPositive = Primitives.green600
      public static let borderStateDisabled = Primitives.gray50
      public static let borderWarning = Primitives.yellow600
    }

    public enum Content {
      public static let contentAccent = Primitives.blue600
      public static let contentNegative = Primitives.red600
      public static let contentOnColor = Primitives.white
      public static let contentOnColorInverse = Primitives.black
      public static let contentPositive = Primitives.green600
      public static let contentStateDisabled = Primitives.gray400
      public static let contentWarning = Primitives.yellow600
    }
  }

  public enum Calendar {
    public static let blue = Primitives.blue200
    public static let green = Primitives.green200
    public static let orange = Primitives.orange200
    public static let pink = Primitives.magenta200
    public static let purple = Primitives.purple200
    public static let red = Primitives.red200
    public static let yellow = Primitives.yellow200
  }
}

public extension Color {
  static let primitives = SCColor.Primitives.self
  static let core = SCColor.Core.self
  static let semantic = SCColor.Semantic.self
  static let semanticExtensions = SCColor.SemanticExtensions.self
  static let calendar = SCColor.Calendar.self
  static let poolCalendar = SCColor.Calendar.self
}
