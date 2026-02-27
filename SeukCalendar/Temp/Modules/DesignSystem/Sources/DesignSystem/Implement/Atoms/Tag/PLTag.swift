//
//  PLTag.swift
//  DesignSystem
//
//  Created by YoungK on 11/3/25.
//

import SwiftUI

public struct PLTag: View {
  private var title: String
  private let configuration: Configuration
  private let action: () -> Void

  @State private var isPressed: Bool = false

  public init(
    title: String,
    configuration: Configuration,
    action: @escaping (() -> Void)
  ) {
    self.title = title
    self.configuration = configuration
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      content()
        .padding(.vertical, Spacing.sp100)
        .padding(.horizontal, Spacing.sp250)
    }
    .buttonStyle(
      PLTagButtonStyle(
        configuration: configuration,
        isPressed: $isPressed
      )
    )
  }

  func content() -> some View {
    HStack(spacing: Spacing.sp050) {
      if let leadingIcon = configuration.leadingIcon {
        Image(leadingIcon)
          .resizable()
          .tint(foregroundColor())
          .frame(width: 16, height: 16)
      }

      Text(title)
        .font(Label3.semibold)
        .lineLimit(1)

      if let trailingIcon = configuration.trailingIcon {
        Image(trailingIcon)
          .resizable()
          .tint(foregroundColor())
          .frame(width: 16, height: 16)
      }
    }
  }

  func foregroundColor() -> Color {
    isPressed
      ? configuration.selectedColors.foregroundColor
      : configuration.normalColors.foregroundColor
  }

  func backgroundColor() -> Color {
    isPressed
      ? configuration.selectedColors.backgroundColor
      : configuration.normalColors.backgroundColor
  }
}

#Preview {
  PLTag(
    title: "텍스트",
    configuration: PLTag.Configuration(
      leadingIcon: Icon.arrowLeft
    ),
    action: { print("버튼 누름") }
  )

  PLTag(
    title: "텍스트",
    configuration: PLTag.Configuration(
      leadingIcon: Icon.arrowLeft,
      trailingIcon: Icon.chat,
      normalColors: PLTag.Colors(
        foregroundColor: Color.white,
        backgroundColor: Color.gray
      ),
      selectedColors: PLTag.Colors(
        foregroundColor: Color.red,
        backgroundColor: Color.black
      )
    ),
    action: { print("버튼 누름") }
  )
}
