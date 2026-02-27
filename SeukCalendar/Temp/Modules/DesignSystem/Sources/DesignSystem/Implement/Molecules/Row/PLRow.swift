//
//  PLRow.swift
//  DesignSystem
//
//  Created by YoungK on 11/3/25.
//

import SwiftUI

public struct PLRow<LeadingItem: View, TrailingItem: View>: View {
  private let configuration: PLRow.Configuration
  private let action: () -> Void
  private let leadingItem: () -> LeadingItem
  private let trailingItem: () -> TrailingItem

  public init(
    configuration: PLRow.Configuration,
    action: @escaping () -> Void = {},
    @ViewBuilder leadingItem: @escaping () -> LeadingItem = { EmptyView() },
    @ViewBuilder trailingItem: @escaping () -> TrailingItem = { EmptyView() }
  ) {
    self.configuration = configuration
    self.action = action
    self.leadingItem = leadingItem
    self.trailingItem = trailingItem
  }

  public var body: some View {
    Button(action: action) {
      content()
    }
  }

  func content() -> some View {
    VStack(spacing: 0) {
      HStack(spacing: configuration.contentType.hItemSpacing) {
        leadingItem()

        VStack(
          alignment: .leading,
          spacing: configuration.contentType.vItemSpacing
        ) {
          title()
          description()
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        trailingItem()
      }
      .padding(.vertical, configuration.contentType.vPadding)

      ifNeededDivider()
    }
    .padding(.horizontal, configuration.contentType.hPadding)
  }

  func title() -> some View {
    Text(configuration.title)
      .font(configuration.contentType.titleFont)
      .foregroundStyle(configuration.contentType.titleColor)
      .lineLimit(1)
  }

  @ViewBuilder
  func description() -> some View {
    if let description = configuration.description {
      Text(description)
        .font(configuration.contentType.descriptionFont)
        .foregroundStyle(configuration.contentType.descriptionColor)
    } else {
      EmptyView()
    }
  }

  @ViewBuilder
  func ifNeededDivider() -> some View {
    if configuration.isShowDivider {
      Divider().foregroundStyle(Color.separators.nonOpaque)
    } else {
      EmptyView()
    }
  }
}

#Preview {
  @Previewable @State var isOn: Bool = true
  PLRow(
    configuration: PLRow.Configuration(
      title: "제목을 입력하세요.",
      description: "설명을 입력하세요."
    ),
    action: { print("Row 전체 눌림") },
    trailingItem: {
      PLTag(
        title: "자세히 보기",
        configuration: PLTag.Configuration(
          trailingIcon: Icon.arrowLeft
        ),
        action: { print("버튼 눌림") }
      )
    }
  )

  PLRow(
    configuration: PLRow.Configuration(
      title: "제목을 입력하세요.",
      description: "설명을 입력하세요."
    ),
    trailingItem: {
      Toggle("", isOn: $isOn)
    }
  )
}
