import SwiftUI

// MARK: - Display

public enum Display: FontStyleType {
  public typealias Family = Pretendard

  case large, medium, small, xSmall

  public var weight: Pretendard.Weight { .bold }

  public var size: CGFloat {
    switch self {
    case .large: 96
    case .medium: 52
    case .small: 44
    case .xSmall: 36
    }
  }

  public var lineHeight: CGFloat {
    switch self {
    case .large: 112
    case .medium: 64
    case .small: 52
    case .xSmall: 44
    }
  }

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Heading

public enum Heading: FontStyleType {
  public typealias Family = Pretendard

  case xxLarge, xLarge, large, medium, small, xSmall

  public var weight: Pretendard.Weight { .bold }

  public var size: CGFloat {
    switch self {
    case .xxLarge: 40
    case .xLarge: 36
    case .large: 32
    case .medium: 28
    case .small: 24
    case .xSmall: 20
    }
  }

  public var lineHeight: CGFloat {
    switch self {
    case .xxLarge: 52
    case .xLarge: 44
    case .large: 40
    case .medium: 36
    case .small: 32
    case .xSmall: 28
    }
  }

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Label

public enum Label: FontStyleType {
  public typealias Family = Pretendard

  case large, medium, small, xSmall, xxSmall

  public var weight: Pretendard.Weight { .medium }

  public var size: CGFloat {
    switch self {
    case .large: 18
    case .medium: 16
    case .small: 14
    case .xSmall: 12
    case .xxSmall: 8
    }
  }

  public var lineHeight: CGFloat {
    switch self {
    case .large: 24
    case .medium: 20
    case .small: 16
    case .xSmall: 16
    case .xxSmall: uiFont.lineHeight
    }
  }

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Paragraph

public enum Paragraph: FontStyleType {
  public typealias Family = Pretendard

  case large, medium, small, xSmall

  public var weight: Pretendard.Weight { .regular }

  public var size: CGFloat {
    switch self {
    case .large: 18
    case .medium: 16
    case .small: 14
    case .xSmall: 12
    }
  }

  public var lineHeight: CGFloat {
    switch self {
    case .large: 28
    case .medium: 24
    case .small: 20
    case .xSmall: 20
    }
  }

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Widget

public enum Widget {
  public enum Large: FontStyleType {
    public typealias Family = Pretendard

    case small, medium, large, xLarge

    public var weight: Pretendard.Weight {
      switch self {
      case .small, .medium:
        .medium
      case .large:
        .bold
      case .xLarge:
        .extraBold
      }
    }

    public var size: CGFloat {
      switch self {
      case .small:
        8
      case .medium, .large:
        10
      case .xLarge:
        12
      }
    }

    public var lineHeight: CGFloat {
      switch self {
      case .small:
        10
      case .medium, .large:
        12
      case .xLarge:
        16
      }
    }

    public var letterSpacingRatio: CGFloat { -0.75 }
  }
}
