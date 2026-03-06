import SwiftUI
import UIKit

struct HomeCalendarComponentDayCell: View {
  let day: HomeCalendarComponent.Configuration.Day
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 3) {
        Text(day.dayText)
          .font(dayNumberFont)
          .foregroundStyle(dayNumberColor)
          .lineLimit(1)

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
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

private extension HomeCalendarComponentDayCell {
  var dayNumberColor: Color {
    if day.isSelected {
      return .primitives.blue600
    }

    if day.isToday {
      return .primitives.gray900
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
}
