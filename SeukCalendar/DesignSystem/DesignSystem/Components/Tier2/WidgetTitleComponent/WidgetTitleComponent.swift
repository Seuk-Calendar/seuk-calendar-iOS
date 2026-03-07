import SwiftUI

public struct WidgetTitleComponent: View {
  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  public var body: some View {
    Text(configuration.title)
      .font(titleStyle)
      .foregroundStyle(Color.semantic.Content.contentPrimary)
      .lineLimit(1)
      .minimumScaleFactor(0.7)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension WidgetTitleComponent {
  var titleStyle: any FontStyleType {
    switch configuration.style {
    case .standard:
      Heading.xSmall
    case .compact:
      Label.large
    }
  }
}

#if DEBUG
  #Preview {
    WidgetTitleComponent(
      configuration: .init(title: "2026년 3월 3일 화요일")
    )
    .padding()
  }
#endif
