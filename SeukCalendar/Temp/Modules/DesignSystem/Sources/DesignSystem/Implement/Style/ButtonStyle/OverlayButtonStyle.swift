//
//  OverlayButtonStyle.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 9/21/25.
//

import SwiftUI

struct OverlayButtonStyle: ButtonStyle {
  public func makeBody(configuration: ButtonStyleConfiguration) -> some View {
    configuration.label
      .if(condition: configuration.isPressed) { label in
        label
          .overlay {
            PoolColor.Overlays.default.opacity(0.2)
          }
      }
  }
}
