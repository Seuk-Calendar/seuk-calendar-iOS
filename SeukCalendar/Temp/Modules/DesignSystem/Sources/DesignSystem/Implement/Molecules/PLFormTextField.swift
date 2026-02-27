//
//  PLFormTextField.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 9/28/25.
//

import Core
import SwiftUI

public struct PLFormTextField: View {
  @Binding var text: String

  private let title: String
  private let description: String
  private let isSecure: Bool
  private let isRequired: Bool
  private let placeHolder: String
  private let fontStyle: any FontStyleType
  private let textColor: Color
  private let condition: (() -> Bool?)? // 성공, 실패가 있을 때

  private var descriptionColor: Color {
    if let condition = self.condition,
       let isValid = condition() {
      return isValid ? PoolColor.Labels.quaternary : PoolColor.Colors.red
    } else {
      return PoolColor.Labels.quaternary
    }
  }

  public init(
    text: Binding<String>,
    title: String,
    description: String,
    isSecure: Bool = false,
    isRequired: Bool = false,
    fontStyle: any FontStyleType = Body1.regular,
    placeHolder: String = "내용을 입력해주세요.",
    textColor: Color = PoolColor.Labels.primary,
    condition: (() -> Bool?)? = nil // 피그마 State Value를 condition으로 구현
  ) {
    self._text = text
    self.title = title
    self.description = description
    self.isSecure = isSecure
    self.isRequired = isRequired
    self.fontStyle = fontStyle
    self.placeHolder = placeHolder
    self.textColor = textColor
    self.condition = condition
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: Spacing.sp200) {
      HStack(spacing: Spacing.sp050) {
        Text(title)
          .foregroundStyle(PoolColor.Labels.secondary)

        if isRequired {
          Text("*")
            .foregroundStyle(PoolColor.Colors.red)
        }
      }
      .font(Label3.semibold)

      VStack(alignment: .leading, spacing: Spacing.sp100) {
        PLTextField(
          text: $text,
          isSecure: isSecure,
          fontStyle: fontStyle,
          placeHolder: placeHolder,
          textColor: textColor,
          condition: condition
        )

        if !description.isEmpty {
          Text(description)
            .font(Caption2.regular)
            .foregroundStyle(descriptionColor)
            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
        }
      }
      .animation(.spring, value: description)
    }
  }
}

#Preview {
  @Previewable @State var text: String = ""
  PLFormTextField(text: $text, title: "제목", description: "설명을 적어주세요.")
}
