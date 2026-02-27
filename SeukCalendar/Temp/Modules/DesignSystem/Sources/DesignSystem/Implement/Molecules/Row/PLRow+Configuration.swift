//
//  Configuration.swift
//  DesignSystem
//
//  Created by YoungK on 11/4/25.
//

import SwiftUI

public extension PLRow {
  enum ContentType {
    case header, footer, row

    var titleFont: Font {
      switch self {
      case .header:
        Label3.semibold.font
      case .footer:
        Caption1.regular.font
      case .row:
        Body1.regular.font
      }
    }

    var titleColor: Color {
      switch self {
      case .header:
        Color.labels.primary
      case .footer:
        Color.labels.secondary
      case .row:
        Color.labels.primary
      }
    }

    var descriptionFont: Font {
      Caption2.regular.font
    }

    var descriptionColor: Color {
      Color.labels.secondary
    }

    var vItemSpacing: CGFloat {
      return 0
    }

    var hItemSpacing: CGFloat {
      Spacing.sp200
    }

    var vPadding: CGFloat {
      Spacing.sp250
    }

    var hPadding: CGFloat {
      Spacing.sp400
    }
  }

  struct Configuration {
    let title: String
    let description: String?
    let contentType: PLRow.ContentType
    let isShowDivider: Bool

    public init(
      title: String,
      description: String? = nil,
      contentType: PLRow.ContentType = .row,
      isShowDivider: Bool = false
    ) {
      self.title = title
      self.description = description
      self.contentType = contentType
      self.isShowDivider = isShowDivider
    }
  }
}
