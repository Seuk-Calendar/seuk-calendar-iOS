import DesignSystem
import SwiftUI
import WidgetKit

struct SeukCalendarWidgetEntryView: View {
  @Environment(\.widgetFamily) private var family
  @Environment(\.redactionReasons) private var redactionReasons

  let entry: SeukCalendarEntry

  let calendar = WidgetCalendarFactory.calendar

  var body: some View {
    Group {
      switch family {
      case .systemSmall:
        smallView
      case .systemMedium:
        mediumView
      case .systemLarge:
        largeView
      case .systemExtraLarge:
        largeView
      case .accessoryCircular:
        circularView
      case .accessoryRectangular:
        rectangularView
      case .accessoryInline:
        inlineView
      @unknown default:
        mediumView
      }
    }
    .unredactedIf(showsUnredactedPlaceholder)
  }
}

private extension SeukCalendarWidgetEntryView {
  var showsUnredactedPlaceholder: Bool {
    entry.showsPlaceholderPreview && redactionReasons == .placeholder
  }

  var smallView: some View {
    VStack(alignment: .leading, spacing: Spacing.sp250) {
      VStack(alignment: .leading, spacing: Spacing.sp050) {
        Text("오늘")
          .font(Widget.Large.xLarge)
          .foregroundStyle(Color.semantic.Content.primary)

        Text(smallHeaderDateText)
          .font(Widget.Large.medium)
          .foregroundStyle(Color.primitives.gray500)
      }

      if smallVisibleEvents.isEmpty {
        Text("등록된 일정이 없습니다")
          .font(Widget.Large.medium)
          .foregroundStyle(Color.primitives.gray500)
          .lineLimit(1)
      } else {
        VStack(alignment: .leading, spacing: Spacing.sp250) {
          ForEach(smallVisibleEvents) { event in
            WidgetSmallEvent(
              configuration: smallEventConfiguration(for: event)
            )
          }

          if smallRemainingCount > 0 {
            Text("+\(smallRemainingCount)")
              .font(Widget.Large.medium)
              .foregroundStyle(Color.primitives.gray500)
              .lineLimit(1)
          }
        }
      }

      Spacer(minLength: 0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      Color.semantic.Background.primary
    }
  }

  var mediumView: some View {
    VStack(alignment: .leading, spacing: Spacing.sp050) {
      Text(widgetTitleText)
        .font(Platform.isMac ? Widget.Large.xLargeMac : Widget.Large.xLarge)
        .foregroundStyle(Color.semantic.Content.primary)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .frame(maxWidth: .infinity, alignment: .leading)

      WidgetCalendarWeekdayHeader(configuration: weekdayHeaderConfiguration)

      HStack(alignment: .top, spacing: 0) {
        ForEach(Array(mediumCalendarWeek.enumerated()), id: \.offset) { _, dayCell in
          WidgetDayCell(configuration: dayCell)
            .frame(maxWidth: .infinity)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Spacer(minLength: 0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      Color.semantic.Background.primary
    }
  }

  var largeView: some View {
    VStack(alignment: .leading, spacing: Spacing.sp050) {
      Text(widgetTitleText)
        .font(Platform.isMac ? Widget.Large.xLargeMac : Widget.Large.xLarge)
        .foregroundStyle(Color.semantic.Content.primary)
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)

      WidgetCalendarWeekdayHeader(configuration: weekdayHeaderConfiguration)

      WidgetCalendarGrid(
        configuration: .init(weeks: largeCalendarWeeks)
      )
      .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      Color.semantic.Background.primary
    }
  }

  var circularView: some View {
    ZStack {
      AccessoryWidgetBackground()
      VStack(spacing: 2) {
        Image(systemName: "calendar")
          .font(.system(size: 12, weight: .semibold))
        Text("\(remainingTodayCount)")
          .font(.system(size: 14, weight: .bold))
      }
    }
    .containerBackground(for: .widget) {
      Color.clear
    }
    #if !os(macOS)
    .widgetLabel {
      Text("남은 일정 \(remainingTodayCount)개")
    }
    #endif
  }

  var rectangularView: some View {
    VStack(alignment: .leading, spacing: 2) {
      if upcomingTodayEvents.isEmpty {
        Text("- 일정 없음")
          .font(.system(size: 12, weight: .semibold))
          .lineLimit(1)
      } else {
        ForEach(upcomingTodayEvents.prefix(2)) { event in
          Text("- \(event.title) \(timeText(for: event))")
            .font(.system(size: 12, weight: .semibold))
            .lineLimit(1)
            .multilineTextAlignment(.leading)
        }

        if upcomingTodayEvents.count > 2 {
          Text("- ...")
            .font(.system(size: 12, weight: .semibold))
            .lineLimit(1)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      Color.clear
    }
  }

  var inlineView: some View {
    Group {
      if let nextEvent {
        Text("\(timeText(for: nextEvent)) \(nextEvent.title)")
      } else {
        Text("오늘 일정 없음")
      }
    }
    .containerBackground(for: .widget) {
      Color.clear
    }
  }
}

private extension View {
  @ViewBuilder
  func unredactedIf(_ condition: Bool) -> some View {
    if condition {
      unredacted()
    } else {
      self
    }
  }
}
