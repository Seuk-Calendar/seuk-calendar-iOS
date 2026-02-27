//
//  TPLCommentInputBar.swift
//  DesignSystem
//
//  Created by YoungK on 2/13/26.
//

import SwiftUI

public struct TPLCommentInputBar: View {
  @Binding private var text: String
  private let profileImageUrl: String?
  private let replyTargetName: String?
  private let onSubmit: () -> Void
  private let onCancelReply: () -> Void

  public init(
    text: Binding<String>,
    profileImageUrl: String? = nil,
    replyTargetName: String? = nil,
    onSubmit: @escaping () -> Void,
    onCancelReply: @escaping () -> Void = {}
  ) {
    self._text = text
    self.profileImageUrl = profileImageUrl
    self.replyTargetName = replyTargetName
    self.onSubmit = onSubmit
    self.onCancelReply = onCancelReply
  }

  public var body: some View {
    HStack(alignment: .bottom, spacing: Spacing.sp250) {
      profileImage()

      VStack(spacing: Spacing.sp250) {
        if let replyTargetName {
          replyIndicatorSection(name: replyTargetName)
        }

        inputSection()
      }
    }
    .padding(.vertical, Spacing.sp200)
    .padding(.horizontal, Spacing.sp300)
  }
}

// MARK: - Subviews

private extension TPLCommentInputBar {
  func replyIndicatorSection(name: String) -> some View {
    HStack {
      Group {
        Text("@\(name)")
          .foregroundStyle(PoolColor.Colors.brand)
        +
        Text(" 님에게 답글 보내기")
          .foregroundStyle(PoolColor.Grays.gray)
      }
      .font(Caption1.regular)

      Spacer()

      Button(action: onCancelReply) {
        Image(Icon.close)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(PoolColor.Grays.gray)
          .frame(12)
      }
    }
    .padding(.trailing, Spacing.sp200) // TODO: 임의 값
  }

  // TODO: TPLTextField에 버튼 오버레이 필요
  func inputSection() -> some View {
    HStack {
      TPLTextField(text: $text, fontStyle: Body1.regular, textColor: .labels.primary)

      if !text.isEmpty {
        Button {
          onSubmit()
        } label: {
          Image(Icon.arrowCircleFill)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(Color.colors.brand)
            .frame(24)
        }
      }
    }
  }

  @ViewBuilder
  func profileImage() -> some View {
    Group {
      if let urlString = profileImageUrl, let url = URL(string: urlString) {
        AsyncImage(url: url) { phase in
          switch phase {
          case .empty:
            profilePlaceholder().shimmering()
          case let .success(image):
            image.resizable().scaledToFill()
          case .failure:
            profilePlaceholder()
          @unknown default:
            profilePlaceholder()
          }
        }
      } else {
        profilePlaceholder()
      }
    }
    .frame(40)
    .padding(.vertical, 4)
    .clipShape(.circle)
  }

  func profilePlaceholder() -> some View {
    Circle()
      .fill(Color.fills.tertiary)
  }
}

// MARK: - Preview

#Preview("Input Bar - Reply Mode") {
  @Previewable @State var text = ""

  VStack {
    Spacer()
    TPLCommentInputBar(
      text: $text,
      replyTargetName: "Pool",
      onSubmit: { print("submit: \(text)") },
      onCancelReply: { print("cancel") }
    )
  }
}

#Preview("Input Bar - Normal") {
  @Previewable @State var text = ""

  VStack {
    Spacer()
    TPLCommentInputBar(
      text: $text,
      onSubmit: { print("submit: \(text)") }
    )
  }
}
