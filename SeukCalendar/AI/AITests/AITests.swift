@testable import AI
import Foundation
import Testing
internal import CalendarDomain

struct AITests {
  @Test("휴리스틱_내일_오후시간을_절대날짜와_24시간으로_파싱합니다")
  func parseTomorrowWithTimeByHeuristic() async throws {
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: false
    )

    let parsed = try await parser.parse(
      text: "내일 오후 3시 강남역에서 팀 미팅",
      referenceDate: Self.fixedDate
    )

    #expect(parsed.dateString == "2026-03-04")
    #expect(parsed.startTime == "15:00")
    #expect(parsed.durationMinutes == 60)
    #expect(parsed.location == "강남역")
    #expect(parsed.isAllDay == false)
  }

  @Test("휴리스틱_다음주_금요일_저녁_입력을_파싱합니다")
  func parseNextWeekFridayEveningByHeuristic() async throws {
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: false
    )

    let parsed = try await parser.parse(
      text: "다음주 금요일 저녁 7시 홍대에서 친구들이랑 저녁",
      referenceDate: Self.fixedDate
    )

    #expect(parsed.dateString == "2026-03-13")
    #expect(parsed.startTime == "19:00")
    #expect(parsed.location == "홍대")
    #expect(parsed.isAllDay == false)
  }

  @Test("휴리스틱_시간없는_입력은_종일로_처리합니다")
  func parseTextWithoutTimeAsAllDayByHeuristic() async throws {
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: false
    )

    let parsed = try await parser.parse(
      text: "다음주 월요일 연차",
      referenceDate: Self.fixedDate
    )

    #expect(parsed.startTime == nil)
    #expect(parsed.isAllDay == true)
    #expect(parsed.durationMinutes == 1440)
  }
}

private extension AITests {
  static var fixedCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
    calendar.locale = Locale(identifier: "ko_KR")
    return calendar
  }

  static var fixedDate: Date {
    let components = DateComponents(
      calendar: fixedCalendar,
      timeZone: fixedCalendar.timeZone,
      year: 2026,
      month: 3,
      day: 3
    )
    return components.date ?? .init(timeIntervalSince1970: 0)
  }
}
