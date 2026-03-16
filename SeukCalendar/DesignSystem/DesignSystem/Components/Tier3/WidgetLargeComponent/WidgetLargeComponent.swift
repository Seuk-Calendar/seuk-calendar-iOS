import SwiftUI

public struct WidgetLargeComponent: View {
  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
    assert(configuration.weeks.count == 5, "WidgetLargeComponent expects 5 weeks.")
    assert(configuration.weeks.allSatisfy { $0.count == 7 }, "WidgetLargeComponent expects 7 day cells per week.")
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: Spacing.sp150) {
      WidgetTitleComponent(configuration: .init(title: configuration.title))

      VStack(alignment: .leading, spacing: Spacing.sp100) {
        WidgetWeekdayRowComponent(configuration: .init())

        divider

        VStack(spacing: 0) {
          ForEach(Array(configuration.visibleWeeks.enumerated()), id: \.offset) { index, week in
            HStack(alignment: .top, spacing: 0) {
              ForEach(Array(week.enumerated()), id: \.offset) { _, dayCell in
                if let dayCell {
                  WidgetDayCellComponent(configuration: dayCell)
                } else {
                  emptyDayCell
                }
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if index < configuration.visibleWeeks.count - 1 {
              divider
            }
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension WidgetLargeComponent {
  var divider: some View {
    Rectangle()
      .fill(Color.semantic.Background.tertiary)
      .frame(height: 1)
  }

  var emptyDayCell: some View {
    Color.clear
      .frame(maxWidth: .infinity)
      .frame(
        minHeight: WidgetDayCellComponent.fixedHeight,
        maxHeight: WidgetDayCellComponent.fixedHeight,
        alignment: .top
      )
      .allowsHitTesting(false)
  }
}

#if DEBUG
  #Preview {
    WidgetLargeComponent(
      configuration: .init(
        title: "2026년 3월 3일 화요일",
        weeks: previewWeeks
      )
    )
    .padding()
  }

  private let previewWeeks: [[WidgetDayCellComponent.Configuration]] = {
    let calendar = Calendar(identifier: .gregorian)
    let baseDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 1)) ?? .now

    return [0, 1, 2, 3, 4].map { (weekIndex: Int) -> [WidgetDayCellComponent.Configuration] in
      [0, 1, 2, 3, 4, 5, 6].map { (dayIndex: Int) -> WidgetDayCellComponent.Configuration in
        let offset = weekIndex * 7 + dayIndex
        let date = calendar.date(byAdding: .day, value: offset, to: baseDate) ?? baseDate

        if weekIndex == 0, dayIndex == 0 {
          return .init(
            date: date,
            isToday: false,
            dayTextColor: .semanticExtensions.Content.contentNegative,
            segments: [
              .init(
                variant: .startAndEnd,
                label: "하루 일정",
                foregroundColor: .primitives.teal800,
                backgroundColor: .primitives.green50,
                showsLeadingStrip: true
              )
            ]
          )
        }

        if weekIndex == 0, dayIndex == 2 {
          return .init(
            date: date,
            isToday: true,
            dayTextColor: .semantic.Content.primary,
            segments: [
              .init(
                variant: .start,
                label: "연속 시작",
                foregroundColor: .primitives.blue700,
                backgroundColor: .primitives.blue100,
                showsLeadingStrip: true
              )
            ]
          )
        }

        if weekIndex == 0, dayIndex == 3 {
          return .init(
            date: date,
            isToday: false,
            dayTextColor: .semantic.Content.secondary,
            segments: [
              .init(
                variant: .middle,
                foregroundColor: .primitives.blue700,
                backgroundColor: .primitives.blue100
              )
            ]
          )
        }

        if weekIndex == 0, dayIndex == 4 {
          return .init(
            date: date,
            isToday: false,
            dayTextColor: .semantic.Content.secondary,
            segments: [
              .init(
                variant: .end,
                foregroundColor: .primitives.blue700,
                backgroundColor: .primitives.blue100
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
        }

        return .init(
          date: date,
          isToday: false,
          dayTextColor: dayIndex == 0
            ? .semanticExtensions.Content.contentNegative
            : dayIndex == 6
            ? .semanticExtensions.Content.contentAccent
            : .semantic.Content.secondary
        )
      }
    }
  }()
#endif
