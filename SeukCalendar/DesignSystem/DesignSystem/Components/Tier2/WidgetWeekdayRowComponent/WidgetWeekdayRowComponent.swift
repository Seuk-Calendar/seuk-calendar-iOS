import SwiftUI

public struct WidgetWeekdayRowComponent: View {
  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  public var body: some View {
    HStack(spacing: 0) {
      ForEach(Array(configuration.weekdayItems.enumerated()), id: \.offset) { _, item in
        Text(item.title)
          .font(Label.xSmall)
          .foregroundStyle(textColor(for: item.role))
          .lineLimit(1)
          .minimumScaleFactor(0.7)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension WidgetWeekdayRowComponent {
  func textColor(for role: Configuration.WeekdayItem.Role) -> Color {
    switch role {
    case .sunday:
      .semanticExtensions.Content.contentNegative
    case .weekday:
      .semantic.Content.contentSecondary
    case .saturday:
      .semanticExtensions.Content.contentAccent
    }
  }
}

#if DEBUG
  #Preview {
    WidgetWeekdayRowComponent(configuration: .init())
      .padding()
  }
#endif
