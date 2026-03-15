import DesignSystem
import Foundation
import SwiftUI
import WidgetKit

struct WidgetCalendarWeekdayHeader: View {
  private enum Metrics {
    static let weekdayFont = Widget.Large.medium
    static let weekdayHeight: CGFloat = 24
    static let dividerHeight: CGFloat = 0.5
  }

  let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
  }

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        ForEach(Array(configuration.weekdayItems.enumerated()), id: \.offset) { _, item in
          Text(item.title)
            .font(Metrics.weekdayFont)
            .foregroundStyle(item.role.foregroundColor)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .frame(height: Metrics.weekdayHeight)
            .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      divider
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .accessibilityElement(children: .combine)
  }
}

private extension WidgetCalendarWeekdayHeader {
  var divider: some View {
    Rectangle()
      .fill(Color.semantic.Background.secondary)
      .frame(maxWidth: .infinity)
      .frame(height: Metrics.dividerHeight)
  }
}

extension WidgetCalendarWeekdayHeader {
  struct Configuration: Hashable {
    let locale: Locale

    init(locale: Locale = Locale(identifier: "ko_KR")) {
      self.locale = locale
    }
  }
}

private extension WidgetCalendarWeekdayHeader.Configuration {
  struct WeekdayItem: Hashable {
    enum Role: Hashable {
      case sunday
      case weekday
      case saturday
    }

    let title: String
    let role: Role
  }

  var weekdayItems: [WeekdayItem] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = locale
    calendar.firstWeekday = 1

    return calendar.shortStandaloneWeekdaySymbols.enumerated().map { index, title in
      let role: WeekdayItem.Role
      switch index {
      case 0:
        role = .sunday
      case 6:
        role = .saturday
      default:
        role = .weekday
      }

      return WeekdayItem(title: title, role: role)
    }
  }
}

private extension WidgetCalendarWeekdayHeader.Configuration.WeekdayItem.Role {
  var foregroundColor: Color {
    switch self {
    case .sunday:
      .semanticExtensions.Content.contentNegative
    case .weekday:
      .semantic.Content.secondary
    case .saturday:
      .semanticExtensions.Content.contentAccent
    }
  }
}

#if DEBUG
  private struct WidgetCalendarWeekdayHeaderPreviewEntry: TimelineEntry {
    let date: Date
  }

  private struct WidgetCalendarWeekdayHeaderPreviewProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetCalendarWeekdayHeaderPreviewEntry {
      WidgetCalendarWeekdayHeaderPreviewEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetCalendarWeekdayHeaderPreviewEntry) -> Void) {
      completion(WidgetCalendarWeekdayHeaderPreviewEntry(date: .now))
    }

    func getTimeline(
      in context: Context,
      completion: @escaping (Timeline<WidgetCalendarWeekdayHeaderPreviewEntry>) -> Void
    ) {
      completion(
        Timeline(
          entries: [WidgetCalendarWeekdayHeaderPreviewEntry(date: .now)],
          policy: .never
        )
      )
    }
  }

  private struct WidgetCalendarWeekdayHeaderPreviewWidget: SwiftUI.Widget {
    var body: some SwiftUI.WidgetConfiguration {
      StaticConfiguration(
        kind: "WidgetCalendarWeekdayHeaderPreview",
        provider: WidgetCalendarWeekdayHeaderPreviewProvider()
      ) { _ in
        VStack(spacing: 0) {
          WidgetCalendarWeekdayHeader(configuration: .init())

          Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) {
          Color.semantic.Background.primary
        }
      }
      .configurationDisplayName("Widget Calendar Weekday Header Preview")
      .description("WidgetCalendarWeekdayHeader preview")
      .supportedFamilies([.systemLarge])
    }
  }

  #Preview("Widget Calendar Weekday Header", as: .systemLarge) {
    WidgetCalendarWeekdayHeaderPreviewWidget()
  } timeline: {
    WidgetCalendarWeekdayHeaderPreviewEntry(date: .now)
  }
#endif
