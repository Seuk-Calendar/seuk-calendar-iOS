import Core
import Foundation

public enum ScheduleNaturalLanguageParserError: SCError, Equatable {
  case unsupported
  case emptyInput
  case parsingFailed

  public var errorDescription: String {
    switch self {
    case .unsupported:
      "자연어 파서를 사용할 수 없는 환경입니다."
    case .emptyInput:
      "파싱할 입력 문자열이 비어 있습니다."
    case .parsingFailed:
      "자연어 입력을 일정으로 해석하지 못했습니다."
    }
  }

  public var userMessage: String {
    switch self {
    case .unsupported:
      "현재 기기에서는 AI 파싱을 사용할 수 없습니다."
    case .emptyInput:
      "일정 문장을 입력해주세요."
    case .parsingFailed:
      "입력한 문장을 일정으로 해석하지 못했습니다. 내용을 조금 더 구체적으로 입력해주세요."
    }
  }
}

public protocol ScheduleNaturalLanguageParser {
  func parse(text: String, referenceDate: Date) async throws -> ParsedEvent
}

public struct UnavailableScheduleNaturalLanguageParser: ScheduleNaturalLanguageParser {
  public init() {}

  public func parse(text: String, referenceDate: Date) async throws -> ParsedEvent {
    throw ScheduleNaturalLanguageParserError.unsupported
  }
}
