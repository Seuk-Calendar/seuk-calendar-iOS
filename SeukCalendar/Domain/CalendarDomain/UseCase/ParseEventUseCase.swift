import Core
import Foundation

public enum ParseEventUseCaseError: SCError, Equatable {
  case emptyInput
  case invalidDateFormat
  case invalidTimeFormat

  public var errorDescription: String {
    switch self {
    case .emptyInput:
      "파싱할 입력 문자열이 비어 있습니다."
    case .invalidDateFormat:
      "파싱 결과의 날짜 형식이 올바르지 않습니다."
    case .invalidTimeFormat:
      "파싱 결과의 시간 형식이 올바르지 않습니다."
    }
  }

  public var userMessage: String {
    switch self {
    case .emptyInput:
      "일정 문장을 입력해주세요."
    case .invalidDateFormat:
      "날짜를 확인할 수 없어 일정을 저장하지 못했습니다."
    case .invalidTimeFormat:
      "시간 형식이 올바르지 않아 일정을 저장하지 못했습니다."
    }
  }
}

public struct ParseEventUseCase {
  private let parser: any ScheduleNaturalLanguageParser
  private let calendar: Calendar

  public init(
    parser: any ScheduleNaturalLanguageParser,
    calendar: Calendar = .current
  ) {
    self.parser = parser
    self.calendar = calendar
  }

  public func execute(
    text: String,
    referenceDate: Date = Date()
  ) async throws -> ParsedEvent {
    let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedText.isEmpty else {
      throw ParseEventUseCaseError.emptyInput
    }

    return try await parser.parse(text: trimmedText, referenceDate: referenceDate)
  }

  public func toSchedule(from parsedEvent: ParsedEvent) throws -> Schedule {
    guard let parsedDate = parsedDate(from: parsedEvent.dateString) else {
      throw ParseEventUseCaseError.invalidDateFormat
    }

    var dateComponents = calendar.dateComponents([.year, .month, .day], from: parsedDate)
    dateComponents.calendar = calendar
    dateComponents.timeZone = calendar.timeZone

    let hasTime = !(parsedEvent.startTime?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    let isAllDay = parsedEvent.isAllDay || !hasTime

    let timeComponents: DateComponents?
    if isAllDay {
      timeComponents = nil
    } else {
      guard let startTime = parsedEvent.startTime else {
        throw ParseEventUseCaseError.invalidTimeFormat
      }
      timeComponents = try parsedTime(from: startTime)
    }

    let defaultDurationMinutes = isAllDay ? 1440 : 60
    let durationMinutes = max(parsedEvent.durationMinutes ?? defaultDurationMinutes, isAllDay ? 1440 : 1)
    let durationSeconds = TimeInterval(durationMinutes * 60)

    let title = parsedEvent.title.trimmingCharacters(in: .whitespacesAndNewlines)
    let location = parsedEvent.location?.trimmingCharacters(in: .whitespacesAndNewlines)
    let notes = parsedEvent.notes?.trimmingCharacters(in: .whitespacesAndNewlines)

    return Schedule(
      title: title.isEmpty ? "제목 없음" : title,
      date: dateComponents,
      time: timeComponents,
      duration: durationSeconds,
      location: location?.isEmpty == true ? nil : location,
      notes: notes?.isEmpty == true ? nil : notes,
      isAllDay: isAllDay
    )
  }
}

private extension ParseEventUseCase {
  func parsedDate(from dateString: String) -> Date? {
    let formats = ["yyyy-MM-dd", "yyyy.MM.dd", "yyyy/MM/dd"]

    for format in formats {
      let formatter = DateFormatter()
      formatter.calendar = calendar
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = calendar.timeZone
      formatter.dateFormat = format

      if let parsedDate = formatter.date(from: dateString) {
        return parsedDate
      }
    }

    return nil
  }

  func parsedTime(from timeString: String) throws -> DateComponents {
    let sanitized = timeString
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: " ", with: "")
    let parts = sanitized.split(separator: ":", omittingEmptySubsequences: false)

    guard parts.count == 2,
          let hour = Int(parts[0]),
          let minute = Int(parts[1]),
          (0 ..< 24).contains(hour),
          (0 ..< 60).contains(minute)
    else {
      throw ParseEventUseCaseError.invalidTimeFormat
    }

    var components = DateComponents()
    components.calendar = calendar
    components.timeZone = calendar.timeZone
    components.hour = hour
    components.minute = minute
    return components
  }
}
