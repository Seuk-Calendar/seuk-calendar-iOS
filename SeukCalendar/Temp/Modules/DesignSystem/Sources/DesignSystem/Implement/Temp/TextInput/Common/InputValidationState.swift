//
//  InputValidationState.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2/5/26.
//

import SwiftUI

public enum InputValidationState: Equatable {
  /// 기본적으로 보여야할 때
  case normal(String)
  /// condition이 false일 때,
  case invalid(String)
  /// condition이 true일 때,
  case valid(String)

  var color: Color {
    switch self {
    case .normal:
      .labels.secondary
    case .invalid:
      .colors.red
    case .valid:
      .clear
    }
  }

  public static func ==(lhs: InputValidationState, rhs: InputValidationState) -> Bool {
    switch (lhs, rhs) {
    case (.normal(let lhsText), .normal(let rhsText)):
      return lhsText == rhsText
    case (.invalid(let lhsText), .invalid(let rhsText)):
      return lhsText == rhsText
    case (.valid(let lhsText), .valid(let rhsText)):
      return lhsText == rhsText
    default:
      return false
    }
  }
}
