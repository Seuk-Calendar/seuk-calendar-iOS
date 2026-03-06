import Foundation

public extension HomeCalendarComponent {
  struct Configuration: Hashable, Sendable {
    public let monthBar: MonthBar?
    public let weekdays: [Weekday]
    public let weeks: [Week]

    public init(
      monthBar: MonthBar? = nil,
      weekdays: [Weekday],
      weeks: [Week]
    ) {
      self.monthBar = monthBar
      self.weekdays = weekdays
      self.weeks = weeks
    }
  }
}

public extension HomeCalendarComponent.Configuration {
  struct MonthBar: Hashable, Sendable {
    public let previousMonthTitle: String
    public let currentMonthTitle: String
    public let nextMonthTitle: String

    public init(
      previousMonthTitle: String,
      currentMonthTitle: String,
      nextMonthTitle: String
    ) {
      self.previousMonthTitle = previousMonthTitle
      self.currentMonthTitle = currentMonthTitle
      self.nextMonthTitle = nextMonthTitle
    }
  }

  struct Weekday: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let role: WeekdayRole

    public init(
      id: String,
      title: String,
      role: WeekdayRole
    ) {
      self.id = id
      self.title = title
      self.role = role
    }
  }

  struct Week: Identifiable, Hashable, Sendable {
    public let id: String
    public let days: [Day]
    public let badgeRows: [BadgeRow]

    public init(
      id: String,
      days: [Day],
      badgeRows: [BadgeRow] = []
    ) {
      self.id = id
      self.days = days
      self.badgeRows = badgeRows
    }
  }

  struct Day: Identifiable, Hashable, Sendable {
    public let id: String
    public let date: Date
    public let dayText: String
    public let weekdayRole: WeekdayRole
    public let isInCurrentMonth: Bool
    public let isSelected: Bool
    public let isToday: Bool
    public let badges: [Badge]
    public let hiddenBadgeCount: Int

    public init(
      id: String,
      date: Date,
      dayText: String,
      weekdayRole: WeekdayRole,
      isInCurrentMonth: Bool,
      isSelected: Bool,
      isToday: Bool,
      badges: [Badge] = [],
      hiddenBadgeCount: Int = 0
    ) {
      self.id = id
      self.date = date
      self.dayText = dayText
      self.weekdayRole = weekdayRole
      self.isInCurrentMonth = isInCurrentMonth
      self.isSelected = isSelected
      self.isToday = isToday
      self.badges = badges
      self.hiddenBadgeCount = hiddenBadgeCount
    }
  }

  struct Badge: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let style: BadgeStyle

    public init(
      id: String,
      title: String,
      style: BadgeStyle
    ) {
      self.id = id
      self.title = title
      self.style = style
    }
  }

  struct BadgeRow: Identifiable, Hashable, Sendable {
    public let id: String
    public let segments: [BadgeSegment]

    public init(
      id: String,
      segments: [BadgeSegment]
    ) {
      self.id = id
      self.segments = segments
    }
  }

  struct BadgeSegment: Identifiable, Hashable, Sendable {
    public let id: String
    public let badge: Badge
    public let startIndex: Int
    public let span: Int

    public init(
      id: String,
      badge: Badge,
      startIndex: Int,
      span: Int
    ) {
      self.id = id
      self.badge = badge
      self.startIndex = startIndex
      self.span = span
    }
  }

  enum WeekdayRole: Hashable, Sendable {
    case sunday
    case weekday
    case saturday
  }

  enum BadgeStyle: Hashable, Sendable {
    case blue
    case blueSoft
    case green
    case yellow
    case red
    case orange
    case purple
    case pink
  }
}
