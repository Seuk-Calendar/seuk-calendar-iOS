//
//  TPLComment+Configuration.swift
//  DesignSystem
//
//  Created by YoungK on 2/11/26.
//

import SwiftUI

public enum TPLComment {}

public extension TPLComment {
  struct Configuration: Identifiable {
    public let id: Int
    public let profileImageUrl: String?
    public let memberName: String
    public let nameColor: Color
    public let isOwner: Bool
    public let content: String
    public let dateText: String
    public let likeCount: Int
    public let repliesCount: Int
    public let isLiked: Bool
    public let isHighlighted: Bool
    public let onTapReply: () -> Void
    public let onTapLike: () -> Void
    public let onTapShowReplies: () -> Void
    public let onAppearContextPopup: (() -> Void)?
    public let onDisappearContextPopup: (() -> Void)?
    public let onEdit: (() -> Void)?
    public let onDelete: (() -> Void)?
    public let onReport: (() -> Void)?

    public init(
      id: Int,
      profileImageUrl: String? = nil,
      memberName: String,
      nameColor: Color,
      isOwner: Bool,
      content: String,
      dateText: String,
      likeCount: Int,
      repliesCount: Int = 0,
      isLiked: Bool = false,
      isHighlighted: Bool = false,
      onTapReply: @escaping () -> Void,
      onTapLike: @escaping () -> Void,
      onTapShowReplies: @escaping () -> Void,
      onAppearContextPopup: (() -> Void)? = nil,
      onDisappearContextPopup: (() -> Void)? = nil,
      onEdit: (() -> Void)? = nil,
      onDelete: (() -> Void)? = nil,
      onReport: (() -> Void)? = nil
    ) {
      self.id = id
      self.profileImageUrl = profileImageUrl
      self.memberName = memberName
      self.nameColor = nameColor
      self.isOwner = isOwner
      self.content = content
      self.dateText = dateText
      self.likeCount = likeCount
      self.repliesCount = repliesCount
      self.isLiked = isLiked
      self.isHighlighted = isHighlighted
      self.onTapReply = onTapReply
      self.onTapLike = onTapLike
      self.onTapShowReplies = onTapShowReplies
      self.onAppearContextPopup = onAppearContextPopup
      self.onDisappearContextPopup = onDisappearContextPopup
      self.onEdit = onEdit
      self.onDelete = onDelete
      self.onReport = onReport
    }
  }
}
