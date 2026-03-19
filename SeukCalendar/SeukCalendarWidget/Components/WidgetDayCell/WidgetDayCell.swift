import DesignSystem
import SwiftUI
import WidgetKit

struct WidgetDayCell: View {
  @Environment(\.widgetRenderingMode) private var widgetRenderingMode

  private enum Metrics {
    static var dayNumberFont: any FontStyleType {
      return Platform.isMac ? Widget.Large.medium : Widget.Large.large
    }

    static let moreNumberFont = Widget.Large.small
    static let rowSpacing = Spacing.sp050
    static let badgeSpacing = Spacing.sp050
    static let outerHorizontalPadding: CGFloat = .zero
    static let todayCornerRadius = Radius.rds100

    static var badgeRowHeight: CGFloat {
      moreNumberFont.lineHeight
    }

    static var moreNumberRowHeight: CGFloat {
      moreNumberFont.lineHeight
    }

    static var dayNumberHeight: CGFloat {
      dayNumberFont.lineHeight
    }

    static var estimatedHeight: CGFloat {
      dayNumberHeight
        + (badgeRowHeight * 2)
        + (rowSpacing * 3)
        + moreNumberRowHeight
    }
  }

  let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
  }

  var body: some View {
    content
      .padding(.horizontal, Metrics.outerHorizontalPadding)
      .frame(
        maxWidth: .infinity,
        minHeight: Metrics.estimatedHeight,
        alignment: .top
      )
      .background(backgroundShape)
      .accessibilityElement(children: .combine)
  }
}

private extension WidgetDayCell {
  var content: some View {
    VStack(spacing: Metrics.rowSpacing) {
      dayNumberText

      VStack(alignment: .leading, spacing: Metrics.badgeSpacing) {
        badgeSlot(at: 0)
        badgeSlot(at: 1)
      }

      moreNumberText
    }
  }

  var dayNumberText: some View {
    Text(configuration.dayNumber)
      .font(Metrics.dayNumberFont)
      .foregroundStyle(configuration.resolvedDayNumberColor(for: widgetRenderingMode))
      .lineLimit(1)
      .minimumScaleFactor(0.8)
      .frame(minHeight: Metrics.dayNumberHeight, alignment: .center)
  }

  @ViewBuilder
  func badgeSlot(at index: Int) -> some View {
    if configuration.resolvedBadgeSlots.indices.contains(index),
       let badgeConfiguration = configuration.resolvedBadgeSlots[index] {
      WidgetBadge(configuration: badgeConfiguration)
    } else {
      Color.clear
        .frame(maxWidth: .infinity)
        .frame(height: Metrics.badgeRowHeight)
    }
  }

  @ViewBuilder
  var moreNumberText: some View {
    if let moreNumberText = configuration.moreNumberText {
      Text(moreNumberText)
        .font(Metrics.moreNumberFont)
        .foregroundStyle(configuration.resolvedMoreNumberColor(for: widgetRenderingMode))
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(minHeight: Metrics.moreNumberRowHeight, alignment: .center)
    } else {
      Color.clear
        .frame(maxWidth: .infinity)
        .frame(height: Metrics.moreNumberRowHeight)
    }
  }

  @ViewBuilder
  var backgroundShape: some View {
    if let backgroundColor = configuration.resolvedBackgroundColor(for: widgetRenderingMode) {
      RoundedRectangle(cornerRadius: Metrics.todayCornerRadius)
        .fill(backgroundColor)
    }
  }
}

#if DEBUG
  private struct WidgetDayCellPreviewEntry: TimelineEntry {
    let date: Date
  }

  private struct WidgetDayCellPreviewProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetDayCellPreviewEntry {
      WidgetDayCellPreviewEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetDayCellPreviewEntry) -> Void) {
      completion(WidgetDayCellPreviewEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetDayCellPreviewEntry>) -> Void) {
      completion(
        Timeline(
          entries: [WidgetDayCellPreviewEntry(date: .now)],
          policy: .never
        )
      )
    }
  }

  private struct WidgetDayCellPreviewWidget: SwiftUI.Widget {
    private let previewBadges: [WidgetBadge.Configuration] = [
      .init(
        state: .allDay,
        title: "하루 일정"
      ),
      .init(
        state: .allDay,
        title: "하루 일정"
      ),
    ]

    private var previewConfigurations: [WidgetDayCell.Configuration] {
      [
        .init(
          dayNumber: "20",
          state: .default,
          badgeSlots: previewBadges,
          moreCount: 2
        ),
        .init(
          dayNumber: "21",
          state: .default,
          isToday: true,
          badgeSlots: previewBadges,
          moreCount: 2
        ),
        .init(
          dayNumber: "22",
          state: .saturday,
          badgeSlots: [.init(state: .allDay, title: "하루 일정")]
        ),
        .init(
          dayNumber: "23",
          state: .saturday,
          isToday: true,
          badgeSlots: previewBadges,
          moreCount: 2
        ),
        .init(
          dayNumber: "24",
          state: .holiday
        ),
        .init(
          dayNumber: "25",
          state: .holiday,
          isToday: true,
          badgeSlots: previewBadges,
          moreCount: 2
        ),
        .init(
          dayNumber: "26",
          state: .otherMonth,
          badgeSlots: previewBadges,
          moreCount: 2
        ),
      ]
    }

    var body: some SwiftUI.WidgetConfiguration {
      StaticConfiguration(
        kind: "WidgetDayCellPreview",
        provider: WidgetDayCellPreviewProvider()
      ) { _ in
        HStack(alignment: .top, spacing: 0) {
          ForEach(Array(previewConfigurations.enumerated()), id: \.offset) { _, configuration in
            WidgetDayCell(configuration: configuration)
              .frame(maxWidth: .infinity)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .containerBackground(for: .widget) {
          Color.semantic.Background.primary
        }
      }
      .configurationDisplayName("Widget Day Cell Preview")
      .description("WidgetDayCell preview")
      .supportedFamilies([.systemLarge])
    }
  }

  #Preview("Widget Day Cell", as: .systemLarge) {
    WidgetDayCellPreviewWidget()
  } timeline: {
    WidgetDayCellPreviewEntry(date: .now)
  }
#endif
