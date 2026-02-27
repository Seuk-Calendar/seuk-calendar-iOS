//
//  BottomSheetWidth.swift
//  Pool
//
//  Created by YoungK on 2/7/26.
//

import Foundation

public enum BottomSheetWidth: Equatable {
  /// 플랫폼 기본값 (iPhone 세로: 100%, 가로: 40%, iPad: 30%)
  case platformDefault
  /// 사용 가능한 너비 대비 비율 (0.0 ~ 1.0)
  case relative(CGFloat)
  /// 고정 픽셀 너비
  case absolute(CGFloat)

  func width(
    in availableWidth: CGFloat,
    isIPad: Bool,
    isLandscape: Bool
  ) -> CGFloat {
    switch self {
    case .platformDefault:
      if isIPad {
        return availableWidth * 0.3
      } else if isLandscape {
        return availableWidth * 0.4
      } else {
        return availableWidth
      }
    case .relative(let ratio):
      return availableWidth * min(max(ratio, 0), 1)
    case .absolute(let width):
      return max(0, width)
    }
  }
}
