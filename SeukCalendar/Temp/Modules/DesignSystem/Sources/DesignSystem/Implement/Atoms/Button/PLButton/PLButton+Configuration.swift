//
//  PLButton+Extension.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 9/21/25.
//

import SwiftUI

public extension PLButton {
  enum ContentType {
    public enum IconPosition {
      case leading
      case trailing
    }

    case textOnly(text: String)
    case iconOnly(icon: Image)
    case fullContents(text: String, icon: Image, iconPos: IconPosition) // 추후 icon은 커스텀 타입으로 교체할 수 있음
  }

  enum Size {
    case small
    case medium
    case large
    case expand

    var vPadding: CGFloat {
      switch self {
      case .small:
        return Spacing.sp150
      case .medium:
        return Spacing.sp200
      case .large, .expand:
        return Spacing.sp350
      }
    }

    var hPaading: CGFloat {
      switch self {
      case .small:
        return Spacing.sp300
      case .medium:
        return Spacing.sp500
      case .large, .expand:
        return Spacing.sp800
      }
    }

    /// 아이콘과 text 간격
    var gap: CGFloat {
      switch self {
      case .small:
        return Spacing.sp050
      case .medium:
        return Spacing.sp100
      case .large, .expand:
        return Spacing.sp150
      }
    }

    var cornerRadius: CGFloat {
      switch self {
      case .small, .medium:
        return Radius.rds200
      case .large, .expand:
        return Radius.rds400
      }
    }

    var font: any FontStyleType {
      switch self {
      case .small:
        return Label3.semibold
      case .medium:
        return Label2.bold
      case .large, .expand:
        return Label1.bold
      }
    }
  }

  struct Configuration {
    let contentType: ContentType
    let size: Size

    public init(
      contentType: ContentType,
      size: Size
    ) {
      self.contentType = contentType
      self.size = size
    }
  }
}
