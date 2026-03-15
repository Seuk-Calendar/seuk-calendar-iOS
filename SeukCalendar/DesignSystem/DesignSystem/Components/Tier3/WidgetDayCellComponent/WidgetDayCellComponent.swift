import SwiftUI

public struct WidgetDayCellComponent: View {
  private enum Metrics {
    static let topPadding: CGFloat = 0
    static let rowSpacing = Spacing.sp050
    static let dateHeight: CGFloat = 24
    static let badgeHeight: CGFloat = 14
    static let moreWrapHeight: CGFloat = 8
  }

  static let fixedHeight: CGFloat =
    Metrics.topPadding
      + Metrics.dateHeight
      + (Metrics.badgeHeight * 2)
      + Metrics.moreWrapHeight
      + (Metrics.rowSpacing * 3)

  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  public var body: some View {
    VStack(alignment: .center, spacing: Metrics.rowSpacing) {
      dateWrap
      badgeSlot(at: 0)
      badgeSlot(at: 1)
      moreWrapSlot
    }
    .padding(.top, Metrics.topPadding)
    .frame(
      maxWidth: .infinity,
      minHeight: Self.fixedHeight,
      maxHeight: Self.fixedHeight,
      alignment: .top
    )
  }
}

private extension WidgetDayCellComponent {
  var dateWrap: some View {
    DateWrapComponent(
      configuration: .init(
        dayText: configuration.dayText,
        isToday: configuration.isToday,
        normalTextColor: configuration.dayTextColor,
        todayBackgroundColor: .primitives.gray500,
        todayTextColor: .semanticExtensions.Content.contentOnColor
      )
    )
    .frame(height: Metrics.dateHeight)
  }

  @ViewBuilder
  func badgeSlot(at index: Int) -> some View {
    if configuration.visibleSegments.indices.contains(index) {
      BadgeSegmentComponent(configuration: configuration.visibleSegments[index])
    } else {
      Color.clear
        .frame(maxWidth: .infinity)
        .frame(height: Metrics.badgeHeight)
    }
  }

  @ViewBuilder
  var moreWrapSlot: some View {
    if configuration.resolvedOverflowCount > 0 {
      MoreWrapComponent(configuration: .init(count: configuration.resolvedOverflowCount))
        .frame(height: Metrics.moreWrapHeight)
    } else {
      Color.clear
        .frame(maxWidth: .infinity)
        .frame(height: Metrics.moreWrapHeight)
    }
  }
}

#if DEBUG
  #Preview {
    VStack(spacing: Spacing.sp500) {
      WidgetDayCellComponent(
        configuration: .init(
          date: Date(),
          isToday: true,
          dayTextColor: .semantic.Content.primary,
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
          dayTextColor: .semantic.Content.secondary
        )
      )
      .frame(width: 120)
    }
    .padding()
  }
#endif
