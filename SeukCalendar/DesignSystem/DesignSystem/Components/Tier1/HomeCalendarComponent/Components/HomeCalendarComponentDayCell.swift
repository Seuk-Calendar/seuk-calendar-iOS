import SwiftUI

#if canImport(UIKit)
  import UIKit
#endif

struct HomeCalendarComponentDayCell: View {
  static let pressedScale: CGFloat = 0.8

  let day: HomeCalendarComponent.Configuration.Day
  let showsBadges: Bool
  let showsIndicators: Bool
  let isPressed: Bool
  let fixedHeight: CGFloat?
  let action: () -> Void

  init(
    day: HomeCalendarComponent.Configuration.Day,
    showsBadges: Bool,
    showsIndicators: Bool = false,
    isPressed: Bool = false,
    fixedHeight: CGFloat? = nil,
    action: @escaping () -> Void
  ) {
    self.day = day
    self.showsBadges = showsBadges
    self.showsIndicators = showsIndicators
    self.isPressed = isPressed
    self.fixedHeight = fixedHeight
    self.action = action
  }

  var body: some View {
    Button(
      action: {
        generateLightHaptic()
        action()
      },
      label: {
        VStack(alignment: .center, spacing: Spacing.sp100) {
          dayNumberView

          if showsBadges {
            ForEach(day.badges.prefix(HomeCalendarConfigurationBuilder.maxVisibleBadgeRows)) { badge in
              HomeCalendarComponentBadge(badge: badge)
            }
          }

          if showsIndicators {
            indicatorDots
          }

          if showsBadges, day.hiddenBadgeCount > 0 {
            Text("+\(day.hiddenBadgeCount)")
              .font(.homeCalendar(weight: .semiBold, size: 8))
              .foregroundStyle(Color.primitives.gray600)
              .lineLimit(1)
              .minimumScaleFactor(0.8)
          }

          if showsBadges || showsIndicators {
            Spacer(minLength: 0)
          }
        }
        .padding(.horizontal, Spacing.sp050)
        .frame(
          maxWidth: .infinity,
          minHeight: resolvedHeight,
          maxHeight: fixedHeight,
          alignment: .top
        )
        .background {
          if showsBadges || showsIndicators, day.isSelected {
            RoundedRectangle(cornerRadius: Radius.rds250, style: .continuous)
              .fill(Color.semantic.Background.tertiary)
          }
        }
        .contentShape(Rectangle())
        .scaleEffect(isPressed ? Self.pressedScale : 1)
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
        .accessibilityLabel(Text(accessibilityLabel))
      }
    )
    .buttonStyle(HomeCalendarComponentPressButtonStyle())
  }
}

private extension HomeCalendarComponentDayCell {
  func generateLightHaptic() {
    #if canImport(UIKit)
      let generator = UIImpactFeedbackGenerator(style: .light)
      generator.impactOccurred()
    #endif
  }

  var dayNumberView: some View {
    Text(day.dayText)
      .font(dayNumberFont)
      .foregroundStyle(dayNumberColor)
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: .center)
      .frame(width: dayNumberHighlightSize)
      .background {
        if day.isToday {
          Circle()
            .fill(Color.semanticExtensions.Background.backgroundAccent)
            .frame(width: dayNumberHighlightSize, height: dayNumberHighlightSize)
        }
      }
  }

  var dayNumberColor: Color {
    if day.isToday {
      return .semanticExtensions.Content.contentOnColor
    }

    guard day.isInCurrentMonth else {
      return .primitives.gray400
    }

    switch day.weekdayRole {
    case .sunday:
      return .calendar.red
    case .weekday:
      return .primitives.gray900
    case .saturday:
      return .primitives.blue600
    }
  }

  var dayNumberFont: Font {
    let weight: Pretendard.Weight
    if day.isToday {
      weight = .bold
    } else if day.isSelected {
      weight = .semiBold
    } else {
      weight = .regular
    }

    return .homeCalendar(weight: weight, size: 14)
  }

  var dayNumberHighlightSize: CGFloat? {
    day.isToday ? 20 : nil
  }

  var eventCount: Int {
    day.badges.count + day.hiddenBadgeCount
  }

  var dotCount: Int {
    min(eventCount, 3)
  }

  var resolvedHeight: CGFloat {
    fixedHeight ?? (showsBadges ? 80 : dayNumberHighlightSize ?? 20)
  }

  var indicatorColor: Color {
    day.isInCurrentMonth ? Color.primitives.blue600 : Color.primitives.blue200
  }

  var indicatorDots: some View {
    HStack(spacing: 3) {
      ForEach(0 ..< dotCount, id: \.self) { _ in
        Circle()
          .fill(indicatorColor)
          .frame(width: 4, height: 4)
      }
    }
    .frame(height: 8)
    .opacity(dotCount > 0 ? 1 : 0)
  }

  var accessibilityLabel: String {
    if eventCount > 0 {
      return "\(day.dayText)일, 일정 \(eventCount)개"
    }

    return "\(day.dayText)일"
  }
}

private struct HomeCalendarComponentPressButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? HomeCalendarComponentDayCell.pressedScale : 1)
      .animation(.spring(response: 0.18, dampingFraction: 0.72), value: configuration.isPressed)
  }
}

#Preview {
  @Previewable @State var isSelected = false

  HomeCalendarComponentDayCell(
    day: .init(
      id: "1",
      date: Date(),
      dayText: "1",
      weekdayRole: .weekday,
      isInCurrentMonth: true,
      isSelected: isSelected,
      isToday: true
    ),
    showsBadges: false,
    action: {
      isSelected.toggle()
    }
  )
}
