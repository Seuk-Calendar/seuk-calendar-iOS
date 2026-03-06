import SwiftUI
import UIKit

struct HomeCalendarComponentDayCell: View {
  let day: HomeCalendarComponent.Configuration.Day
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(alignment: .center, spacing: Spacing.sp100) {
        dayNumberView

        ForEach(day.badges.prefix(2)) { badge in
          HomeCalendarComponentBadge(badge: badge)
        }

        if day.hiddenBadgeCount > 0 {
          Text("+\(day.hiddenBadgeCount)")
            .font(.homeCalendar(weight: .semiBold, size: 8))
            .foregroundStyle(Color.primitives.gray600)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
        }

        Spacer(minLength: 0)
      }
      .padding(.horizontal, Spacing.sp050)
      .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
      .background {
        if day.isSelected {
          RoundedRectangle(cornerRadius: Radius.rds250, style: .continuous)
            .fill(Color.semantic.Background.backgroundTertiary)
        }
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

private extension HomeCalendarComponentDayCell {
  var dayNumberView: some View {
    HStack(spacing: 0) {
      Text(day.dayText)
        .font(dayNumberFont)
        .foregroundStyle(dayNumberColor)
        .lineLimit(1)
        .frame(width: dayNumberHighlightSize)
        .background {
          if day.isToday {
            Circle()
              .fill(Color.semanticExtensions.Background.backgroundAccent)
              .frame(width: dayNumberHighlightSize, height: dayNumberHighlightSize)
          }
        }

      Spacer(minLength: 0)
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
    action: {
      isSelected.toggle()
    }
  )
}
