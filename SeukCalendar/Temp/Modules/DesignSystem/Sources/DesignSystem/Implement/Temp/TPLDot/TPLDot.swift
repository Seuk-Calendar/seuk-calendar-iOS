//
//  TPLDot.swift
//  DesignSystem
//
//  Created by YoungK on 2/13/26.
//

import SwiftUI

public struct TPLDot: View {
  let dotSize: CGFloat
  
  public init(dotSize: CGFloat) {
    self.dotSize = dotSize
  }
  
  public var body: some View {
    Rectangle()
      .foregroundStyle(.clear)
      .overlay {
        Circle()
          .frame(dotSize)
          .foregroundStyle(PoolColor.Labels.tertiary)
      }
  }
}

#Preview {
  ZStack {
    PoolColor.Backgrounds.tertiary
    TPLDot(dotSize: 10)
  }
}
