//
//  ContextPopupBuilder.swift
//  DesignSystem
//
//  Created by YoungK on 11/6/25.
//

import SwiftUI

@resultBuilder
public struct ContextPopupBuilder {
  public static func buildBlock(_ components: AnyView...) -> [AnyView] {
    var result: [AnyView] = []
    for (index, component) in components.enumerated() {
      // component들 사이에 구분선 추가
      if index > 0 { result.append(makeDivider()) }
      result.append(component)
    }
    return result
  }

  public static func buildExpression<V: View>(_ expression: V) -> AnyView {
    AnyView(expression)
  }
}

private extension ContextPopupBuilder {
  enum Constants {
    static let dividerColor: Color = Color.separators.opaque
    static let dividerHeight: CGFloat = 1
    static let dividerHPadding: CGFloat = 16
  }

  static func makeDivider() -> AnyView {
    AnyView(
      Divider()
        .foregroundStyle(Constants.dividerColor)
        .frame(height: Constants.dividerHeight)
        .padding(.horizontal, Constants.dividerHPadding)
    )
  }
}
