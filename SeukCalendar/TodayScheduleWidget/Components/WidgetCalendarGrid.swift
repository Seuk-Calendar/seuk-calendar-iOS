import DesignSystem
import Foundation
import SwiftUI
import WidgetKit

struct WidgetCalendarGrid: View {
  private enum Metrics {
    static let dividerHeight: CGFloat = 0.5
  }

  let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
    assert(configuration.weeks.count == 5, "WidgetCalendarGrid expects 5 weeks.")
    assert(configuration.weeks.allSatisfy { $0.count == 7 }, "WidgetCalendarGrid expects 7 day cells per week.")
  }

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(configuration.weeks.enumerated()), id: \.offset) { index, week in
        VStack(spacing: 0) {
          weekRow(week)

          Spacer(minLength: 0)
        }
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
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var divider: some View {
    Rectangle()
      .fill(Color.semantic.Background.secondary)
      .frame(maxWidth: .infinity)
      .frame(height: Metrics.dividerHeight)
  }
}

extension WidgetCalendarGrid {
  struct Configuration: Hashable {
    let weeks: [[WidgetDayCell.Configuration]]

    init(weeks: [[WidgetDayCell.Configuration]]) {
      self.weeks = weeks
    }
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
      return calendar
    }

    private var previewBadges: [WidgetBadge.Configuration] {
      [
        .init(state: .allDay, title: "하루 일정"),
        .init(state: .allDay, title: "하루 일정"),
      ]
    }

    private var previewMonthDate: Date {
      Self.calendar.date(from: DateComponents(year: 2026, month: 3, day: 12)) ?? .now
    }

    private var previewWeeks: [[WidgetDayCell.Configuration]] {
      let monthStart = Self.calendar.dateInterval(of: .month, for: previewMonthDate)?.start ?? previewMonthDate
      let gridStart = Self.calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart

      return (0 ..< 5).map { weekOffset in
        (0 ..< 7).compactMap { dayOffset in
          let offset = (weekOffset * 7) + dayOffset
          guard let date = Self.calendar.date(byAdding: .day, value: offset, to: gridStart) else {
            return nil
          }

          return WidgetDayCell.Configuration(
            dayNumber: String(Self.calendar.component(.day, from: date)),
            state: dayCellState(for: date),
            isToday: Self.calendar.isDate(date, inSameDayAs: previewMonthDate),
            badges: previewBadges,
            moreCount: 2
          )
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
