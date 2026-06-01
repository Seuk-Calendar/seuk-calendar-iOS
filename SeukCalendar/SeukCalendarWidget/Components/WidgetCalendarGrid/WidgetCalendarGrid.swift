import DesignSystem
import Foundation
import SwiftUI
import WidgetKit

struct WidgetCalendarGrid: View {
  @Environment(\.widgetRenderingMode) private var widgetRenderingMode

  private enum Metrics {
    static let dividerHeight: CGFloat = 0.5
    static let supportedWeekCounts = 5 ... 6
  }

  let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
    assert(Metrics.supportedWeekCounts.contains(configuration.weeks.count), "WidgetCalendarGrid expects 5 or 6 weeks.")
    assert(configuration.weeks.allSatisfy { $0.count == 7 }, "WidgetCalendarGrid expects 7 day cells per week.")
  }

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(configuration.weeks.enumerated()), id: \.offset) { index, week in
        weekRow(week)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

        if index < configuration.weeks.count - 1 {
          divider
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

private extension WidgetCalendarGrid {
  func weekRow(_ week: [WidgetDayCell.Configuration]) -> some View {
    HStack(alignment: .top, spacing: 0) {
      ForEach(Array(week.enumerated()), id: \.offset) { _, dayCell in
        WidgetDayCell(configuration: dayCell)
          .frame(maxWidth: .infinity)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }

  var divider: some View {
    Rectangle()
      .fill(configuration.resolvedDividerColor(for: widgetRenderingMode))
      .frame(maxWidth: .infinity)
      .frame(height: Metrics.dividerHeight)
  }
}

#if DEBUG
  private struct WidgetCalendarGridPreviewEntry: TimelineEntry {
    let date: Date
  }

  private struct WidgetCalendarGridPreviewProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetCalendarGridPreviewEntry {
      WidgetCalendarGridPreviewEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetCalendarGridPreviewEntry) -> Void) {
      completion(WidgetCalendarGridPreviewEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetCalendarGridPreviewEntry>) -> Void) {
      completion(
        Timeline(
          entries: [WidgetCalendarGridPreviewEntry(date: .now)],
          policy: .never
        )
      )
    }
  }

  private struct WidgetCalendarGridPreviewWidget: SwiftUI.Widget {
    private static var calendar: Calendar {
      var calendar = Calendar(identifier: .gregorian)
      calendar.locale = Locale(identifier: "ko_KR")
      calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
      calendar.firstWeekday = 1
      return calendar
    }

    private var previewBadges: [WidgetBadge.Configuration] {
      [
        .init(state: .allDay, title: "하루 일정"),
        .init(state: .allDay, title: "하루 일정"),
      ]
    }

    private var previewMonthDate: Date {
      Self.calendar.date(from: DateComponents(year: 2026, month: 5, day: 12)) ?? .now
    }

    private var previewWeeks: [[WidgetDayCell.Configuration]] {
      previewWeekDates.map { week in
        week.map { date in
          WidgetDayCell.Configuration(
            dayNumber: String(Self.calendar.component(.day, from: date)),
            state: dayCellState(for: date),
            isToday: Self.calendar.isDate(date, inSameDayAs: previewMonthDate),
            badgeSlots: previewBadges,
            moreCount: 2
          )
        }
      }
    }

    private var previewWeekDates: [[Date]] {
      let monthStart = Self.calendar.dateInterval(of: .month, for: previewMonthDate)?.start ?? previewMonthDate
      let monthEnd = Self.calendar.dateInterval(of: .month, for: previewMonthDate)?.end ?? previewMonthDate
      let gridStart = Self.calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart
      let lastMonthDate = Self.calendar.date(byAdding: .day, value: -1, to: monthEnd) ?? monthStart
      let gridEnd = Self.calendar.dateInterval(of: .weekOfYear, for: lastMonthDate)?.end ?? monthEnd
      let dayCount = Self.calendar.dateComponents([.day], from: gridStart, to: gridEnd).day ?? 0
      let weekCount = min(max((dayCount + 6) / 7, 5), 6)

      return (0 ..< weekCount).map { weekOffset in
        (0 ..< 7).compactMap { dayOffset in
          let offset = (weekOffset * 7) + dayOffset
          return Self.calendar.date(byAdding: .day, value: offset, to: gridStart)
        }
      }
    }

    var body: some SwiftUI.WidgetConfiguration {
      StaticConfiguration(
        kind: "WidgetCalendarGridPreview",
        provider: WidgetCalendarGridPreviewProvider()
      ) { _ in
        WidgetCalendarGrid(
          configuration: .init(weeks: previewWeeks)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) {
          Color.semantic.Background.primary
        }
      }
      .configurationDisplayName("Widget Calendar Grid Preview")
      .description("WidgetCalendarGrid preview")
      .supportedFamilies([.systemLarge])
    }
  }

  private extension WidgetCalendarGridPreviewWidget {
    func dayCellState(for date: Date) -> WidgetDayCell.Configuration.State {
      if !Self.calendar.isDate(date, equalTo: previewMonthDate, toGranularity: .month) {
        return .otherMonth
      }

      switch Self.calendar.component(.weekday, from: date) {
      case 1:
        return .holiday
      case 7:
        return .saturday
      default:
        return .default
      }
    }
  }

  #Preview("Widget Calendar Grid", as: .systemLarge) {
    WidgetCalendarGridPreviewWidget()
  } timeline: {
    WidgetCalendarGridPreviewEntry(date: .now)
  }
#endif
