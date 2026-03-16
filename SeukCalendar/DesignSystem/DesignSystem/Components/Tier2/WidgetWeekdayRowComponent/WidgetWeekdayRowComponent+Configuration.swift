import Foundation

public extension WidgetWeekdayRowComponent {
  struct Configuration: Hashable, Sendable {
    public let locale: Locale

    public init(locale: Locale = Locale(identifier: "ko_KR")) {
      self.locale = locale
    }
  }
}

extension WidgetWeekdayRowComponent.Configuration {
  struct WeekdayItem: Hashable {
    enum Role: Hashable {
      case sunday
      case weekday
      case saturday
    }

    let title: String
    let role: Role
  }

  var weekdayItems: [WeekdayItem] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = locale
    calendar.firstWeekday = 1

    return calendar.shortStandaloneWeekdaySymbols.enumerated().map { index, title in
      let role: WeekdayItem.Role
      switch index {
      case 0:
        role = .sunday
      case 6:
        role = .saturday
      default:
        role = .weekday
      }

      return WeekdayItem(
        title: title,
        role: role
      )
    }
  }
}
