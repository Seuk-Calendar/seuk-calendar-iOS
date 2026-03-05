import SwiftUI

public enum PoolColor {
  public enum ColorFamily: String, CaseIterable {
    case primitives = "Primitives"
    case core = "Core"
    case semanticExtensions = "SemanticExtensions"
  }

  public enum Primitives {
    public static let amber50 = Color(PoolColor.ColorFamily.primitives, name: "amber50")
    public static let amber100 = Color(PoolColor.ColorFamily.primitives, name: "amber100")
    public static let amber200 = Color(PoolColor.ColorFamily.primitives, name: "amber200")
    public static let amber300 = Color(PoolColor.ColorFamily.primitives, name: "amber300")
    public static let amber400 = Color(PoolColor.ColorFamily.primitives, name: "amber400")
    public static let amber500 = Color(PoolColor.ColorFamily.primitives, name: "amber500")
    public static let amber600 = Color(PoolColor.ColorFamily.primitives, name: "amber600")
    public static let amber700 = Color(PoolColor.ColorFamily.primitives, name: "amber700")
    public static let amber800 = Color(PoolColor.ColorFamily.primitives, name: "amber800")
    public static let amber900 = Color(PoolColor.ColorFamily.primitives, name: "amber900")
    public static let blue50 = Color(PoolColor.ColorFamily.primitives, name: "blue50")
    public static let blue100 = Color(PoolColor.ColorFamily.primitives, name: "blue100")
    public static let blue200 = Color(PoolColor.ColorFamily.primitives, name: "blue200")
    public static let blue300 = Color(PoolColor.ColorFamily.primitives, name: "blue300")
    public static let blue400 = Color(PoolColor.ColorFamily.primitives, name: "blue400")
    public static let blue500 = Color(PoolColor.ColorFamily.primitives, name: "blue500")
    public static let blue600 = Color(PoolColor.ColorFamily.primitives, name: "blue600")
    public static let blue700 = Color(PoolColor.ColorFamily.primitives, name: "blue700")
    public static let blue800 = Color(PoolColor.ColorFamily.primitives, name: "blue800")
    public static let blue900 = Color(PoolColor.ColorFamily.primitives, name: "blue900")
    public static let green50 = Color(PoolColor.ColorFamily.primitives, name: "green50")
    public static let green100 = Color(PoolColor.ColorFamily.primitives, name: "green100")
    public static let green200 = Color(PoolColor.ColorFamily.primitives, name: "green200")
    public static let green300 = Color(PoolColor.ColorFamily.primitives, name: "green300")
    public static let green400 = Color(PoolColor.ColorFamily.primitives, name: "green400")
    public static let green500 = Color(PoolColor.ColorFamily.primitives, name: "green500")
    public static let green600 = Color(PoolColor.ColorFamily.primitives, name: "green600")
    public static let green700 = Color(PoolColor.ColorFamily.primitives, name: "green700")
    public static let green800 = Color(PoolColor.ColorFamily.primitives, name: "green800")
    public static let green900 = Color(PoolColor.ColorFamily.primitives, name: "green900")
    public static let grey50 = Color(PoolColor.ColorFamily.primitives, name: "grey50")
    public static let grey100 = Color(PoolColor.ColorFamily.primitives, name: "grey100")
    public static let grey200 = Color(PoolColor.ColorFamily.primitives, name: "grey200")
    public static let grey300 = Color(PoolColor.ColorFamily.primitives, name: "grey300")
    public static let grey400 = Color(PoolColor.ColorFamily.primitives, name: "grey400")
    public static let grey500 = Color(PoolColor.ColorFamily.primitives, name: "grey500")
    public static let grey600 = Color(PoolColor.ColorFamily.primitives, name: "grey600")
    public static let grey700 = Color(PoolColor.ColorFamily.primitives, name: "grey700")
    public static let grey800 = Color(PoolColor.ColorFamily.primitives, name: "grey800")
    public static let grey900 = Color(PoolColor.ColorFamily.primitives, name: "grey900")
    public static let lime50 = Color(PoolColor.ColorFamily.primitives, name: "lime50")
    public static let lime100 = Color(PoolColor.ColorFamily.primitives, name: "lime100")
    public static let lime200 = Color(PoolColor.ColorFamily.primitives, name: "lime200")
    public static let lime300 = Color(PoolColor.ColorFamily.primitives, name: "lime300")
    public static let lime400 = Color(PoolColor.ColorFamily.primitives, name: "lime400")
    public static let lime500 = Color(PoolColor.ColorFamily.primitives, name: "lime500")
    public static let lime600 = Color(PoolColor.ColorFamily.primitives, name: "lime600")
    public static let lime700 = Color(PoolColor.ColorFamily.primitives, name: "lime700")
    public static let lime800 = Color(PoolColor.ColorFamily.primitives, name: "lime800")
    public static let lime900 = Color(PoolColor.ColorFamily.primitives, name: "lime900")
    public static let magenta50 = Color(PoolColor.ColorFamily.primitives, name: "magenta50")
    public static let magenta100 = Color(PoolColor.ColorFamily.primitives, name: "magenta100")
    public static let magenta200 = Color(PoolColor.ColorFamily.primitives, name: "magenta200")
    public static let magenta300 = Color(PoolColor.ColorFamily.primitives, name: "magenta300")
    public static let magenta400 = Color(PoolColor.ColorFamily.primitives, name: "magenta400")
    public static let magenta500 = Color(PoolColor.ColorFamily.primitives, name: "magenta500")
    public static let magenta600 = Color(PoolColor.ColorFamily.primitives, name: "magenta600")
    public static let magenta700 = Color(PoolColor.ColorFamily.primitives, name: "magenta700")
    public static let magenta800 = Color(PoolColor.ColorFamily.primitives, name: "magenta800")
    public static let magenta900 = Color(PoolColor.ColorFamily.primitives, name: "magenta900")
    public static let orange50 = Color(PoolColor.ColorFamily.primitives, name: "orange50")
    public static let orange100 = Color(PoolColor.ColorFamily.primitives, name: "orange100")
    public static let orange200 = Color(PoolColor.ColorFamily.primitives, name: "orange200")
    public static let orange300 = Color(PoolColor.ColorFamily.primitives, name: "orange300")
    public static let orange400 = Color(PoolColor.ColorFamily.primitives, name: "orange400")
    public static let orange500 = Color(PoolColor.ColorFamily.primitives, name: "orange500")
    public static let orange600 = Color(PoolColor.ColorFamily.primitives, name: "orange600")
    public static let orange700 = Color(PoolColor.ColorFamily.primitives, name: "orange700")
    public static let orange800 = Color(PoolColor.ColorFamily.primitives, name: "orange800")
    public static let orange900 = Color(PoolColor.ColorFamily.primitives, name: "orange900")
    public static let purple50 = Color(PoolColor.ColorFamily.primitives, name: "purple50")
    public static let purple100 = Color(PoolColor.ColorFamily.primitives, name: "purple100")
    public static let purple200 = Color(PoolColor.ColorFamily.primitives, name: "purple200")
    public static let purple300 = Color(PoolColor.ColorFamily.primitives, name: "purple300")
    public static let purple400 = Color(PoolColor.ColorFamily.primitives, name: "purple400")
    public static let purple500 = Color(PoolColor.ColorFamily.primitives, name: "purple500")
    public static let purple600 = Color(PoolColor.ColorFamily.primitives, name: "purple600")
    public static let purple700 = Color(PoolColor.ColorFamily.primitives, name: "purple700")
    public static let purple800 = Color(PoolColor.ColorFamily.primitives, name: "purple800")
    public static let purple900 = Color(PoolColor.ColorFamily.primitives, name: "purple900")
    public static let red50 = Color(PoolColor.ColorFamily.primitives, name: "red50")
    public static let red100 = Color(PoolColor.ColorFamily.primitives, name: "red100")
    public static let red200 = Color(PoolColor.ColorFamily.primitives, name: "red200")
    public static let red300 = Color(PoolColor.ColorFamily.primitives, name: "red300")
    public static let red400 = Color(PoolColor.ColorFamily.primitives, name: "red400")
    public static let red500 = Color(PoolColor.ColorFamily.primitives, name: "red500")
    public static let red600 = Color(PoolColor.ColorFamily.primitives, name: "red600")
    public static let red700 = Color(PoolColor.ColorFamily.primitives, name: "red700")
    public static let red800 = Color(PoolColor.ColorFamily.primitives, name: "red800")
    public static let red900 = Color(PoolColor.ColorFamily.primitives, name: "red900")
    public static let teal50 = Color(PoolColor.ColorFamily.primitives, name: "teal50")
    public static let teal100 = Color(PoolColor.ColorFamily.primitives, name: "teal100")
    public static let teal200 = Color(PoolColor.ColorFamily.primitives, name: "teal200")
    public static let teal300 = Color(PoolColor.ColorFamily.primitives, name: "teal300")
    public static let teal400 = Color(PoolColor.ColorFamily.primitives, name: "teal400")
    public static let teal500 = Color(PoolColor.ColorFamily.primitives, name: "teal500")
    public static let teal600 = Color(PoolColor.ColorFamily.primitives, name: "teal600")
    public static let teal700 = Color(PoolColor.ColorFamily.primitives, name: "teal700")
    public static let teal800 = Color(PoolColor.ColorFamily.primitives, name: "teal800")
    public static let teal900 = Color(PoolColor.ColorFamily.primitives, name: "teal900")
    public static let yellow50 = Color(PoolColor.ColorFamily.primitives, name: "yellow50")
    public static let yellow100 = Color(PoolColor.ColorFamily.primitives, name: "yellow100")
    public static let yellow200 = Color(PoolColor.ColorFamily.primitives, name: "yellow200")
    public static let yellow300 = Color(PoolColor.ColorFamily.primitives, name: "yellow300")
    public static let yellow400 = Color(PoolColor.ColorFamily.primitives, name: "yellow400")
    public static let yellow500 = Color(PoolColor.ColorFamily.primitives, name: "yellow500")
    public static let yellow600 = Color(PoolColor.ColorFamily.primitives, name: "yellow600")
    public static let yellow700 = Color(PoolColor.ColorFamily.primitives, name: "yellow700")
    public static let yellow800 = Color(PoolColor.ColorFamily.primitives, name: "yellow800")
    public static let yellow900 = Color(PoolColor.ColorFamily.primitives, name: "yellow900")
    public static let black = Color(PoolColor.ColorFamily.primitives, name: "black")
    public static let white = Color(PoolColor.ColorFamily.primitives, name: "white")
  }

