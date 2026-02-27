//
//  TPLStepper.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2/5/26.
//

import SwiftUI

public struct TPLStepper<Content: View>: View {
  @Binding private var leftButtonEnable: Bool
  @Binding private var rightButtonEnable: Bool
  @ViewBuilder private let leftButtonLabel: () -> Content
  @ViewBuilder private let rightButtonLabel: () -> Content
  private let didTapLeftButton: () -> Void
  private let didTapRightButton: () -> Void

  public init(
    leftButtonEnable: Binding<Bool>,
    rightButtonEnable: Binding<Bool>,
    @ViewBuilder leftButtonLabel: @escaping () -> Content,
    @ViewBuilder rightButtonLabel: @escaping () -> Content,
    didTapLeftButton: @escaping () -> Void,
    didTapRightButton: @escaping () -> Void
  ) {
    self._leftButtonEnable = leftButtonEnable
    self._rightButtonEnable = rightButtonEnable
    self.leftButtonLabel = leftButtonLabel
    self.rightButtonLabel = rightButtonLabel
    self.didTapLeftButton = didTapLeftButton
    self.didTapRightButton = didTapRightButton
  }

  public var body: some View {
    HStack(spacing: .zero) {
      Button(action: {
        didTapLeftButton()
      }, label: {
        leftButtonLabel()
      })
      .padding(Spacing.sp300)
      .disabled(!leftButtonEnable)

      Color.separators.opaque
        .frame(width: 1, height: 48)

      Button(action: {
        didTapRightButton()
      }, label: {
        rightButtonLabel()
      })
      .padding(Spacing.sp300)
      .disabled(!rightButtonEnable)
    }
    .background(Color.fills.primary)
    .clipShape(.rect(cornerRadius: Radius.rds300))
  }
}

#Preview {
  @Previewable @State var leftButtonEnable: Bool = true
  @Previewable @State var rightButtonEnable: Bool = true

  TPLStepper(
    leftButtonEnable: $leftButtonEnable,
    rightButtonEnable: $rightButtonEnable,
    leftButtonLabel: {
      Image(Icon.arrowLeft)
        .resizable()
        .tint(leftButtonEnable ? .labels.secondary : .labels.quaternary)
        .frame(24)
    },
    rightButtonLabel: {
      Image(Icon.arrowLeft)
        .resizable()
        .tint(rightButtonEnable ? .labels.secondary : .labels.quaternary)
        .frame(24)
    },
    didTapLeftButton: {
      leftButtonEnable.toggle()
    },
    didTapRightButton: {
      rightButtonEnable.toggle()
    }
  )
}
