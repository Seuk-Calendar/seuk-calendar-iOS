//
//  AnyViewArrayBuilder.swift
//  Pool
//
//  Created by YoungK on 2/27/26.
//

import SwiftUI

@resultBuilder
public struct AnyViewArrayBuilder {
  public static func buildBlock(_ components: AnyView...) -> [AnyView] {
    components
  }

  public static func buildExpression<V: View>(_ expression: V) -> AnyView {
    AnyView(expression)
  }
}
