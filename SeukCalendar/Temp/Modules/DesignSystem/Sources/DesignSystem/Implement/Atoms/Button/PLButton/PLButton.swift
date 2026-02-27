//
//  PLButton.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 9/21/25.
//

import SwiftUI

#warning("폰트 적용과 아이콘 외에 적용 완료")
public struct PLButton: View {
  private let configuration: PLButton.Configuration
  private let cornerRadius: CGFloat
  private let foregroundColor: Color
  private let backgroundColor: Color
  private let borderColor: Color
  private var isEnable: Bool
  private let action: () -> Void

  public init(
    configuration: PLButton.Configuration,
    cornerRadius: CGFloat? = nil,
    foregroundColor: Color = .grays.black,
    backgroundColor: Color = .colors.brand,
    borderColor: Color = .clear,
    isEnable: Bool = true,
    action: @escaping () -> Void
  ) {
    self.configuration = configuration
    self.cornerRadius = cornerRadius ?? configuration.size.cornerRadius
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.borderColor = borderColor
    self.isEnable = isEnable
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      makeContent()
        .padding(.horizontal, configuration.size.hPaading)
        .padding(.vertical, configuration.size.vPadding)
        .frame(maxWidth: configuration.size == .expand ? .infinity : nil)
    }
    .background(isEnable ? backgroundColor : PoolColor.Etc.buttonDisabeldBg)
    .roundedBorder(
      cornerRadius: cornerRadius,
      borderColor: borderColor
    )
    .buttonStyle(OverlayButtonStyle())
    .disabled(!isEnable)
  }

  private func makeContent() -> some View {
    HStack(spacing: configuration.size.gap) {
      switch configuration.contentType {
      case let .textOnly(text):
        Text(text)
      case let .iconOnly(icon):
        icon
          .scaledToFit()
      case let .fullContents(text, icon, iconPos):
        Group {
          switch iconPos {
          case .leading:
            icon
              .tint(isEnable ? foregroundColor : PoolColor.Labels.quaternary)
            Text(text)
          case .trailing:
            Text(text)
            icon
              .tint(isEnable ? foregroundColor : PoolColor.Labels.quaternary)
          }
        }
      }
    }
    .font(configuration.size.font)
    .foregroundStyle(isEnable ? foregroundColor : PoolColor.Labels.quaternary)
  }
}

#Preview {
  VStack {
    PLButton(
      configuration: .init(
        contentType: .fullContents(text: "Hello", icon: Image(Icon.heartFill), iconPos: .leading),
        size: .expand
      ),
      foregroundColor: .pink,
      backgroundColor: PoolColor.Backgrounds.secondary,
      action: { print("Hello") }
    )
  }
}
