//
//  PLTextField.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 9/24/25.
//

import SwiftUI


public struct PLTextField: View {
  @Binding var text: String
  @FocusState var isFocused: Bool

  private let isSecure: Bool
  private let placeHolder: String
  private let fontStyle: any FontStyleType
  private let textColor: Color
  private let hasAutoChecking: Bool
  private let condition: (() -> Bool?)?

  private var borderColor: Color {
    if !isFocused {
      return PoolColor.Labels.quaternary
    }

    if let condition = self.condition,
       let isValid = condition() {
      return isValid ? PoolColor.Labels.quaternary : PoolColor.Colors.red
    } else {
      return PoolColor.Labels.quaternary
    }
  }


  /// <#Description#>
  /// - Parameters:
  ///   - text: 바인딩할 텍스트 값
  ///   - isSecure: 숨김여부
  ///   - fontStyle: 폰트 스타일
  ///   - placeHolder: 플레이스 홀더
  ///   - textColor: 텍스트 색깔
  ///   - hasAutoCheckOption: 글자입력 떄마다, border와 오른족 아이콘 버튼 옵션 사용여부
  ///   - condition: 성공, 실패가 있을 때
  public init(
    text: Binding<String>,
    isSecure: Bool = false,
    fontStyle: any FontStyleType,
    placeHolder: String = "내용을 입력해주세요.",
    textColor: Color = PoolColor.Labels.primary,
    hasAutoCheckOption: Bool = true,
    condition: (() -> Bool?)? = nil // 피그마 State Value를 condition으로 구현
  ) {
    self._text = text
    self.isSecure = isSecure
    self.fontStyle = fontStyle
    self.placeHolder = placeHolder
    self.textColor = textColor
    self.hasAutoChecking = hasAutoCheckOption
    self.condition = condition
  }

  public var body: some View {
    HStack(spacing: .zero) {
      Group {
        if isSecure {
          SecureField(text: $text) {
            Text(placeHolder)
              .foregroundStyle(PoolColor.Labels.secondary)
          }

        } else {
          TextField(text: $text) {
            Text(placeHolder)
              .foregroundStyle(PoolColor.Labels.secondary)
          }
        }
      }
      .foregroundStyle(textColor)
      .font(fontStyle)
      .padding(.leading, Spacing.sp400)
      .padding(.vertical, Spacing.sp300)
      .focused($isFocused)

      Spacer()

      // 오른쪽 끝에 뜨는 아이콘
      if isFocused && !text.isEmpty && hasAutoChecking {
        Group {
          if let condition = self.condition,
             let isValid = condition() {
            Image(isValid ? Icon.check2Fill : Icon.cautionFill)
              .resizable()
              .frame(width: 24, height: 24)
          } else { // 조건이 아예 없거나, 아직 trued와 false가 정해지지 않았을 때는 close2Fill
            Image(Icon.close2Fill)
              .resizable()
              .tint(PoolColor.Labels.tertiary)
              .frame(width: 24, height: 24)
              .contentShape(Rectangle())
              .onTapGesture {
                text = ""
              }
          }
        }
        .padding(.trailing, Spacing.sp400)
      }
    }
    .frame(maxHeight: 48)
    .roundedBorder(
      cornerRadius: Radius.rds300,
      borderColor: hasAutoChecking ? borderColor : .clear,
      borderWidth: isFocused ? 2 : 1
    )
  }
}

#Preview {
  @Previewable @State var text: String = ""
  PLTextField(text: $text, isSecure: true, fontStyle: Heading5.bold)
}
