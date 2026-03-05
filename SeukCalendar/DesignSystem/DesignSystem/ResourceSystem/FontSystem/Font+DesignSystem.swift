import SwiftUI

// MARK: - Heading1

public enum Heading1: FontStyleType {
  public typealias Family = Pretendard

  case bold, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .regular: .regular
    }
  }

  public var size: CGFloat { 32 }

  public var lineHeightRatio: CGFloat { 1.25 } // 40 / 32

  public var letterSpacingRatio: CGFloat { -1.5625 } // -0.5 / 32 * 100
}

// MARK: - Heading2

public enum Heading2: FontStyleType {
  public typealias Family = Pretendard

  case bold, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .regular: .regular
    }
  }

  public var size: CGFloat { 24 }

  public var lineHeightRatio: CGFloat { 1.3333333333333333 } // 32 / 24

  public var letterSpacingRatio: CGFloat { -1.25 } // -0.3 / 24 * 100
}

// MARK: - Heading3

public enum Heading3: FontStyleType {
  public typealias Family = Pretendard

  case bold, semibold, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .semibold: .semiBold
    case .regular: .regular
    }
  }

  public var size: CGFloat { 20 }

  public var lineHeightRatio: CGFloat { 1.4 } // 28 / 20

  public var letterSpacingRatio: CGFloat { -1 } // -0.2 / 20 * 100
}

// MARK: - Heading4

public enum Heading4: FontStyleType {
  public typealias Family = Pretendard

  case bold, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .regular: .regular
    }
  }

  public var size: CGFloat { 18 }

  public var lineHeightRatio: CGFloat { 1.3333333333333333 } // 24 / 18

  public var letterSpacingRatio: CGFloat { -1 }
}

// MARK: - Heading5

public enum Heading5: FontStyleType {
  public typealias Family = Pretendard

  case bold, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .regular: .regular
    }
  }

  public var size: CGFloat { 16 }

  public var lineHeightRatio: CGFloat { 1.5 } // 24 / 16

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Body1

public enum Body1: FontStyleType {
  public typealias Family = Pretendard

  case regular, medium, bold

  public var weight: Pretendard.Weight {
    switch self {
    case .regular: .regular
    case .medium: .medium
    case .bold: .bold
    }
  }

  public var size: CGFloat { 16 }

  public var lineHeightRatio: CGFloat { 1.5 } // 24 / 16

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Body2

public enum Body2: FontStyleType {
  public typealias Family = Pretendard

  case regular, medium, bold

  public var weight: Pretendard.Weight {
    switch self {
    case .regular: .regular
    case .medium: .medium
    case .bold: .bold
    }
  }

  public var size: CGFloat { 14 }

  public var lineHeightRatio: CGFloat { 1.4285714285714286 } // 20 / 14

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Label1

public enum Label1: FontStyleType {
  public typealias Family = Pretendard

  case bold, medium, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .medium: .medium
    case .regular: .regular
    }
  }

  public var size: CGFloat { 16 }

  public var lineHeightRatio: CGFloat { 1.5 } // 24 / 16

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Label2

public enum Label2: FontStyleType {
  public typealias Family = Pretendard

  case bold, medium, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .medium: .medium
    case .regular: .regular
    }
  }

  public var size: CGFloat { 14 }

  public var lineHeightRatio: CGFloat { 1.4285714285714286 } // 20 / 14

  public var letterSpacingRatio: CGFloat {
    switch self {
    case .medium: 2.142857142857143 // +0.3 / 14 * 100
    case .bold, .regular: 0
    }
  }
}

// MARK: - Label3

public enum Label3: FontStyleType {
  public typealias Family = Pretendard

  case semibold, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .semibold: .semiBold
    case .regular: .regular
    }
  }

  public var size: CGFloat { 12 }

  public var lineHeightRatio: CGFloat { 1.3333333333333333 } // 16 / 12

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Caption1

public enum Caption1: FontStyleType {
  public typealias Family = Pretendard

  case medium, semibold, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .medium: .medium
    case .semibold: .semiBold
    case .regular: .regular
    }
  }

  public var size: CGFloat { 12 }

  public var lineHeightRatio: CGFloat { 1.3333333333333333 } // 16 / 12

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Caption2

public enum Caption2: FontStyleType {
  public typealias Family = Pretendard

  case medium, semibold, regular

  public var weight: Pretendard.Weight {
    switch self {
    case .medium: .medium
    case .semibold: .semiBold
    case .regular: .regular
    }
  }

  public var size: CGFloat { 10 }

  public var lineHeightRatio: CGFloat { 1.4 } // 14 / 10

  public var letterSpacingRatio: CGFloat { 0 }
}

// MARK: - Numeric

public enum Numeric: FontStyleType {
  public typealias Family = Pretendard

  case bold, medium

  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .medium: .medium
    }
  }

  public var size: CGFloat {
    switch self {
    case .bold: 28
    case .medium: 16
    }
  }

  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.2857142857142858 // 36 / 28
    case .medium: 1.5 // 24 / 16
    }
  }

  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: -1.7857142857142858 // -0.5 / 28 * 100
    case .medium: 0
    }
  }
}
