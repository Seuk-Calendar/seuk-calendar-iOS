import CalendarDomain
import Foundation

public final class MockScheduleNaturalLanguageParser: ScheduleNaturalLanguageParser {
  public var parseResult: Result<ParsedEvent, Error> = .success(
    ParsedEvent(
      title: "기본 파싱 일정",
      dateString: "2026-03-03",
      startTime: "10:00",
      durationMinutes: 60,
      location: nil,
      notes: nil,
      isAllDay: false
    )
  )
  public private(set) var parseCallCount = 0
  public private(set) var parsedInputs: [(text: String, referenceDate: Date)] = []

  public init() {}

  public func parse(text: String, referenceDate: Date) async throws -> ParsedEvent {
    parseCallCount += 1
    parsedInputs.append((text, referenceDate))
    return try parseResult.get()
  }
}
