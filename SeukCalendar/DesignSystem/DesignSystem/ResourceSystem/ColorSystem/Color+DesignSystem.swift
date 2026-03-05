import SwiftUI

public enum PoolColor {
  public enum ColorFamily: String, CaseIterable {
    case primitives = "Primitives"
    case core = "Core"
    case semantic = "Semantic"
    case semanticExtensions = "SemanticExtensions"
  }

  public enum Primitives {
    public static let amber100 = Color(PoolColor.ColorFamily.primitives, name: "amber100")
    public static let amber200 = Color(PoolColor.ColorFamily.primitives, name: "amber200")
    public static let amber300 = Color(PoolColor.ColorFamily.primitives, name: "amber300")
    public static let amber400 = Color(PoolColor.ColorFamily.primitives, name: "amber400")
    public static let amber50 = Color(PoolColor.ColorFamily.primitives, name: "amber50")
    public static let amber500 = Color(PoolColor.ColorFamily.primitives, name: "amber500")
    public static let amber600 = Color(PoolColor.ColorFamily.primitives, name: "amber600")
    public static let amber700 = Color(PoolColor.ColorFamily.primitives, name: "amber700")
    public static let amber800 = Color(PoolColor.ColorFamily.primitives, name: "amber800")
    public static let amber900 = Color(PoolColor.ColorFamily.primitives, name: "amber900")
    public static let black = Color(PoolColor.ColorFamily.primitives, name: "black")
    public static let blue100 = Color(PoolColor.ColorFamily.primitives, name: "blue100")
    public static let blue200 = Color(PoolColor.ColorFamily.primitives, name: "blue200")
    public static let blue300 = Color(PoolColor.ColorFamily.primitives, name: "blue300")
    public static let blue400 = Color(PoolColor.ColorFamily.primitives, name: "blue400")
    public static let blue50 = Color(PoolColor.ColorFamily.primitives, name: "blue50")
    public static let blue500 = Color(PoolColor.ColorFamily.primitives, name: "blue500")
    public static let blue600 = Color(PoolColor.ColorFamily.primitives, name: "blue600")
    public static let blue700 = Color(PoolColor.ColorFamily.primitives, name: "blue700")
    public static let blue800 = Color(PoolColor.ColorFamily.primitives, name: "blue800")
    public static let blue900 = Color(PoolColor.ColorFamily.primitives, name: "blue900")
    public static let green100 = Color(PoolColor.ColorFamily.primitives, name: "green100")
    public static let green200 = Color(PoolColor.ColorFamily.primitives, name: "green200")
    public static let green300 = Color(PoolColor.ColorFamily.primitives, name: "green300")
    public static let green400 = Color(PoolColor.ColorFamily.primitives, name: "green400")
    public static let green50 = Color(PoolColor.ColorFamily.primitives, name: "green50")
    public static let green500 = Color(PoolColor.ColorFamily.primitives, name: "green500")
    public static let green600 = Color(PoolColor.ColorFamily.primitives, name: "green600")
    public static let green700 = Color(PoolColor.ColorFamily.primitives, name: "green700")
    public static let green800 = Color(PoolColor.ColorFamily.primitives, name: "green800")
    public static let green900 = Color(PoolColor.ColorFamily.primitives, name: "green900")
    public static let gray100 = Color(PoolColor.ColorFamily.primitives, name: "gray100")
    public static let gray200 = Color(PoolColor.ColorFamily.primitives, name: "gray200")
    public static let gray300 = Color(PoolColor.ColorFamily.primitives, name: "gray300")
    public static let gray400 = Color(PoolColor.ColorFamily.primitives, name: "gray400")
    public static let gray50 = Color(PoolColor.ColorFamily.primitives, name: "gray50")
    public static let gray500 = Color(PoolColor.ColorFamily.primitives, name: "gray500")
    public static let gray600 = Color(PoolColor.ColorFamily.primitives, name: "gray600")
    public static let gray700 = Color(PoolColor.ColorFamily.primitives, name: "gray700")
    public static let gray800 = Color(PoolColor.ColorFamily.primitives, name: "gray800")
    public static let gray900 = Color(PoolColor.ColorFamily.primitives, name: "gray900")
    public static let lime100 = Color(PoolColor.ColorFamily.primitives, name: "lime100")
    public static let lime200 = Color(PoolColor.ColorFamily.primitives, name: "lime200")
    public static let lime300 = Color(PoolColor.ColorFamily.primitives, name: "lime300")
    public static let lime400 = Color(PoolColor.ColorFamily.primitives, name: "lime400")
    public static let lime50 = Color(PoolColor.ColorFamily.primitives, name: "lime50")
    public static let lime500 = Color(PoolColor.ColorFamily.primitives, name: "lime500")
    public static let lime600 = Color(PoolColor.ColorFamily.primitives, name: "lime600")
    public static let lime700 = Color(PoolColor.ColorFamily.primitives, name: "lime700")
    public static let lime800 = Color(PoolColor.ColorFamily.primitives, name: "lime800")
    public static let lime900 = Color(PoolColor.ColorFamily.primitives, name: "lime900")
    public static let magenta100 = Color(PoolColor.ColorFamily.primitives, name: "magenta100")
    public static let magenta200 = Color(PoolColor.ColorFamily.primitives, name: "magenta200")
    public static let magenta300 = Color(PoolColor.ColorFamily.primitives, name: "magenta300")
    public static let magenta400 = Color(PoolColor.ColorFamily.primitives, name: "magenta400")
    public static let magenta50 = Color(PoolColor.ColorFamily.primitives, name: "magenta50")
    public static let magenta500 = Color(PoolColor.ColorFamily.primitives, name: "magenta500")
    public static let magenta600 = Color(PoolColor.ColorFamily.primitives, name: "magenta600")
    public static let magenta700 = Color(PoolColor.ColorFamily.primitives, name: "magenta700")
    public static let magenta800 = Color(PoolColor.ColorFamily.primitives, name: "magenta800")
    public static let magenta900 = Color(PoolColor.ColorFamily.primitives, name: "magenta900")
    public static let orange100 = Color(PoolColor.ColorFamily.primitives, name: "orange100")
    public static let orange200 = Color(PoolColor.ColorFamily.primitives, name: "orange200")
    public static let orange300 = Color(PoolColor.ColorFamily.primitives, name: "orange300")
    public static let orange400 = Color(PoolColor.ColorFamily.primitives, name: "orange400")
    public static let orange50 = Color(PoolColor.ColorFamily.primitives, name: "orange50")
    public static let orange500 = Color(PoolColor.ColorFamily.primitives, name: "orange500")
    public static let orange600 = Color(PoolColor.ColorFamily.primitives, name: "orange600")
    public static let orange700 = Color(PoolColor.ColorFamily.primitives, name: "orange700")
    public static let orange800 = Color(PoolColor.ColorFamily.primitives, name: "orange800")
    public static let orange900 = Color(PoolColor.ColorFamily.primitives, name: "orange900")
    public static let purple100 = Color(PoolColor.ColorFamily.primitives, name: "purple100")
    public static let purple200 = Color(PoolColor.ColorFamily.primitives, name: "purple200")
    public static let purple300 = Color(PoolColor.ColorFamily.primitives, name: "purple300")
    public static let purple400 = Color(PoolColor.ColorFamily.primitives, name: "purple400")
    public static let purple50 = Color(PoolColor.ColorFamily.primitives, name: "purple50")
    public static let purple500 = Color(PoolColor.ColorFamily.primitives, name: "purple500")
    public static let purple600 = Color(PoolColor.ColorFamily.primitives, name: "purple600")
    public static let purple700 = Color(PoolColor.ColorFamily.primitives, name: "purple700")
    public static let purple800 = Color(PoolColor.ColorFamily.primitives, name: "purple800")
    public static let purple900 = Color(PoolColor.ColorFamily.primitives, name: "purple900")
    public static let red100 = Color(PoolColor.ColorFamily.primitives, name: "red100")
    public static let red200 = Color(PoolColor.ColorFamily.primitives, name: "red200")
    public static let red300 = Color(PoolColor.ColorFamily.primitives, name: "red300")
    public static let red400 = Color(PoolColor.ColorFamily.primitives, name: "red400")
    public static let red50 = Color(PoolColor.ColorFamily.primitives, name: "red50")
    public static let red500 = Color(PoolColor.ColorFamily.primitives, name: "red500")
    public static let red600 = Color(PoolColor.ColorFamily.primitives, name: "red600")
    public static let red700 = Color(PoolColor.ColorFamily.primitives, name: "red700")
    public static let red800 = Color(PoolColor.ColorFamily.primitives, name: "red800")
    public static let red900 = Color(PoolColor.ColorFamily.primitives, name: "red900")
    public static let teal100 = Color(PoolColor.ColorFamily.primitives, name: "teal100")
    public static let teal200 = Color(PoolColor.ColorFamily.primitives, name: "teal200")
    public static let teal300 = Color(PoolColor.ColorFamily.primitives, name: "teal300")
    public static let teal400 = Color(PoolColor.ColorFamily.primitives, name: "teal400")
    public static let teal50 = Color(PoolColor.ColorFamily.primitives, name: "teal50")
    public static let teal500 = Color(PoolColor.ColorFamily.primitives, name: "teal500")
    public static let teal600 = Color(PoolColor.ColorFamily.primitives, name: "teal600")
    public static let teal700 = Color(PoolColor.ColorFamily.primitives, name: "teal700")
    public static let teal800 = Color(PoolColor.ColorFamily.primitives, name: "teal800")
    public static let teal900 = Color(PoolColor.ColorFamily.primitives, name: "teal900")
    public static let white = Color(PoolColor.ColorFamily.primitives, name: "white")
    public static let yellow100 = Color(PoolColor.ColorFamily.primitives, name: "yellow100")
    public static let yellow200 = Color(PoolColor.ColorFamily.primitives, name: "yellow200")
    public static let yellow300 = Color(PoolColor.ColorFamily.primitives, name: "yellow300")
    public static let yellow400 = Color(PoolColor.ColorFamily.primitives, name: "yellow400")
    public static let yellow50 = Color(PoolColor.ColorFamily.primitives, name: "yellow50")
    public static let yellow500 = Color(PoolColor.ColorFamily.primitives, name: "yellow500")
    public static let yellow600 = Color(PoolColor.ColorFamily.primitives, name: "yellow600")
    public static let yellow700 = Color(PoolColor.ColorFamily.primitives, name: "yellow700")
    public static let yellow800 = Color(PoolColor.ColorFamily.primitives, name: "yellow800")
    public static let yellow900 = Color(PoolColor.ColorFamily.primitives, name: "yellow900")
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
      public static let backgroundInversePrimary = Color(
        PoolColor.ColorFamily.semantic,
        name: "Background/backgroundInversePrimary"
      )
      public static let backgroundInverseSecondary = Color(
        PoolColor.ColorFamily.semantic,
        name: "Background/backgroundInverseSecondary"
      )
      public static let backgroundPrimary = Color(PoolColor.ColorFamily.semantic, name: "Background/backgroundPrimary")
      public static let backgroundSecondary = Color(
        PoolColor.ColorFamily.semantic,
        name: "Background/backgroundSecondary"
      )
      public static let backgroundTertiary = Color(
        PoolColor.ColorFamily.semantic,
        name: "Background/backgroundTertiary"
      )
    }

