//
//  TPLRadioGroup.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2/4/26.
//

import SwiftUI

public struct TPLRadioGroup: View {
  private let hilightStyle: HilghtStyle
  private let options: [Option]
  private let onSelection: (Int) -> Void

  @State private var selectedIndex: Int?

  public init(
    options: [Option],
    hilightStyle: HilghtStyle = .background,
    preselectedIndex: Int? = nil,
    onSelection: @escaping (Int) -> Void
  ) {
    self.options = options
    self.hilightStyle = hilightStyle
    self.selectedIndex = preselectedIndex
    self.onSelection = onSelection
  }

  public var body: some View {
    ForEach(Array(options.enumerated()), id: \.element.title) { index, option in
      HStack {
        content(option: option)
        Spacer()
        Image(Icon.check2Fill)
          .resizable()
          .tint(.colors.brand)
          .frame(24)
        #warning("선택 안됐을 떄 이미지 교체")
      }
      .padding(.horizontal, Spacing.sp400)
      .padding(.vertical, Spacing.sp300)
      .if(condition: hilightStyle == .background) {
        if let selectedIndex = selectedIndex, index == selectedIndex {
          return $0
            .background(Color.fills.quaternary)
        } else {
          return $0.background(Color.clear)
        }
      }
      .contentShape(Rectangle())
      .clipShape(.rect(cornerRadius: Radius.rds400))
      .onTapGesture {
        selectedIndex = index
        onSelection(index)
      }
    }
  }

  func content(option: Option) -> some View {
    return VStack(
      alignment: .leading,
      spacing: Spacing.sp050
    ) {
      Text(option.title)
        .font(Body1.regular)
        .foregroundStyle(Color.labels.primary)

      if let description = option.description {
        Text(description)
          .font(Caption1.regular)
          .foregroundStyle(Color.labels.secondary)
      }
    }
  }
}

#Preview {
  TPLRadioGroup(
    options: [.init(
      title: "선착순 선정 (1명)",
      description: "자동선정 빠른 진행"
    ), .init(
      title: "순위 선정 (1명)",
      description: "마음에 드는 쇼츠 1개 선택"
    ), .init(
      title: "순위 선정(3명)",
      description: "1,2,3등 차등 지급"
    )], onSelection: { print("selectedIndex: \($0)")}
  )
}

public extension TPLRadioGroup {
  struct Option: Hashable {
    public let title: String
    public let description: String?

    public init(
      title: String,
      description: String?
    ) {
      self.title = title
      self.description = description
    }
  }

  enum HilghtStyle {
    case background
    case clear
  }
}
