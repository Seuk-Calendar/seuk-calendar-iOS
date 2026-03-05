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

  public var lineHeightRatio: CGFloat {
    switch self {
    case .large: 1.17
    case .medium: 1.23
    case .small: 1.18
    case .xSmall: 1.22
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

  public var lineHeightRatio: CGFloat {
    switch self {
    case .xxLarge: 1.30
    case .xLarge: 1.22
    case .large: 1.25
    case .medium: 1.29
    case .small: 1.33
    case .xSmall: 1.40
    }
  }

  public var letterSpacingRatio: CGFloat {
    switch self {
    case .xSmall: 1.25 // +0.25 / 20 * 100
    case .xxLarge, .xLarge, .large, .medium, .small: 0
    }
  }
}

// MARK: - Label

public enum Label: FontStyleType {
  public typealias Family = Pretendard

  case large, medium, small, xSmall

  public var weight: Pretendard.Weight { .medium }

  public var size: CGFloat {
    switch self {
    case .large: 18
    case .medium: 16
    case .small: 14
    case .xSmall: 12
    }
  }

  public var lineHeightRatio: CGFloat {
    switch self {
    case .large: 1.33
    case .medium: 1.25
    case .small: 1.14
    case .xSmall: 1.33
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

  public var lineHeightRatio: CGFloat {
    switch self {
    case .large: 1.56
    case .medium: 1.50
    case .small: 1.43
    case .xSmall: 1.67
    }
  }

  public var letterSpacingRatio: CGFloat { 0 }
}
