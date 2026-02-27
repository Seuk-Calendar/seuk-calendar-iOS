//
//  BottomSheetPosition.swift
//  Pool
//
//  Created by YoungK on 2/7/26.
//

import Foundation

public enum BottomSheetPosition: Hashable {
  /// 시트가 숨겨진 상태
  case hidden
  /// 화면의 약 30%
  case small
  /// 화면의 약 50%
  case medium
  /// 화면의 약 90%
  case large
  /// 0.0 ~ 1.0 비율로 직접 지정
  case custom(CGFloat)

  var isHidden: Bool { self == .hidden }

  var ratio: CGFloat {
    switch self {
    case .hidden: return 0
    case .small: return 0.3
    case .medium: return 0.5
    case .large: return 0.9
    case let .custom(ratio): return min(max(ratio, 0.0), 1.0)
    }
  }

  func height(in screenHeight: CGFloat) -> CGFloat {
    screenHeight * ratio
  }
}