    public enum Border {
      public static let borderInverseOpaque = Color(PoolColor.ColorFamily.semantic, name: "Border/borderInverseOpaque")
      public static let borderInverseSelected = Color(
        PoolColor.ColorFamily.semantic,
        name: "Border/borderInverseSelected"
      )
      public static let borderInverseTransparent = Color(
        PoolColor.ColorFamily.semantic,
        name: "Border/borderInverseTransparent"
      )
      public static let borderOpaque = Color(PoolColor.ColorFamily.semantic, name: "Border/borderOpaque")
      public static let borderSelected = Color(PoolColor.ColorFamily.semantic, name: "Border/borderSelected")
      public static let borderTransparent = Color(PoolColor.ColorFamily.semantic, name: "Border/borderTransparent")
    }

    public enum Content {
      public static let contentInversePrimary = Color(
        PoolColor.ColorFamily.semantic,
        name: "Content/contentInversePrimary"
      )
      public static let contentInverseSecondary = Color(
        PoolColor.ColorFamily.semantic,
        name: "Content/contentInverseSecondary"
      )
      public static let contentInverseTertiary = Color(
        PoolColor.ColorFamily.semantic,
        name: "Content/contentInverseTertiary"
      )
      public static let contentPrimary = Color(PoolColor.ColorFamily.semantic, name: "Content/contentPrimary")
      public static let contentSecondary = Color(PoolColor.ColorFamily.semantic, name: "Content/contentSecondary")
      public static let contentTertiary = Color(PoolColor.ColorFamily.semantic, name: "Content/contentTertiary")
    }
  }

  public enum SemanticExtensions {
    public enum Background {
      public static let backgroundAccent = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundAccent"
      )
      public static let backgroundAlwaysDark = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundAlwaysDark"
      )
      public static let backgroundAlwaysLight = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundAlwaysLight"
      )
      public static let backgroundLightAccent = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundLightAccent"
      )
      public static let backgroundLightNegative = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundLightNegative"
      )
      public static let backgroundLightPositive = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundLightPositive"
      )
      public static let backgroundLightWarning = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundLightWarning"
      )
      public static let backgroundNegative = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundNegative"
      )
      public static let backgroundOverlayArt = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundOverlayArt"
      )
      public static let backgroundOverlayDark = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundOverlayDark"
      )
      public static let backgroundOverlayElevation = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundOverlayElevation"
      )
      public static let backgroundPositive = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundPositive"
      )
      public static let backgroundStateDisabled = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundStateDisabled"
      )
      public static let backgroundWarning = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Background/backgroundWarning"
      )
    }

    public enum Border {
      public static let borderAccent = Color(PoolColor.ColorFamily.semanticExtensions, name: "Border/borderAccent")
      public static let borderAccentLight = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Border/borderAccentLight"
      )
      public static let borderNegative = Color(PoolColor.ColorFamily.semanticExtensions, name: "Border/borderNegative")
      public static let borderPositive = Color(PoolColor.ColorFamily.semanticExtensions, name: "Border/borderPositive")
      public static let borderStateDisabled = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Border/borderStateDisabled"
      )
      public static let borderWarning = Color(PoolColor.ColorFamily.semanticExtensions, name: "Border/borderWarning")
    }

    public enum Content {
      public static let contentAccent = Color(PoolColor.ColorFamily.semanticExtensions, name: "Content/contentAccent")
      public static let contentNegative = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Content/contentNegative"
      )
      public static let contentOnColor = Color(PoolColor.ColorFamily.semanticExtensions, name: "Content/contentOnColor")
      public static let contentOnColorInverse = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Content/contentOnColorInverse"
      )
      public static let contentPositive = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Content/contentPositive"
      )
      public static let contentStateDisabled = Color(
        PoolColor.ColorFamily.semanticExtensions,
        name: "Content/contentStateDisabled"
      )
      public static let contentWarning = Color(PoolColor.ColorFamily.semanticExtensions, name: "Content/contentWarning")
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
  static let primitives = PoolColor.Primitives.self
  static let core = PoolColor.Core.self
  static let semantic = PoolColor.Semantic.self
  static let semanticExtensions = PoolColor.SemanticExtensions.self
  static let calendar = PoolColor.Calendar.self
  static let poolCalendar = PoolColor.Calendar.self
}
