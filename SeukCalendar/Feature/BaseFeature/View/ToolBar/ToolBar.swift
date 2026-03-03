import DesignSystem
import SwiftUI

public extension View {
  func toolBar(
    leadingItem: ToolbarModel? = nil,
    titleItem: ToolbarModel? = nil,
    trailingItems: [ToolbarModel] = []
  ) -> some View {
    return self
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbar {
        if let leadingItem = leadingItem {
          ToolbarItem(placement: .topBarLeading) {
            contentView(leadingItem)
          }
        }

        if let titleItem = titleItem {
          ToolbarItem(placement: .principal) {
            contentView(titleItem)
          }
        }

        if !trailingItems.isEmpty {
          ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: Spacing.sp300) {
              ForEach(trailingItems, id: \.content) { item in
                contentView(item)
              }
            }
          }
        }
      }

    func contentView(_ model: ToolbarModel) -> some View {
      Button {
        model.action()
      } label: {
        switch model.content {
        case let .icon(model):
          Image(model.icon)
            .resizable()
            .tint(model.color)
            .frame(width: 24, height: 24)
        case let .text(model):
          Text(model.title)
            .font(model.fontStyle.font)
            .foregroundStyle(model.color)
        }
      }
      .buttonStyle(NoHighlightButtonStyle())
    }
  }
}

public enum ToolbarContent: Hashable {
  public struct TextModel: Hashable {
    let title: String
    let fontStyle: any FontStyleType
    let color: Color

    public init(
      title: String,
      fontStyle: any FontStyleType = Label2.bold,
      color: Color = .primary
    ) {
      self.title = title
      self.fontStyle = fontStyle
      self.color = color
    }

    public static func == (lhs: ToolbarContent.TextModel, rhs: ToolbarContent.TextModel) -> Bool {
      lhs.title == rhs.title && lhs.color == rhs.color && lhs.fontStyle.font == rhs.fontStyle.font
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(title)
      hasher.combine(color)
      hasher.combine(fontStyle.font)
    }
  }

  public struct IconModel: Hashable {
    let icon: ImageResource
    let color: Color

    public init(
      icon: ImageResource,
      color: Color = .primary
    ) {
      self.icon = icon
      self.color = color
    }
  }

  case text(TextModel)
  case icon(IconModel)

  public static func == (lhs: ToolbarContent, rhs: ToolbarContent) -> Bool {
    switch (lhs, rhs) {
    case let (.text(lhs), .text(rhs)):
      return lhs == rhs
    case let (.icon(lhs), .icon(rhs)):
      return lhs == rhs
    default:
      return false
    }
  }
}

public struct ToolbarModel: Hashable {
  public typealias Action = () -> Void

  let content: ToolbarContent
  let action: Action

  public init(
    content: ToolbarContent,
    action: @escaping Action
  ) {
    self.content = content
    self.action = action
  }

  public static func == (lhs: ToolbarModel, rhs: ToolbarModel) -> Bool {
    lhs.content == rhs.content
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(content)
  }

  public static func back(_ action: @escaping Action) -> ToolbarModel {
    return ToolbarModel(
      content: .icon(
        ToolbarContent.IconModel(
          icon: Icon.arrowLeft,
          color: .primary
        )
      ),
      action: action
    )
  }
}
