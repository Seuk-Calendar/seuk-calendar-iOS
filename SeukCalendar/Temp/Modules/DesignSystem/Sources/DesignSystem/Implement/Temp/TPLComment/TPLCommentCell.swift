//
//  TPLCommentCell.swift
//  DesignSystem
//
//  Created by YoungK on 2/13/26.
//

import SwiftUI

public struct TPLCommentCell: View {
  // MARK: - Properties

  private let profileImageUrl: String?
  private let memberName: String
  private let nameColor: Color
  private let isOwner: Bool
  private let content: String
  private let dateText: String
  private let likeCount: Int
  private let isLiked: Bool
  private let isHighlighted: Bool
  private let isReply: Bool

  private let onTapReply: () -> Void
  private let onTapLike: () -> Void

  // MARK: - ContextPopup 관련
  // TODO: 상위 뷰에서 관리하도록 이동, 여기선 전체화면에 흐림처리 & dismiss를 할 수 없음
  private let onAppearContextPopup: (() -> Void)?
  private let onDisappearContextPopup: (() -> Void)?
  private let onEdit: (() -> Void)?
  private let onDelete: (() -> Void)?
  private let onReport: (() -> Void)?

  // MARK: - State

  @State private var showContextPopup = false

  // MARK: - Init (Comment)

  public init(comment config: TPLComment.Configuration) {
    self.profileImageUrl = config.profileImageUrl
    self.memberName = config.memberName
    self.nameColor = config.nameColor
    self.isOwner = config.isOwner
    self.content = config.content
    self.dateText = config.dateText
    self.likeCount = config.likeCount
    self.isLiked = config.isLiked
    self.isReply = false
    self.isHighlighted = config.isHighlighted
    self.onTapReply = config.onTapReply
    self.onTapLike = config.onTapLike
    self.onAppearContextPopup = config.onAppearContextPopup
    self.onDisappearContextPopup = config.onDisappearContextPopup
    self.onEdit = config.onEdit
    self.onDelete = config.onDelete
    self.onReport = config.onReport
  }

  // MARK: - Init (Reply)

  public init(reply config: TPLReply.Configuration) {
    self.profileImageUrl = config.profileImageUrl
    self.memberName = config.memberName
    self.nameColor = config.nameColor
    self.isOwner = config.isOwner
    self.content = config.content
    self.dateText = config.dateText
    self.likeCount = config.likeCount
    self.isLiked = config.isLiked
    self.isReply = true
    self.isHighlighted = config.isHighlighted
    self.onTapReply = config.onTapReply
    self.onTapLike = config.onTapLike
    self.onAppearContextPopup = config.onAppearContextPopup
    self.onDisappearContextPopup = config.onDisappearContextPopup
    self.onEdit = config.onEdit
    self.onDelete = config.onDelete
    self.onReport = config.onReport
  }

  // MARK: - Body

  public var body: some View {
    HStack(alignment: .top, spacing: Spacing.sp250) {
      profileImage()

      VStack(alignment: .leading, spacing: Spacing.sp100) {
        headerSection()
        HStack(alignment: .top, spacing: 0) {
          VStack(alignment: .leading, spacing: Spacing.sp100) {
            contentSection()
            replyButtonSection()
          }
          Spacer(minLength: Spacing.sp100)
          likeButton()
        }
      }
    }
    .padding(.leading, isReply ? Spacing.sp1500 : Spacing.sp400)
    .padding(.trailing, Spacing.sp400)
    .padding(.top, Spacing.sp250)
    .padding(.bottom, Spacing.sp150)
    .if(condition: isHighlighted) {
      $0.background(highlightBackground)
    }
    .onLongPressGesture {
      withAnimation(.easeInOut(duration: 0.15)) {
        showContextPopup = true
      }
    }
    .overlay(alignment: .bottomTrailing) {
      if showContextPopup {
        contextPopupOverlay()
          .padding(.trailing, Spacing.sp400)
      }
    }
    .animation(.easeInOut, value: showContextPopup)
  }
}

// MARK: - Subviews

