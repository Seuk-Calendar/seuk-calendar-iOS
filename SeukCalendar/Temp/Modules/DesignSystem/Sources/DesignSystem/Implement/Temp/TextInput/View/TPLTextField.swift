//
//  TPLTextField.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2/1/26.
//

import Core
import SwiftUI

public struct TPLTextField: View {
  @FocusState private var isFocused
  @Binding private var text: String
  private let fontStyle: any FontStyleType
  private let placeHolder: String
  private let textColor: Color

  public init(
    text: Binding<String>,
    fontStyle: any FontStyleType,
    placeHolder: String = "내용을 입력하세요.",
    textColor: Color = .labels.primary
  ) {
    self._text = text
    self.fontStyle = fontStyle
    self.placeHolder = placeHolder
    self.textColor = textColor
  }

  public var body: some View {
    TextField(text: $text) {
      Text(placeHolder)
        .foregroundStyle(Color.labels.secondary)
    }
    .foregroundStyle(textColor)
    .font(fontStyle)
    .tint(Color.colors.brand) // 커서 색상
    .focused($isFocused)
    .padding(.vertical, Spacing.sp300)
    .padding(.horizontal, Spacing.sp400)
    .background(Color.etc.buttonDisabeldBg)
    .roundedBorder(
      cornerRadius: Radius.rds300,
      borderColor: .labels.quaternary,
      borderWidth: isFocused ? 2 : 1
    )
  }
}

public struct TPLValidationTextField: View {
  @Binding private var text: String
  @Binding private var inputValidationState: InputValidationState
  private let placeHolder: String
  private let igonreNormalState: Bool // normal 상태일 때, 설명 무시하기

  public init(
    text: Binding<String>,
    inputValidationState: Binding<InputValidationState>,
    placeHolder: String,
    igonreNormalState: Bool = true
  ) {
    self._text = text
    self._inputValidationState = inputValidationState
    self.placeHolder = placeHolder
    self.igonreNormalState = igonreNormalState
  }

  public var body: some View {
    VStack(
      alignment: .leading,
      spacing: Spacing.sp100
    ) {
      TPLTextField(
        text: $text,
        fontStyle: Body1.regular,
        placeHolder: placeHolder
      )
      .roundedBorder(
        cornerRadius: Radius.rds300,
        borderColor: {
          if case .normal = inputValidationState { return .clear }
          return inputValidationState.color
        }(),
        borderWidth: {
          if case .normal = inputValidationState { return .zero }
          return 2
        }()
      )

      helpText()
        .font(Caption2.regular)
        .foregroundStyle(inputValidationState.color)
    }
  }

  @ViewBuilder
  func helpText() -> some View {
    switch inputValidationState {
    case let .normal(message):
      if !igonreNormalState {
        Text(message)
      }

    case let .invalid(message):
      Text(message)

    case .valid:
      EmptyView()
    }
  }
}

#Preview {
  @Previewable @State var text: String = ""
  @Previewable @State var state: InputValidationState = .invalid("핼로")
  @Previewable @State var state2: InputValidationState = .normal("헬로")
  VStack(spacing: 10) {
    TPLTextField(text: $text, fontStyle: Body1.regular, textColor: .labels.primary)
    TPLValidationTextField(
      text: $text,
      inputValidationState: $state,
      placeHolder: "내용을 입력하세요."
    )

    TPLValidationTextField(
      text: $text,
      inputValidationState: $state2,
      placeHolder: "내용을 입력하세요.",
      igonreNormalState: false
    )

    TPLValidationTextField(
      text: $text,
      inputValidationState: $state2,
      placeHolder: "내용을 입력하세요."
    )
  }
}
