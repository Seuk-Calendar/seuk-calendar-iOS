import SwiftUI

public struct WidgetMediumComponent: View {
  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
    assert(configuration.dayCells.count == 7, "WidgetMediumComponent expects 7 day cells.")
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: Spacing.sp150) {
      WidgetTitleComponent(configuration: .init(title: configuration.title))

      VStack(alignment: .leading, spacing: Spacing.sp100) {
        WidgetWeekdayRowComponent(configuration: .init())

        divider

        HStack(alignment: .top, spacing: 0) {
          ForEach(Array(configuration.displayedDayCells.enumerated()), id: \.offset) { _, dayCell in
            WidgetDayCellComponent(configuration: dayCell)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension WidgetMediumComponent {
  var divider: some View {
    Rectangle()
      .fill(Color.semantic.Background.tertiary)
      .frame(height: 1)
  }
}

#if DEBUG
  #Preview {
    WidgetMediumComponent(
      configuration: .init(
        title: "2026년 3월 3일 화요일",
        dayCells: previewDayCells
      )
    )
    .padding()
  }

  private let previewDayCells: [WidgetDayCellComponent.Configuration] = {
    let baseDate = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2026, month: 3, day: 1)) ?? .now

    return [0, 1, 2, 3, 4, 5, 6].map { (index: Int) -> WidgetDayCellComponent.Configuration in
      let date = Calendar(identifier: .gregorian).date(byAdding: .day, value: index, to: baseDate) ?? baseDate

      return switch index {
      case 0:
        .init(
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
      case 2:
        .init(
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
      case 4:
        .init(
          date: date,
          isToday: false,
          dayTextColor: .semantic.Content.secondary,
          segments: [
            .init(
              variant: .middle,
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
      case 6:
        .init(
          date: date,
          isToday: false,
          dayTextColor: .semanticExtensions.Content.contentAccent,
          segments: [
            .init(
              variant: .end,
              foregroundColor: .primitives.blue700,
              backgroundColor: .primitives.blue100
            )
          ]
        )
      default:
        .init(
          date: date,
          isToday: false,
          dayTextColor: .semantic.Content.secondary
        )
      }
    }
  }()
#endif
