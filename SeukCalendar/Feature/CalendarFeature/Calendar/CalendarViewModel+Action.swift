import Foundation

public extension CalendarViewModel {
  enum Action {
    case onAppear
    case refreshSchedules
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
    case addParsedAlarm(AlarmPreset)
    case removeParsedAlarm(Int)
    case clearParsedAlarms
    case updateParsedLocation(String)
    case updateParsedNotes(String)
    case updateParsedIsAllDay(Bool)
    case saveParsedEvent
  }
}
