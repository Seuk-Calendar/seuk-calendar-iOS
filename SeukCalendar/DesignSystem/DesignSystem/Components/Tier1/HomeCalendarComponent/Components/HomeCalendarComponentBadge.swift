import SwiftUI

struct HomeCalendarComponentBadge: View {
  static let layoutHeight: CGFloat = 14
  static let cornerRadius = Radius.rds100 / 2

  let badge: HomeCalendarComponent.Configuration.Badge
  let position: HomeCalendarComponent.Configuration.BadgeSegmentPosition

  init(
    badge: HomeCalendarComponent.Configuration.Badge,
    position: HomeCalendarComponent.Configuration.BadgeSegmentPosition = .startAndEnd
  ) {
    self.badge = badge
    self.position = position
  }

  var body: some View {
    HStack(spacing: 3) {
      if position.showsMetadata {
        RoundedRectangle(cornerRadius: 1, style: .continuous)
          .fill(badge.style.accentColor)
          .frame(width: 2, height: 10)
      }

      if position.showsMetadata {
        Text(badge.title)
          .font(.homeCalendar(weight: .medium, size: 8))
          .foregroundStyle(badge.style.accentColor)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
      }

      Spacer(minLength: 0)
    }
    .padding(.horizontal, Spacing.sp050)
    .frame(
      maxWidth: .infinity,
      minHeight: Self.layoutHeight,
      maxHeight: Self.layoutHeight,
      alignment: .leading
    )
    .background(badge.style.backgroundColor)
    .clipShape(
      UnevenRoundedRectangle(
        topLeadingRadius: position.hasLeadingCorner ? Self.cornerRadius : 0,
        bottomLeadingRadius: position.hasLeadingCorner ? Self.cornerRadius : 0,
        bottomTrailingRadius: position.hasTrailingCorner ? Self.cornerRadius : 0,
        topTrailingRadius: position.hasTrailingCorner ? Self.cornerRadius : 0,
        style: .continuous
      )
    )
  }
}

private extension HomeCalendarComponent.Configuration.BadgeSegmentPosition {
  var showsMetadata: Bool {
    switch self {
    case .startAndEnd, .start:
      true
    case .middle, .end:
      false
    }
  }

  var hasLeadingCorner: Bool {
    switch self {
    case .startAndEnd, .start:
      true
    case .middle, .end:
      false
    }
  }

  var hasTrailingCorner: Bool {
    switch self {
    case .startAndEnd, .end:
      true
    case .start, .middle:
      false
    }
  }
}

private extension HomeCalendarComponent.Configuration.BadgeStyle {
  var backgroundColor: Color {
    switch self {
    case .blue:
      .primitives.blue100
    case .blueSoft:
      .primitives.blue50
    case .green:
      .primitives.green50
    case .yellow:
      .primitives.yellow50
    case .red:
      .primitives.red100
    case .orange:
      .calendar.orange
    case .purple:
      .calendar.purple
    case .pink:
      .calendar.pink
    }
  }

  var accentColor: Color {
    switch self {
    case .blue, .blueSoft:
      .primitives.blue700
    case .green:
      .primitives.teal800
    case .yellow:
      .primitives.yellow600
    case .red:
      .primitives.red800
    case .orange:
      .primitives.orange700
    case .purple:
      .primitives.purple700
    case .pink:
      .primitives.magenta700
    }
  }
}

extension Font {
  static func homeCalendar(
    weight: Pretendard.Weight,
    size: CGFloat
  ) -> Font {
    let fontName = "\(Pretendard.name)-\(weight.rawValue)"
    return .custom(fontName, size: size)
  }
}
