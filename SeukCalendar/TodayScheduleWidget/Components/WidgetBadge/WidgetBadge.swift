import DesignSystem
import SwiftUI
import WidgetKit

struct WidgetBadge: View {
  @Environment(\.widgetRenderingMode) private var widgetRenderingMode

  private enum Metrics {
    static let labelFont = Widget.Large.small
    static let segmentCornerRadius: CGFloat = Radius.rds050
    static let contentSpacing = Spacing.sp050
    static let dotSpacing = Spacing.sp050
    static let dotSize: CGFloat = 4
    static let stripWidth: CGFloat = 2
    static var segmentHeight: CGFloat {
      labelFont.lineHeight
    }
  }

  let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
  }

  var body: some View {
    Group {
      switch configuration.state {
      case .allDay:
        allDayBadge
      case .start, .middle, .end:
        segmentBadge
      }
    }
    .accessibilityElement(children: .combine)
  }
}

private extension WidgetBadge {
  var allDayBadge: some View {
    HStack(spacing: Metrics.dotSpacing) {
      Circle()
        .fill(configuration.resolvedIndicatorColor(for: widgetRenderingMode))
        .frame(width: Metrics.dotSize, height: Metrics.dotSize)

      if let title = configuration.trimmedTitle {
        badgeTitle(title)
      }
    }
  }

  var segmentBadge: some View {
    HStack(spacing: Metrics.contentSpacing) {
      if configuration.showsLeadingStrip {
        Capsule()
          .fill(configuration.resolvedIndicatorColor(for: widgetRenderingMode))
          .frame(width: Metrics.stripWidth)
      }

      if let title = configuration.trimmedTitle {
        badgeTitle(title)
      }

      Spacer(minLength: 0)
    }
    .frame(height: Metrics.segmentHeight)
    .background(configuration.resolvedBackgroundColor(for: widgetRenderingMode))
    .clipShape(
      UnevenRoundedRectangle(
        topLeadingRadius: configuration.hasLeadingCorner ? Metrics.segmentCornerRadius : 0,
        bottomLeadingRadius: configuration.hasLeadingCorner ? Metrics.segmentCornerRadius : 0,
        bottomTrailingRadius: configuration.hasTrailingCorner ? Metrics.segmentCornerRadius : 0,
        topTrailingRadius: configuration.hasTrailingCorner ? Metrics.segmentCornerRadius : 0,
        style: .continuous
      )
    )
  }

  @ViewBuilder
  func badgeTitle(_ title: String) -> some View {
    Text(title)
      .font(Metrics.labelFont)
      .foregroundStyle(configuration.resolvedTextColor(for: widgetRenderingMode))
      .lineLimit(1)
  }
}

#if DEBUG
  private struct WidgetBadgePreviewEntry: TimelineEntry {
    let date: Date
  }

  private struct WidgetBadgePreviewProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetBadgePreviewEntry {
      WidgetBadgePreviewEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetBadgePreviewEntry) -> Void) {
      completion(WidgetBadgePreviewEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetBadgePreviewEntry>) -> Void) {
      completion(
        Timeline(
          entries: [WidgetBadgePreviewEntry(date: .now)],
          policy: .never
        )
      )
    }
  }

  private struct WidgetBadgePreviewWidget: SwiftUI.Widget {
    var body: some SwiftUI.WidgetConfiguration {
      StaticConfiguration(
        kind: "WidgetBadgePreview",
        provider: WidgetBadgePreviewProvider()
      ) { _ in
        HStack(alignment: .top, spacing: Spacing.sp1200) {
          VStack(alignment: .leading, spacing: 6) {
            WidgetBadge(
              configuration: .init(
                state: .allDay,
                title: "하루 일정"
              )
            )

            WidgetBadge(
              configuration: .init(
                state: .start,
                title: "연속 시작"
              )
            )

            WidgetBadge(
              configuration: .init(state: .middle)
            )

            WidgetBadge(
              configuration: .init(state: .end)
            )
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 16)
          .overlay {
            RoundedRectangle(cornerRadius: Radius.rds600, style: .continuous)
              .stroke(
                Color.primitives.purple500,
                style: StrokeStyle(lineWidth: 2, dash: [16, 10])
              )
          }

          WidgetBadge(
            configuration: .init(
              state: .allDay,
              title: "하루 일정"
            )
          )
          .padding(.top, Spacing.sp350)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .containerBackground(for: .widget) {
          Color.semantic.Background.primary
        }
      }
      .configurationDisplayName("Widget Badge Preview")
      .description("WidgetBadge preview")
      .supportedFamilies([.systemMedium])
    }
  }

  #Preview("Widget Badge", as: .systemLarge) {
    WidgetBadgePreviewWidget()
  } timeline: {
    WidgetBadgePreviewEntry(date: .now)
  }
#endif