  public enum Core {
    public static let primaryA = Color(PoolColor.ColorFamily.core, name: "primaryA")
    public static let primaryB = Color(PoolColor.ColorFamily.core, name: "primaryB")
    public static let accent = Color(PoolColor.ColorFamily.core, name: "accent")
    public static let negative = Color(PoolColor.ColorFamily.core, name: "negative")
    public static let warning = Color(PoolColor.ColorFamily.core, name: "warning")
    public static let positive = Color(PoolColor.ColorFamily.core, name: "positive")
    public static let backgroundPrimary = Color(PoolColor.ColorFamily.core, name: "backgroundPrimary")
    public static let backgroundSecondary = Color(PoolColor.ColorFamily.core, name: "backgroundSecondary")
    public static let backgroundTertiary = Color(PoolColor.ColorFamily.core, name: "backgroundTertiary")
    public static let backgroundInversePrimary = Color(PoolColor.ColorFamily.core, name: "backgroundInversePrimary")
    public static let backgroundInverseSecondary = Color(PoolColor.ColorFamily.core, name: "backgroundInverseSecondary")
    public static let contentPrimary = Color(PoolColor.ColorFamily.core, name: "contentPrimary")
    public static let contentSecondary = Color(PoolColor.ColorFamily.core, name: "contentSecondary")
    public static let contentTertiary = Color(PoolColor.ColorFamily.core, name: "contentTertiary")
    public static let contentInversePrimary = Color(PoolColor.ColorFamily.core, name: "contentInversePrimary")
    public static let contentInverseSecondary = Color(PoolColor.ColorFamily.core, name: "contentInverseSecondary")
    public static let contentInverseTertiary = Color(PoolColor.ColorFamily.core, name: "contentInverseTertiary")
    public static let borderOpaque = Color(PoolColor.ColorFamily.core, name: "borderOpaque")
    public static let borderTransparent = Color(PoolColor.ColorFamily.core, name: "borderTransparent")
    public static let borderSelected = Color(PoolColor.ColorFamily.core, name: "borderSelected")
    public static let borderInverseOpaque = Color(PoolColor.ColorFamily.core, name: "borderInverseOpaque")
    public static let borderInverseTransparent = Color(PoolColor.ColorFamily.core, name: "borderInverseTransparent")
    public static let borderInverseSelected = Color(PoolColor.ColorFamily.core, name: "borderInverseSelected")
  }

