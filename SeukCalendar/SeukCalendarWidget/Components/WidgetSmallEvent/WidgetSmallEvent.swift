import DesignSystem
import SwiftUI
import WidgetKit

struct WidgetSmallEvent: View {
  @Environment(\.widgetRenderingMode) private var widgetRenderingMode

  private enum Metrics {
    static let labelFont = Widget.Large.medium
    static let dotSize: CGFloat = 4
    static let contentSpacing = Spacing.sp050

    static var rowHeight: CGFloat {
      labelFont.lineHeight
    }
  }

  let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
  }

  var body: some View {
    HStack(alignment: .center, spacing: Metrics.contentSpacing) {
      titleGroup

      if let timeText = configuration.trimmedTimeText {
        Spacer(minLength: Metrics.contentSpacing)

        Text(timeText)
          .font(Metrics.labelFont)
          .foregroundStyle(configuration.resolvedTimeColor(for: widgetRenderingMode))
          .lineLimit(1)
      }
    }
    .frame(maxWidth: .infinity, minHeight: Metrics.rowHeight, alignment: .leading)
    .accessibilityElement(children: .combine)
  }
}

private extension WidgetSmallEvent {
  var titleGroup: some View {
    HStack(alignment: .center, spacing: Metrics.contentSpacing) {
      Circle()
        .fill(configuration.resolvedDotColor(for: widgetRenderingMode))
        .frame(width: Metrics.dotSize, height: Metrics.dotSize)

      Text(configuration.trimmedTitle)
        .font(Metrics.labelFont)
        .foregroundStyle(configuration.resolvedTitleColor(for: widgetRenderingMode))
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#if DEBUG
  private struct WidgetSmallEventPreviewEntry: TimelineEntry {
    let date: Date
  }

  private struct WidgetSmallEventPreviewProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetSmallEventPreviewEntry {
      WidgetSmallEventPreviewEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetSmallEventPreviewEntry) -> Void) {
      completion(WidgetSmallEventPreviewEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetSmallEventPreviewEntry>) -> Void) {
      completion(
        Timeline(
          entries: [WidgetSmallEventPreviewEntry(date: .now)],
          policy: .never
        )
      )
    }
  }

  private struct WidgetSmallEventPreviewWidget: SwiftUI.Widget {
    var body: some SwiftUI.WidgetConfiguration {
      StaticConfiguration(
        kind: "WidgetSmallEventPreview",
        provider: WidgetSmallEventPreviewProvider()
      ) { _ in
        VStack(alignment: .leading, spacing: 32) {
          WidgetSmallEvent(
            configuration: .init(
              title: "일정 제목",
              timeText: "5:00 PM"
            )
          )

          WidgetSmallEvent(
            configuration: .init(
              title: "시작 시간 없는 일정 제목"
            )
          )

          Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) {
          Color.semantic.Background.primary
        }
      }
      .configurationDisplayName("Widget Small Event Preview")
      .description("WidgetSmallEvent preview")
      .supportedFamilies([.systemMedium])
    }
  }

  #Preview("Widget Small Event", as: .systemMedium) {
    WidgetSmallEventPreviewWidget()
  } timeline: {
    WidgetSmallEventPreviewEntry(date: .now)
  }
#endif
