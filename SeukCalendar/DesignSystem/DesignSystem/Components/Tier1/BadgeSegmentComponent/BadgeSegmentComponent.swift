import SwiftUI

public struct BadgeSegmentComponent: View {
  private enum Metrics {
    static let height: CGFloat = 14
    static let stripWidth: CGFloat = 2
    static let stripHeight: CGFloat = 10
    static let cornerRadius = Radius.rds100 / 2
  }

  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  public var body: some View {
    HStack(spacing: Spacing.sp100) {
      if configuration.showsLeadingStrip {
        RoundedRectangle(cornerRadius: 1, style: .continuous)
          .fill(configuration.foregroundColor)
          .frame(width: Metrics.stripWidth, height: Metrics.stripHeight)
      }

      if let label = configuration.trimmedLabel {
        Text(label)
          .font(.homeCalendar(weight: .medium, size: 8))
          .foregroundStyle(configuration.foregroundColor)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
      }

      Spacer(minLength: 0)
    }
    .padding(.horizontal, configuration.showsMetadata ? Spacing.sp050 : 0)
    .frame(
      maxWidth: .infinity,
      minHeight: Metrics.height,
      maxHeight: Metrics.height,
      alignment: .leading
    )
    .background(configuration.backgroundColor)
    .clipShape(
      UnevenRoundedRectangle(
        topLeadingRadius: configuration.variant.hasLeadingCorner ? Metrics.cornerRadius : 0,
        bottomLeadingRadius: configuration.variant.hasLeadingCorner ? Metrics.cornerRadius : 0,
        bottomTrailingRadius: configuration.variant.hasTrailingCorner ? Metrics.cornerRadius : 0,
        topTrailingRadius: configuration.variant.hasTrailingCorner ? Metrics.cornerRadius : 0,
        style: .continuous
      )
    )
  }
}

#if DEBUG
  #Preview {
    VStack(spacing: Spacing.sp100) {
      BadgeSegmentComponent(
        configuration: .init(
          variant: .startAndEnd,
          label: "하루 일정",
          foregroundColor: .primitives.teal800,
          backgroundColor: .primitives.green50,
          showsLeadingStrip: true
        )
      )

      HStack(spacing: 0) {
        BadgeSegmentComponent(
          configuration: .init(
            variant: .start,
            label: "연속 시작",
            foregroundColor: .primitives.blue700,
            backgroundColor: .primitives.blue100,
            showsLeadingStrip: true
          )
        )
        BadgeSegmentComponent(
          configuration: .init(
            variant: .middle,
            foregroundColor: .primitives.blue700,
            backgroundColor: .primitives.blue100
          )
        )
        BadgeSegmentComponent(
          configuration: .init(
            variant: .end,
            foregroundColor: .primitives.blue700,
            backgroundColor: .primitives.blue100
          )
        )
      }
    }
    .padding()
    .background(Color.semantic.Background.primary)
  }
#endif
