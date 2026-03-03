import Foundation

public extension CalendarViewModel {
  enum Action {
    case onAppear
    case refreshSchedules
    case changeMode(ViewMode)
    case selectDate(Date)
    case movePeriod(Int)
    case moveToToday
    case updateNaturalLanguageInput(String)
    case parseNaturalLanguage
    case clearParsedEvent
    case updateParsedTitle(String)
    case updateParsedDateString(String)
    case updateParsedStartTime(String)
    case updateParsedDurationMinutes(String)
    case updateParsedLocation(String)
    case updateParsedNotes(String)
    case updateParsedIsAllDay(Bool)
    case saveParsedEvent
  }
}
