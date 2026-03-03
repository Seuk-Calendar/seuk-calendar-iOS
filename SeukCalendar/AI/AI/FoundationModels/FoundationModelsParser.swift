import CalendarDomain
import Core
import Foundation
#if canImport(FoundationModels)
  import FoundationModels
#endif

public enum FoundationModelsParserError: SCError, Equatable {
  case unsupported
  case parsingFailed

  public var errorDescription: String {
    switch self {
    case .unsupported:
      "Foundation Models를 사용할 수 없는 환경입니다."
    case .parsingFailed:
      "Foundation Models와 휴리스틱 파싱 모두 실패했습니다."
    }
  }

  public var userMessage: String {
    switch self {
    case .unsupported:
      "현재 기기에서는 AI 파싱을 사용할 수 없습니다."
    case .parsingFailed:
      "일정을 해석하지 못했습니다. 날짜/시간/장소를 조금 더 명확히 입력해주세요."
    }
  }
}

public final class FoundationModelsParser: ScheduleNaturalLanguageParser {
  private let calendar: Calendar
  private let locale: Locale
  private let preferFoundationModels: Bool

  public init(
    calendar: Calendar = .current,
    locale: Locale = .current,
    preferFoundationModels: Bool = true
  ) {
    self.calendar = calendar
    self.locale = locale
    self.preferFoundationModels = preferFoundationModels
  }

  public func parse(text: String, referenceDate: Date) async throws -> ParsedEvent {
    let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedText.isEmpty else {
      throw ScheduleNaturalLanguageParserError.emptyInput
    }

    #if canImport(FoundationModels)
      if preferFoundationModels,
         #available(iOS 26.0, macOS 26.0, *),
         let foundationModelsResult = try await parseWithFoundationModels(
           text: trimmedText,
           referenceDate: referenceDate
         ) {
        return foundationModelsResult
      }
    #endif

    if let heuristicResult = parseWithHeuristic(text: trimmedText, referenceDate: referenceDate) {
      return heuristicResult
    }

    throw FoundationModelsParserError.parsingFailed
  }
}

private extension FoundationModelsParser {
  #if canImport(FoundationModels)
    @available(iOS 26.0, macOS 26.0, *)
    func parseWithFoundationModels(
      text: String,
      referenceDate: Date
    ) async throws -> ParsedEvent? {
      let session = LanguageModelSession(
        instructions:
        """
        당신은 한국어 일정 입력을 구조화된 데이터로 변환하는 파서입니다.
        다음 규칙을 반드시 지키세요.
        - dateString은 반드시 절대 날짜(yyyy-MM-dd) 형식으로 출력합니다.
        - 시간이 없으면 isAllDay=true, startTime=null 입니다.
        - startTime은 24시간 형식(HH:mm)입니다.
        - durationMinutes가 불분명하면 null로 둡니다.
        - title은 간결한 일정 제목으로 정리합니다.
        """
      )

      let dateFormatter = DateFormatter()
      dateFormatter.calendar = calendar
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.timeZone = calendar.timeZone
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let referenceDateString = dateFormatter.string(from: referenceDate)

      let prompt =
        """
        기준 날짜: \(referenceDateString)
        사용자 입력: \(text)
        """

      do {
        let response = try await session.respond(to: prompt, generating: ParsedEventGenerable.self)
        let content = response.content

        return ParsedEvent(
          title: content.title.trimmingCharacters(in: .whitespacesAndNewlines),
          dateString: content.dateString.trimmingCharacters(in: .whitespacesAndNewlines),
          startTime: content.startTime?.trimmingCharacters(in: .whitespacesAndNewlines),
          durationMinutes: content.durationMinutes,
          location: content.location?.trimmingCharacters(in: .whitespacesAndNewlines),
          notes: content.notes?.trimmingCharacters(in: .whitespacesAndNewlines),
          isAllDay: content.isAllDay
        )
      } catch {
        return nil
      }
    }
  #endif

  func parseWithHeuristic(text: String, referenceDate: Date) -> ParsedEvent? {
    guard let resolvedDate = resolveDate(from: text, referenceDate: referenceDate) else {
      return nil
    }

    let dateFormatter = DateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = calendar.timeZone
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter.string(from: resolvedDate)

    let startTime = resolveTime(from: text)
    let isAllDay = startTime == nil
    let durationMinutes = resolveDurationMinutes(from: text) ?? (isAllDay ? 1440 : 60)
    let location = resolveLocation(from: text)
    let title = resolveTitle(from: text, location: location)

    return ParsedEvent(
      title: title,
      dateString: dateString,
      startTime: startTime,
      durationMinutes: durationMinutes,
      location: location,
      notes: nil,
      isAllDay: isAllDay
    )
  }

