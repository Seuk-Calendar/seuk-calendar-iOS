import SwiftUI

public extension DateWrapComponent {
  struct Configuration: Hashable, Sendable {
    public let dayText: String
    public let isToday: Bool
    public let normalTextColor: Color
    public let todayBackgroundColor: Color
    public let todayTextColor: Color

    public init(
      dayText: String,
      isToday: Bool,
      normalTextColor: Color,
      todayBackgroundColor: Color,
      todayTextColor: Color
    ) {
      self.dayText = dayText
      self.isToday = isToday
      self.normalTextColor = normalTextColor
      self.todayBackgroundColor = todayBackgroundColor
      self.todayTextColor = todayTextColor
    }
  }
}
