//
//  PLTagButtonStyle.swift
//  DesignSystem
//
//  Created by YoungK on 11/3/25.
//

import SwiftUI

struct PLTagButtonStyle: ButtonStyle {
  let configuration: PLTag.Configuration
  @Binding var isPressed: Bool

  func makeBody(configuration state: ButtonStyleConfiguration) -> some View {
    isPressed = state.isPressed

    return state.label
      .foregroundStyle(state.isPressed
        ? configuration.selectedColors.foregroundColor
        : configuration.normalColors.foregroundColor
      )
      .background(state.isPressed
        ? configuration.selectedColors.backgroundColor
        : configuration.normalColors.backgroundColor
      )
      .clipShape(.capsule)
      .animation(.easeOut(duration: 0.15), value: state.isPressed)
  }
}
