//
//  GhostButton.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 10/14/25.
//

import SwiftUI

public struct GhostButton: View {
  private let contentType: PLButton.ContentType
  private let size: PLButton.Size
  private let cornerRadius: CGFloat
  private let foregroundColor: Color
  private let borderColor: Color
  private var isEnable: Bool
  private let action: () -> Void

  public init(
    contentType: PLButton.ContentType,
    size: PLButton.Size,
    cornerRadius: CGFloat? = nil,
    foregroundColor: Color = .labels.primary,
    borderColor: Color = .clear,
    isEnable: Bool = true,
    action: @escaping () -> Void
  ) {
    self.contentType = contentType
    self.size = size
    self.cornerRadius = cornerRadius ?? size.cornerRadius
    self.foregroundColor = foregroundColor
    self.borderColor = borderColor
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
      foregroundColor: foregroundColor,
      backgroundColor: .clear,
      borderColor: borderColor,
      isEnable: isEnable,
      action: action
    )
  }
}

#Preview {
  GhostButton(
    contentType: .textOnly(text: "123"),
    size: .expand,
    action: {}
  )
}