  func resolveDate(from text: String, referenceDate: Date) -> Date? {
    if let explicitDate = parseExplicitDate(from: text) {
      return explicitDate
    }

    let normalizedReferenceDate = calendar.startOfDay(for: referenceDate)

    if text.contains("오늘") {
      return normalizedReferenceDate
    }
    if text.contains("내일") {
      return calendar.date(byAdding: .day, value: 1, to: normalizedReferenceDate)
    }
    if text.contains("모레") {
      return calendar.date(byAdding: .day, value: 2, to: normalizedReferenceDate)
    }

    guard let targetWeekday = parseWeekday(from: text) else {
      return normalizedReferenceDate
    }

    let currentWeekday = calendar.component(.weekday, from: normalizedReferenceDate)
    var daysToAdd = (targetWeekday - currentWeekday + 7) % 7
    if daysToAdd == 0 {
      daysToAdd = 7
    }

    let hasNextWeekKeyword = text.range(of: "다음\\s*주|담주", options: .regularExpression) != nil
    if hasNextWeekKeyword {
      daysToAdd += 7
    }

    return calendar.date(byAdding: .day, value: daysToAdd, to: normalizedReferenceDate)
  }

  func parseExplicitDate(from text: String) -> Date? {
    guard let match = text.firstRegexMatch(pattern: "(\\d{4})[./-](\\d{1,2})[./-](\\d{1,2})"),
          let year = Int(match[1]),
          let month = Int(match[2]),
          let day = Int(match[3])
    else {
      return nil
    }

    var components = DateComponents()
    components.calendar = calendar
    components.timeZone = calendar.timeZone
    components.year = year
    components.month = month
    components.day = day
    return calendar.date(from: components)
  }

  func parseWeekday(from text: String) -> Int? {
    let mapping: [String: Int] = [
      "일": 1,
      "월": 2,
      "화": 3,
      "수": 4,
      "목": 5,
      "금": 6,
      "토": 7,
    ]

    if let match = text.firstRegexMatch(pattern: "(일|월|화|수|목|금|토)요일") {
      return mapping[match[1]]
    }
    if let match = text.firstRegexMatch(pattern: "(일|월|화|수|목|금|토)요") {
      return mapping[match[1]]
    }

    return nil
  }

  func resolveTime(from text: String) -> String? {
    if let match = text.firstRegexMatch(pattern: "(오전|오후|아침|점심|저녁|밤)?\\s*(\\d{1,2})\\s*시(?:\\s*(\\d{1,2})\\s*분?)?"),
       let parsedHour = Int(match[2]) {
      let meridiem = match[1]
      let minute = Int(match[3] ?? "") ?? 0
      guard (0 ..< 60).contains(minute) else {
        return nil
      }

      var hour = parsedHour
      if ["오후", "저녁", "밤"].contains(meridiem), parsedHour < 12 {
        hour += 12
      } else if meridiem == "점심", parsedHour < 10 {
        hour += 12
      } else if meridiem == "오전", parsedHour == 12 {
        hour = 0
      }

      guard (0 ..< 24).contains(hour) else {
        return nil
      }
      return String(format: "%02d:%02d", hour, minute)
    }

    if let match = text.firstRegexMatch(pattern: "\\b(\\d{1,2}):(\\d{2})\\b"),
       let hour = Int(match[1]),
       let minute = Int(match[2]),
       (0 ..< 24).contains(hour),
       (0 ..< 60).contains(minute) {
      return String(format: "%02d:%02d", hour, minute)
    }

    return nil
  }

  func resolveDurationMinutes(from text: String) -> Int? {
    let hourMatch = text.firstRegexMatch(pattern: "(\\d+)\\s*시간")
    let minuteMatch = text.firstRegexMatch(pattern: "(\\d+)\\s*분")

    let hours = hourMatch.flatMap { Int($0[1]) } ?? 0
    let minutes = minuteMatch.flatMap { Int($0[1]) } ?? 0
    let total = (hours * 60) + minutes

    return total > 0 ? total : nil
  }

  func resolveLocation(from text: String) -> String? {
    guard let match = text.firstRegexMatch(pattern: "([가-힣A-Za-z0-9\\s]{1,20})에서") else {
      return nil
    }

    let location = match[1].trimmingCharacters(in: .whitespacesAndNewlines)
    return location.isEmpty ? nil : location
  }

  func resolveTitle(from text: String, location: String?) -> String {
    var title = text
    let removalPatterns = [
      "\\d{4}[./-]\\d{1,2}[./-]\\d{1,2}",
      "오늘|내일|모레|다음\\s*주|담주",
      "(일|월|화|수|목|금|토)요일",
      "(오전|오후|아침|점심|저녁|밤)?\\s*\\d{1,2}\\s*시(?:\\s*\\d{1,2}\\s*분?)?",
      "\\b\\d{1,2}:\\d{2}\\b",
      "\\d+\\s*시간",
      "\\d+\\s*분",
    ]

    for pattern in removalPatterns {
      title = title.replacingOccurrences(of: pattern, with: " ", options: .regularExpression)
    }

    if let location {
      title = title.replacingOccurrences(of: "\(location)에서", with: " ")
    }

    title = title.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
      .trimmingCharacters(in: .whitespacesAndNewlines)

    if title.isEmpty {
      return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    return title
  }
}

private extension String {
  func firstRegexMatch(pattern: String) -> [String]? {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
      return nil
    }
    let range = NSRange(startIndex ..< endIndex, in: self)
    guard let match = regex.firstMatch(in: self, options: [], range: range) else {
      return nil
    }

    return (0 ..< match.numberOfRanges).compactMap { index in
      let nsRange = match.range(at: index)
      guard let range = Range(nsRange, in: self) else {
        return nil
      }
      return String(self[range])
    }
  }
}
