//
//  ContextPopup.swift
//  DesignSystem
//
//  Created by YoungK on 11/5/25.
//

import SwiftUI

public struct PLContextPopup: View {
  private let configuration: PLContextPopup.Configuration
  private let contents: [AnyView]

  public init(
    configuration: PLContextPopup.Configuration = Configuration(),
    @ContextPopupBuilder _ builder: @escaping () -> [AnyView]
  ) {
    self.configuration = configuration
    self.contents = builder()
  }

  public var body: some View {
    VStack(spacing: configuration.spacing) {
      ForEach(Array(contents.enumerated()), id: \.offset) { _, view in
        view
      }
    }
    .padding(.vertical, configuration.vPadding)
    .background { roundedRectangleBackground() }
  }

  func roundedRectangleBackground() -> some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(configuration.backgroundColor)
      .strokeBorder(
        configuration.borderColor,
        lineWidth: configuration.borderWidth
      )
  }
}

#Preview {
  @Previewable @State var isPresented = true

  Button(action: { isPresented.toggle() }, label: { Text("버튼") })

  PLContextPopup {
    PLRow(
      configuration: PLRow.Configuration(
        title: "요청하기"
      ),
      action: { isPresented = false },
      leadingItem: {
        Image(Icon.check2Fill).tint(Color.labels.primary)
      }
    )

    PLRow(
      configuration: PLRow.Configuration(
        title: "영상 올리기"
      ),
      action: { isPresented = false },
      leadingItem: { Image(Icon.check2Fill).tint(Color.labels.primary) }
    )

    PLRow(
      configuration: PLRow.Configuration(
        title: "3번째 옵션"
      ),
      action: { isPresented = false },
      leadingItem: { Image(Icon.check2Fill).tint(Color.labels.primary) }
    )
  }
}