private extension TPLCommentCell {
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
    .frame(isReply ? 24 : 32)
    .clipShape(.circle)
  }

  @ViewBuilder
  func profilePlaceholder() -> some View {
    Circle()
      .fill(nameColor.opacity(0.3))
      .overlay {
        Text(String(memberName.prefix(1)))
          .font(isReply ? Caption1.semibold : Body2.bold)
          .foregroundStyle(nameColor)
      }
  }

  @ViewBuilder
  func headerSection() -> some View {
    HStack(spacing: 0) {
      Text("\(memberName)\(isOwner ? "(나)" : "")")
        .font(Label3.semibold)
        .foregroundStyle(isOwner ? PoolColor.Colors.brand : nameColor)

      TPLDot(dotSize: 2)
        .frame(10)

      Text(dateText)
        .font(Label3.regular)
        .foregroundStyle(PoolColor.Labels.secondary)
    }
  }

  @ViewBuilder
  func contentSection() -> some View {
    Text(content)
      .font(Body2.regular)
      .foregroundStyle(PoolColor.Labels.primary)
      .multilineTextAlignment(.leading)
  }

  @ViewBuilder
  func replyButtonSection() -> some View {
    Button(action: onTapReply) {
      Text("답글 달기")
        .font(Label3.semibold)
        .foregroundStyle(PoolColor.Labels.secondary)
    }
    .padding(.vertical, Spacing.sp150)
  }

  @ViewBuilder
  func likeButton() -> some View {
    Button(action: onTapLike) {
      VStack(spacing: 0) {
        Image(isLiked ? Icon.heartFill : Icon.heart)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(isLiked ? PoolColor.Colors.pink : PoolColor.Labels.secondary)
          .frame(16)
          .padding(4)

        if likeCount > 0 {
          Text("\(likeCount)")
            .font(Caption2.semibold)
            .foregroundStyle(PoolColor.Labels.secondary)
        }
      }
    }
  }

  var highlightBackground: some View {
    PoolColor.Fills.quaternary
  }
}

// MARK: - Context Popup

private extension TPLCommentCell {
  func contextPopupOverlay() -> some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          showContextPopup = false
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      contextPopup()
        .frame(width: 200)
    }
  }

  @ViewBuilder
  func contextPopup() -> some View {
    if isOwner {
      ownerContextPopup()
    } else {
      otherContextPopup()
    }
  }

  @ViewBuilder
  func ownerContextPopup() -> some View {
    PLContextPopup {
      PLRow(
        configuration: .init(title: "수정"),
        action: {
          showContextPopup = false
          onEdit?()
        },
        leadingItem: {
          Image(Icon.editFill)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(PoolColor.Labels.primary)
            .frame(22)
        }
      )

      PLRow(
        configuration: .init(title: "삭제"),
        action: {
          showContextPopup = false
          onDelete?()
        },
        leadingItem: {
          Image(Icon.trashFill)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(PoolColor.Colors.red)
            .frame(22)
        }
      )
    }
  }

  @ViewBuilder
  func otherContextPopup() -> some View {
    PLContextPopup {
      PLRow(
        configuration: .init(title: "신고"),
        action: {
          showContextPopup = false
          onReport?()
        },
        leadingItem: {
          Image(Icon.flagFill)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(PoolColor.Colors.red)
            .frame(22)
        }
      )
    }
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: 0) {
    TPLCommentCell(
      comment: .init(
        id: 1,
        memberName: "슈가슈가룬",
        nameColor: .green,
        isOwner: true,
        content: "올해 태연 콘서트 전체 영상을 가지고 있어야 할까요? 몇가지 빠진 공연들을 제외하고 작업해도 되는지 문의드립니다.",
        dateText: "3일 전",
        likeCount: 100,
        repliesCount: 12,
        isLiked: false,
        onTapReply: {},
        onTapLike: {},
        onTapShowReplies: {},
        onEdit: {},
        onDelete: {}
      )
    )

    Divider()

    TPLCommentCell(
      comment: .init(
        id: 2,
        memberName: "다른유저",
        nameColor: .purple,
        isOwner: false,
        content: "좋은 영상 감사합니다!",
        dateText: "1시간 전",
        likeCount: 5,
        isLiked: true,
        isHighlighted: true,
        onTapReply: {},
        onTapLike: {},
        onTapShowReplies: {},
        onReport: {}
      )
    )

    Divider()

    TPLCommentCell(
      reply: .init(
        id: 3,
        memberName: "답글유저",
        nameColor: .orange,
        isOwner: false,
        content: "저도 궁금합니다.",
        dateText: "30분 전",
        likeCount: 2,
        onTapReply: {},
        onTapLike: {},
        onReport: {}
      )
    )
  }
  .background(PoolColor.Backgrounds.tertiary)
}
