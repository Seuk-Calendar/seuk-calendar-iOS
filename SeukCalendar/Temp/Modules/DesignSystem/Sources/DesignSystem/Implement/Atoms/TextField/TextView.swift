//
//  TextView.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 8/15/25.
//

import SwiftUI
#warning("높이 조절을 여기서 처리")
public struct TextView: View {
  @Binding private var text: String
  @FocusState private var isFocused: Bool

  private let fontStyle: any FontStyleType
  private let placeHolder: String
  private let forgroundColor: Color
  private let placeHolderColor: Color

  public init(
    text: Binding<String>,
    fontStyle: any FontStyleType,
    forgroundColor: Color = PoolColor.Labels.primary,
    placeHolderColor: Color = PoolColor.Labels.secondary,
    placeHolder: String
  ) {
    self.fontStyle = fontStyle
    self.forgroundColor = forgroundColor
    self.placeHolderColor = placeHolderColor
    self.placeHolder = placeHolder
    self._text = text
  }

  public var body: some View {
    ZStack {
      Group {
        TextEditor(text: $text)
          .offset(y: 2)
          .foregroundStyle(forgroundColor)
          .autocorrectionDisabled(true)
          .textInputAutocapitalization(.never)
          .focused($isFocused)

        if text.isEmpty {
          VStack {
            Text(placeHolder)
              .foregroundStyle(placeHolderColor)
              .padding(.leading, 5)
              .padding(.top, 10)
              .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
          }
        }
      }
      .font(fontStyle)
    }
  }
}

#Preview {
  @Previewable @State var text: String = ""
  TextView(
    text: $text,
    fontStyle: Heading5.bold,
    forgroundColor: .red,
    placeHolder: "자유 작성"
  )
  .background(.red)
}
