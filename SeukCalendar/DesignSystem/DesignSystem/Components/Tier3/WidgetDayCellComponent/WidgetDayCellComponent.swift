import SwiftUI

public struct WidgetDayCellComponent: View {
  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  public var body: some View {
    VStack(alignment: .center, spacing: Spacing.sp050) {
      DateWrapComponent(
        configuration: .init(
          dayText: configuration.dayText,
          isToday: configuration.isToday,
          normalTextColor: configuration.dayTextColor,
          todayBackgroundColor: .primitives.gray500,
          todayTextColor: .semanticExtensions.Content.contentOnColor
        )
      )

      ForEach(Array(configuration.visibleSegments.enumerated()), id: \.offset) { _, segment in
        BadgeSegmentComponent(configuration: segment)
      }

      MoreWrapComponent(configuration: .init(count: configuration.resolvedOverflowCount))
    }
    .padding(.top, Spacing.sp100)
    .frame(maxWidth: .infinity, alignment: .top)
  }
}

#if DEBUG
  #Preview {
    VStack(spacing: Spacing.sp500) {
      WidgetDayCellComponent(
        configuration: .init(
          date: Date(),
          isToday: true,
          dayTextColor: .semantic.Content.contentPrimary,
          segments: [
            .init(
              variant: .start,
              label: "연속 시작",
              foregroundColor: .primitives.blue700,
              backgroundColor: .primitives.blue100,
              showsLeadingStrip: true
            ),
            .init(
              variant: .startAndEnd,
              label: "하루 일정",
              foregroundColor: .primitives.teal800,
              backgroundColor: .primitives.green50,
              showsLeadingStrip: true
            )
          ],
          overflowCount: 2
        )
      )
      .frame(width: 120)

      WidgetDayCellComponent(
        configuration: .init(
          date: Date(),
          isToday: false,
          dayTextColor: .semantic.Content.contentSecondary
        )
      )
      .frame(width: 120)
    }
    .padding()
  }
#endif
