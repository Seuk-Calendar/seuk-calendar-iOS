import SwiftUI

public struct WidgetTitleComponent: View {
  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  public var body: some View {
    Text(configuration.title)
      .font(Heading.medium)
      .foregroundStyle(Color.semantic.Content.contentPrimary)
      .lineLimit(1)
      .minimumScaleFactor(0.7)
      .frame(maxWidth: .infinity, alignment: .leading)
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