  public enum SemanticExtensions {
    public static let backgroundStateDisabled = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundStateDisabled"
    )
    public static let backgroundOverlayArt = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundOverlayArt"
    )
    public static let backgroundOverlayDark = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundOverlayDark"
    )
    public static let DEPRECATED_backgroundOverlayLight = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "DEPRECATED_backgroundOverlayLight"
    )
    public static let backgroundOverlayElevation = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundOverlayElevation"
    )
    public static let backgroundAccent = Color(PoolColor.ColorFamily.semanticExtensions, name: "backgroundAccent")
    public static let backgroundNegative = Color(PoolColor.ColorFamily.semanticExtensions, name: "backgroundNegative")
    public static let backgroundWarning = Color(PoolColor.ColorFamily.semanticExtensions, name: "backgroundWarning")
    public static let backgroundPositive = Color(PoolColor.ColorFamily.semanticExtensions, name: "backgroundPositive")
    public static let backgroundLightAccent = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundLightAccent"
    )
    public static let backgroundLightNegative = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundLightNegative"
    )
    public static let backgroundLightWarning = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundLightWarning"
    )
    public static let backgroundLightPositive = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundLightPositive"
    )
    public static let backgroundAlwaysDark = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundAlwaysDark"
    )
    public static let backgroundAlwaysLight = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "backgroundAlwaysLight"
    )
    public static let contentStateDisabled = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "contentStateDisabled"
    )
    public static let contentOnColor = Color(PoolColor.ColorFamily.semanticExtensions, name: "contentOnColor")
    public static let contentOnColorInverse = Color(
      PoolColor.ColorFamily.semanticExtensions,
      name: "contentOnColorInverse"
    )
    public static let contentAccent = Color(PoolColor.ColorFamily.semanticExtensions, name: "contentAccent")
    public static let contentNegative = Color(PoolColor.ColorFamily.semanticExtensions, name: "contentNegative")
    public static let contentWarning = Color(PoolColor.ColorFamily.semanticExtensions, name: "contentWarning")
    public static let contentPositive = Color(PoolColor.ColorFamily.semanticExtensions, name: "contentPositive")
    public static let borderStateDisabled = Color(PoolColor.ColorFamily.semanticExtensions, name: "borderStateDisabled")
    public static let borderAccent = Color(PoolColor.ColorFamily.semanticExtensions, name: "borderAccent")
    public static let borderNegative = Color(PoolColor.ColorFamily.semanticExtensions, name: "borderNegative")
    public static let borderWarning = Color(PoolColor.ColorFamily.semanticExtensions, name: "borderWarning")
    public static let borderPositive = Color(PoolColor.ColorFamily.semanticExtensions, name: "borderPositive")
    public static let borderAccentLight = Color(PoolColor.ColorFamily.semanticExtensions, name: "borderAccentLight")
  }
}

public extension Color {
  static let primitives = PoolColor.Primitives.self
  static let core = PoolColor.Core.self
  static let semanticExtensions = PoolColor.SemanticExtensions.self
}
