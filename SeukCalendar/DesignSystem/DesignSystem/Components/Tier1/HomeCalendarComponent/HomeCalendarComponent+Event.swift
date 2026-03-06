import Foundation

public extension HomeCalendarComponent {
  enum Event: Hashable, Sendable {
    case tapPreviousMonth
    case tapNextMonth
    case tapDate(Date)
  }

  typealias EventListener = (Event) -> Void
}
