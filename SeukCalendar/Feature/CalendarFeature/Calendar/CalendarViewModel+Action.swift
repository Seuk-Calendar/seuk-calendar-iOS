import Foundation

public extension CalendarViewModel {
  enum Action {
    case onAppear
    case changeMode(ViewMode)
    case selectDate(Date)
    case movePeriod(Int)
    case moveToToday
  }
}
