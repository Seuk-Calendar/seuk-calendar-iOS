//
//  TPLIndicatorView.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2/9/26.
//

import SwiftUI

public struct TPLIndicatorView: View {
  public init() {}

  public var body: some View {
    ProgressView()
      .tint(Color.colors.brand)
      .frame(20)
      .padding(.vertical, Spacing.sp600)
  }
}

#Preview {
  TPLIndicatorView()
}
