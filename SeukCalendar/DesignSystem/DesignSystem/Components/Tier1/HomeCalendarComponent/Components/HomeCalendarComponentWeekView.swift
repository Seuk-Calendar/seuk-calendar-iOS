import SwiftUI
import UIKit

struct HomeCalendarComponentWeekView: View {
  @State private var pressedDayID: String?

  let week: HomeCalendarComponent.Configuration.Week
  let eventListener: HomeCalendarComponent.EventListener?

  var body: some View {
    if usesLegacyLayout {
      legacyWeekView
    } else {
      spanningWeekView
    }
  }
}

private extension HomeCalendarComponentWeekView {
  static let dayNumberRowHeight: CGFloat = 20
  static let hiddenBadgeCountRowHeight: CGFloat = 8
  static var layoutHeight: CGFloat {
    dayNumberRowHeight
      + CGFloat(HomeCalendarConfigurationBuilder.maxVisibleBadgeRows) * HomeCalendarComponentBadge.layoutHeight
      + hiddenBadgeCountRowHeight
      + CGFloat(HomeCalendarConfigurationBuilder.maxVisibleBadgeRows + 1) * Spacing.sp100
  }

  var usesLegacyLayout: Bool {
    week.badgeRows.isEmpty && week.days.contains { !$0.badges.isEmpty || $0.hiddenBadgeCount > 0 }
  }

  var legacyWeekView: some View {
    HStack(alignment: .top, spacing: 0) {
      ForEach(week.days) { day in
        HomeCalendarComponentDayCell(
          day: day,
          showsBadges: true,
          action: {
            eventListener?(.tapDate(day.date))
          }
        )
      }
    }
  }

  var spanningWeekView: some View {
    gridContent
      .frame(
        maxWidth: .infinity,
        minHeight: Self.layoutHeight,
        maxHeight: Self.layoutHeight,
        alignment: .top
      )
      .allowsHitTesting(false)
      .background(selectionBackground)
      .overlay(dayTapOverlay)
  }

  var gridContent: some View {
    Grid(horizontalSpacing: 0, verticalSpacing: Spacing.sp100) {
      GridRow {
        ForEach(week.days) { day in
          HomeCalendarComponentDayCell(
            day: day,
            showsBadges: false,
            isPressed: pressedDayID == day.id,
            action: {}
          )
        }
      }

      ForEach(displayedBadgeRows) { row in
        GridRow {
          ForEach(layoutItems(for: row)) { item in
            if let segment = item.segment {
              HomeCalendarComponentBadge(
                badge: segment.badge,
                position: segment.position
              )
              .gridCellColumns(item.span)
            } else {
              Color.clear
                .frame(height: HomeCalendarComponentBadge.layoutHeight)
                .gridCellColumns(item.span)
            }
          }
        }
      }

      GridRow {
        ForEach(week.days) { day in
          hiddenBadgeCountView(for: day)
        }
      }
    }
  }

  var selectionBackground: some View {
    HStack(spacing: 0) {
      ForEach(week.days) { day in
        Group {
          if day.isSelected {
            RoundedRectangle(cornerRadius: Radius.rds250, style: .continuous)
              .fill(Color.semantic.Background.backgroundTertiary)
          } else {
            Color.clear
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }

  var dayTapOverlay: some View {
    HStack(spacing: 0) {
      ForEach(week.days) { day in
        Button {
          tapDate(day)
        } label: {
          Color.clear
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .buttonStyle(.plain)
        .simultaneousGesture(
          DragGesture(minimumDistance: 0)
            .onChanged { _ in
              pressedDayID = day.id
            }
            .onEnded { _ in
              pressedDayID = nil
            }
        )
      }
    }
  }

  var displayedBadgeRows: [HomeCalendarComponent.Configuration.BadgeRow] {
    let placeholderCount = max(HomeCalendarConfigurationBuilder.maxVisibleBadgeRows - week.badgeRows.count, 0)
    let placeholders = (0 ..< placeholderCount).map { index in
      HomeCalendarComponent.Configuration.BadgeRow(
        id: "placeholder-\(week.id)-\(index)",
        segments: []
      )
    }

    return Array((week.badgeRows + placeholders).prefix(HomeCalendarConfigurationBuilder.maxVisibleBadgeRows))
  }

  func hiddenBadgeCountView(for day: HomeCalendarComponent.Configuration.Day) -> some View {
    Group {
      if day.hiddenBadgeCount > 0 {
        Text("+\(day.hiddenBadgeCount)")
          .font(.homeCalendar(weight: .semiBold, size: 8))
          .foregroundStyle(Color.primitives.gray600)
          .lineLimit(1)
          .minimumScaleFactor(0.8)
          .padding(.horizontal, Spacing.sp050)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
      } else {
        Color.clear
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .frame(height: Self.hiddenBadgeCountRowHeight)
  }

  func layoutItems(
    for row: HomeCalendarComponent.Configuration.BadgeRow
  ) -> [BadgeLayoutItem] {
    var items: [BadgeLayoutItem] = []
    var currentIndex = 0

    for segment in row.segments.sorted(by: { $0.startIndex < $1.startIndex }) {
      if segment.startIndex > currentIndex {
        items.append(
          BadgeLayoutItem(
            id: "empty-\(row.id)-\(currentIndex)",
            span: segment.startIndex - currentIndex
          )
        )
      }

      items.append(
        BadgeLayoutItem(
          id: segment.id,
          segment: segment,
          span: segment.span
        )
      )
      currentIndex = segment.startIndex + segment.span
    }

    if currentIndex < week.days.count {
      items.append(
        BadgeLayoutItem(
          id: "empty-\(row.id)-tail",
          span: week.days.count - currentIndex
        )
      )
    }

    return items
  }

  func tapDate(_ day: HomeCalendarComponent.Configuration.Day) {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
    eventListener?(.tapDate(day.date))
  }
}

private extension HomeCalendarComponentWeekView {
  struct BadgeLayoutItem: Identifiable {
    let id: String
    let segment: HomeCalendarComponent.Configuration.BadgeSegment?
    let span: Int

    init(
      id: String,
      segment: HomeCalendarComponent.Configuration.BadgeSegment? = nil,
      span: Int
    ) {
      self.id = id
      self.segment = segment
      self.span = span
    }
  }
}
