//
//  PLFooter.swift
//  DesignSystem
//
//  Created by YoungK on 11/4/25.
//

import SwiftUI

public struct PLFooter<LeadingItem: View, TrailingItem: View>: View {
  private let title: String
  private let description: String?
  private let isShowDivider: Bool
  private let leadingItem: () -> LeadingItem
  private let trailingItem: () -> TrailingItem

  public init(
    title: String,
    description: String? = nil,
    isShowDivider: Bool,
    leadingItem: @escaping () -> LeadingItem,
    trailingItem: @escaping () -> TrailingItem
  ) {
    self.title = title
    self.description = description
    self.isShowDivider = isShowDivider
    self.leadingItem = leadingItem
    self.trailingItem = trailingItem
  }

  public var body: some View {
    PLRow(
      configuration: PLRow.Configuration(
        title: title,
        description: description,
        contentType: .footer,
        isShowDivider: isShowDivider
      ),
      leadingItem: leadingItem,
      trailingItem: trailingItem
    )
  }
}

#Preview {
  PLFooter(
    title: "푸터입니다",
    description: "설명입니다.",
    isShowDivider: false,
    leadingItem: {
      Image(systemName: "person")
    },
    trailingItem: {
      Image(systemName: "chevron.right")
    }
  )
}
