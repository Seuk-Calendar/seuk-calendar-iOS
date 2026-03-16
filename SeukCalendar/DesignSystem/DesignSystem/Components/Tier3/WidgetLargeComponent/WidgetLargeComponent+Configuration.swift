import Foundation

public extension WidgetLargeComponent {
  struct Configuration: Hashable, Sendable {
    public let title: String
    public let weeks: [[WidgetDayCellComponent.Configuration]]

    public init(
      title: String,
      weeks: [[WidgetDayCellComponent.Configuration]]
    ) {
      self.title = title
      self.weeks = weeks
    }
  }
}

extension WidgetLargeComponent.Configuration {
  var displayedWeeks: [[WidgetDayCellComponent.Configuration]] {
    Array(weeks.prefix(5)).map { Array($0.prefix(7)) }
  }

  var visibleWeeks: [[WidgetDayCellComponent.Configuration?]] {
    guard let primaryMonthIdentifier else {
      return displayedWeeks.map { $0.map(Optional.some) }
    }

    return displayedWeeks.map { week in
      week.map { dayCell in
        monthIdentifier(for: dayCell.date) == primaryMonthIdentifier ? dayCell : nil
      }
    }
  }
}

private extension WidgetLargeComponent.Configuration {
  var primaryMonthIdentifier: Int? {
    let counts = displayedWeeks
      .flatMap { $0 }
      .reduce(into: [Int: Int]()) { partialResult, dayCell in
        partialResult[monthIdentifier(for: dayCell.date), default: 0] += 1
      }

    return counts.max { lhs, rhs in
      if lhs.value == rhs.value {
        return lhs.key > rhs.key
      }

      return lhs.value < rhs.value
    }?.key
  }

  func monthIdentifier(for date: Date) -> Int {
    let components = Self.calendar.dateComponents([.year, .month], from: date)
    return (components.year ?? 0) * 100 + (components.month ?? 0)
  }

  static var calendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = .autoupdatingCurrent
    calendar.timeZone = .autoupdatingCurrent
    return calendar
  }
}
