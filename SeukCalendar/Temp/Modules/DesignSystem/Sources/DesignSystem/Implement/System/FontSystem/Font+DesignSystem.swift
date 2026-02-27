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
  
  public var size: CGFloat {
    switch self {
    case .bold: 32
    case .regular: 32
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.35
    case .regular: 1.35
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: -1.2
    case .regular: -1.2
    }
  }
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
  
  public var size: CGFloat {
    switch self {
    case .bold: 28
    case .regular: 28
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.35
    case .regular: 1.35
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: -1.2
    case .regular: -1.2
    }
  }
}

// MARK: - Heading3

public enum Heading3: FontStyleType {
  public typealias Family = Pretendard
  
  case bold, regular
  
  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .regular: .regular
    }
  }
  
  public var size: CGFloat {
    switch self {
    case .bold: 24
    case .regular: 24
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.35
    case .regular: 1.35
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: -1.2
    case .regular: -1.2
    }
  }
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
  
  public var size: CGFloat {
    switch self {
    case .bold: 20
    case .regular: 20
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.35
    case .regular: 1.35
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: -1.2
    case .regular: -1.2
    }
  }
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
  
  public var size: CGFloat {
    switch self {
    case .bold: 18
    case .regular: 18
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.35
    case .regular: 1.35
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: -1.2
    case .regular: -1.2
    }
  }
}

// MARK: - Body1

public enum Body1: FontStyleType {
  public typealias Family = Pretendard
  
  case regular, bold
  
  public var weight: Pretendard.Weight {
    switch self {
    case .regular: .regular
    case .bold: .bold
    }
  }
  
  public var size: CGFloat {
    switch self {
    case .regular: 16
    case .bold: 16
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .regular: 1.5
    case .bold: 1.5
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .regular: 0
    case .bold: 0
    }
  }
}

// MARK: - Body2

public enum Body2: FontStyleType {
  public typealias Family = Pretendard
  
  case bold, regular
  
  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .regular: .regular
    }
  }
  
  public var size: CGFloat {
    switch self {
    case .bold: 14
    case .regular: 14
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.4
    case .regular: 1.4
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: 0
    case .regular: 0
    }
  }
}

// MARK: - Label1

public enum Label1: FontStyleType {
  public typealias Family = Pretendard
  
  case bold, regular
  
  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .regular: .regular
    }
  }
  
  public var size: CGFloat {
    switch self {
    case .bold: 16
    case .regular: 16
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.1
    case .regular: 1.1
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: -1
    case .regular: -1
    }
  }
}

// MARK: - Label2

public enum Label2: FontStyleType {
  public typealias Family = Pretendard
  
  case bold, regular
  
  public var weight: Pretendard.Weight {
    switch self {
    case .bold: .bold
    case .regular: .regular
    }
  }
  
  public var size: CGFloat {
    switch self {
    case .bold: 14
    case .regular: 14
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .bold: 1.1
    case .regular: 1.1
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .bold: -1
    case .regular: -1
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
  
  public var size: CGFloat {
    switch self {
    case .semibold: 12
    case .regular: 12
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .semibold: 1.1
    case .regular: 1.1
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .semibold: -1
    case .regular: -1
    }
  }
}

// MARK: - Caption1

public enum Caption1: FontStyleType {
  public typealias Family = Pretendard
  
  case semibold, regular
  
  public var weight: Pretendard.Weight {
    switch self {
    case .semibold: .semiBold
    case .regular: .regular
    }
  }
  
  public var size: CGFloat {
    switch self {
    case .semibold: 12
    case .regular: 12
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .semibold: 1.3
    case .regular: 1.3
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .semibold: 0
    case .regular: 0
    }
  }
}

// MARK: - Caption2

public enum Caption2: FontStyleType {
  public typealias Family = Pretendard
  
  case semibold, regular
  
  public var weight: Pretendard.Weight {
    switch self {
    case .semibold: .semiBold
    case .regular: .regular
    }
  }
  
  public var size: CGFloat {
    switch self {
    case .semibold: 11
    case .regular: 11
    }
  }
  
  public var lineHeightRatio: CGFloat {
    switch self {
    case .semibold: 1.3
    case .regular: 1.3
    }
  }
  
  public var letterSpacingRatio: CGFloat {
    switch self {
    case .semibold: 0
    case .regular: 0
    }
  }
}