//
//  TintButton.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 10/14/25.
//

import SwiftUI

public struct TintButton: View {
  private let contentType: PLButton.ContentType
  private let size: PLButton.Size
  private let cornerRadius: CGFloat
  private var isEnable: Bool
  private let action: () -> Void

  public init(
    contentType: PLButton.ContentType,
    size: PLButton.Size,
    cornerRadius: CGFloat? = nil,
    isEnable: Bool = true,
    action: @escaping () -> Void
  ) {
    self.contentType = contentType
    self.size = size
    self.cornerRadius = cornerRadius ?? size.cornerRadius
    self.isEnable = isEnable
    self.action = action
  }

  public var body: some View {
    PLButton(
      configuration: .init(
        contentType: contentType,
        size: size
      ),
      cornerRadius: cornerRadius,
      foregroundColor: PoolColor.Colors.brand,
      backgroundColor: PoolColor.Colors.brand.opacity(0.15),
      isEnable: isEnable,
      action: action
    )
  }
}

#Preview {
  TintButton(
    contentType: .textOnly(text: "123"),
    size: .expand,
    action: {}
  )
}
