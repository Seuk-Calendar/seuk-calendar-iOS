import SwiftUI

struct HomeCalendarComponentMonthBar: View {
  let monthBar: HomeCalendarComponent.Configuration.MonthBar
  let eventListener: HomeCalendarComponent.EventListener?

  var body: some View {
    HStack {
      Button {
        eventListener?(.tapPreviousMonth)
      } label: {
        HStack(spacing: Spacing.sp100) {
          Image(systemName: "chevron.left")
            .font(.system(size: 10, weight: .medium))

          Text(monthBar.previousMonthTitle)
            .font(Label.small)
        }
        .foregroundStyle(Color.primitives.gray600)
      }
      .buttonStyle(.plain)

      Spacer(minLength: Spacing.sp200)

      Text(monthBar.currentMonthTitle)
        .font(Heading.small)
        .foregroundStyle(Color.primitives.black)

      Spacer(minLength: Spacing.sp200)

      Button {
        eventListener?(.tapNextMonth)
      } label: {
        HStack(spacing: Spacing.sp100) {
          Text(monthBar.nextMonthTitle)
            .font(Label.small)

          Image(systemName: "chevron.right")
            .font(.system(size: 10, weight: .medium))
        }
        .foregroundStyle(Color.primitives.gray600)
      }
      .buttonStyle(.plain)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 44)
  }
}
