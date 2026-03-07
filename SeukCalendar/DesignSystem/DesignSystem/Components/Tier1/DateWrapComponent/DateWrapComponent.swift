import SwiftUI

public struct DateWrapComponent: View {
  private enum Metrics {
    static let rowHeight: CGFloat = 28
    static let todayCircleSize: CGFloat = 26
  }

  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  public var body: some View {
    Group {
      if configuration.isToday {
        Text(configuration.dayText)
          .font(.homeCalendar(weight: .bold, size: 16))
          .foregroundStyle(configuration.todayTextColor)
          .frame(width: Metrics.todayCircleSize, height: Metrics.todayCircleSize)
          .background(configuration.todayBackgroundColor, in: Circle())
      } else {
        Text(configuration.dayText)
          .font(.homeCalendar(weight: .bold, size: 22))
          .foregroundStyle(configuration.normalTextColor)
      }
    }
    .lineLimit(1)
    .minimumScaleFactor(0.7)
    .frame(maxWidth: .infinity, minHeight: Metrics.rowHeight, alignment: .center)
  }
}

#if DEBUG
  #Preview {
    VStack(spacing: Spacing.sp200) {
      DateWrapComponent(
        configuration: .init(
          dayText: "25",
          isToday: false,
          normalTextColor: .semantic.Content.contentPrimary,
          todayBackgroundColor: .primitives.gray500,
          todayTextColor: .semanticExtensions.Content.contentOnColor
        )
      )

      DateWrapComponent(
        configuration: .init(
          dayText: "3",
          isToday: true,
          normalTextColor: .semantic.Content.contentPrimary,
          todayBackgroundColor: .primitives.gray500,
          todayTextColor: .semanticExtensions.Content.contentOnColor
        )
      )
    }
    .padding()
    .frame(width: 80)
  }
#endif
