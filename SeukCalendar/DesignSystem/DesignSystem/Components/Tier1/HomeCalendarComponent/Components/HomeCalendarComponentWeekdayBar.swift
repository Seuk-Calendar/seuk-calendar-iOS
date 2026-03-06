import SwiftUI

struct HomeCalendarComponentWeekdayBar: View {
  let weekdays: [HomeCalendarComponent.Configuration.Weekday]

  var body: some View {
    HStack(spacing: 0) {
      ForEach(weekdays) { weekday in
        Text(weekday.title)
          .font(Label.xSmall)
          .foregroundStyle(weekday.role.foregroundColor)
          .frame(maxWidth: .infinity)
      }
    }
    .padding(.vertical, Spacing.sp200)
    .padding(.horizontal, Spacing.sp250)
    .background(Color.primitives.white)
    .overlay(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .stroke(Color.primitives.white, lineWidth: 1)
    )
    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
  }
}

private extension HomeCalendarComponent.Configuration.WeekdayRole {
  var foregroundColor: Color {
    switch self {
    case .sunday:
      .calendar.red
    case .weekday:
      .primitives.gray600
    case .saturday:
      .primitives.blue600
    }
  }
}
