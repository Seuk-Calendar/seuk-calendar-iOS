//
//  TPLTextView.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2/1/26.
//

import Core
import SwiftUI

public struct TPLTextView: View {
  @FocusState private var isFocused: Bool
  @Binding private var text: String
  private let fontStyle: any FontStyleType
  private let heightRange: ClosedRange<CGFloat>
  private let placeHolder: String
  private let textColor: Color

  public init(
    text: Binding<String>,
    fontStyle: any FontStyleType,
    heightRange: ClosedRange<CGFloat>,
    placeHolder: String = "내용을 입력하세요.",
    textColor: Color = .labels.primary
  ) {
    self._text = text
    self.fontStyle = fontStyle
    self.heightRange = heightRange
    self.placeHolder = placeHolder
    self.textColor = textColor
  }

  public var body: some View {
    ZStack {
      Group {
        TextEditor(text: $text)
          .foregroundStyle(textColor)
          .autocorrectionDisabled(true)
          .textInputAutocapitalization(.never)
          .scrollContentBackground(.hidden) // 기본 배경 제거
          .font(fontStyle, isSingleLine: false)
          .tint(Color.colors.brand)
          .focused($isFocused)

        if text.isEmpty {
          VStack {
            Text(placeHolder)
              .foregroundStyle(Color.labels.secondary)
              .offset(x: 5, y: 10) // 보정
              .frame(maxWidth: .infinity, alignment: .leading)
              .font(fontStyle)
            Spacer()
          }
        }
      }
    }
    .padding(.horizontal, Spacing.sp400)
    .focused($isFocused)
    .background(Color.etc.buttonDisabeldBg)
    .roundedBorder(
      cornerRadius: Radius.rds300,
      borderColor: .labels.quaternary,
      borderWidth: isFocused ? 2 : 1
    )
    .frame(minHeight: heightRange.lowerBound, maxHeight: heightRange.upperBound)
  }
}

public struct TPLValidationTextView: View {
  @Binding private var text: String
  @Binding private var inputValidationState: InputValidationState
  private let heightRange: ClosedRange<CGFloat>
  private let placeHolder: String
  private let igonreNormalState: Bool // normal 상태일 때, 설명 무시하기

  public init(
    text: Binding<String>,
    inputValidationState: Binding<InputValidationState>,
    heightRange: ClosedRange<CGFloat>,
    placeHolder: String,
    igonreNormalState: Bool = true
  ) {
    self._text = text
    self._inputValidationState = inputValidationState
    self.heightRange = heightRange
    self.placeHolder = placeHolder
    self.igonreNormalState = igonreNormalState
  }

  public var body: some View {
    VStack(
      alignment: .leading,
      spacing: Spacing.sp100
    ) {
      TPLTextView(
        text: $text,
        fontStyle: Body1.regular,
        heightRange: heightRange
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
  VStack {
    TPLTextView(
      text: $text,
      fontStyle: Body1.regular,
      heightRange: 50 ... 100,
      placeHolder: "내용을 입력하세요.",
      textColor: .labels.primary
    )

    TPLValidationTextView(
      text: $text,
      inputValidationState: $state,
      heightRange: 100 ... 200,
      placeHolder: "내용을 입력하세요."
    )
  }
}
