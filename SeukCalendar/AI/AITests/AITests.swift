@testable import AI
import Core
import Foundation
import Testing
internal import CalendarDomain

struct AITests {
  @Test("다음주_금요일_저녁_입력을_파싱합니다")
  func parseNextWeekFridayEvening() async throws {
    let referenceDate = Self.referenceDate
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: true
    )

    let parsed = try await parser.parse(
      text: "다음주 금요일 저녁 7시 홍대에서 친구들이랑 저녁",
      referenceDate: referenceDate
    )

    #expect(parsed.dateString == Self.nextWeekdayDateString(from: referenceDate, weekday: 6))
    #expect(parsed.startTime == "19:00")
    #expect(parsed.location == "홍대")
    #expect(parsed.isAllDay == false)
  }

  @Test("휴리스틱_내일_오후시간을_절대날짜와_24시간으로_파싱합니다")
  func parseTomorrowWithTimeByHeuristic() async throws {
    let referenceDate = Self.referenceDate
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: false
    )

    let parsed = try await parser.parse(
      text: "내일 오후 3시 강남역에서 팀 미팅",
      referenceDate: referenceDate
    )

    #expect(parsed.dateString == Self.tomorrowDateString(from: referenceDate))
    #expect(parsed.startTime == "15:00")
    #expect(parsed.durationMinutes == 60)
    #expect(parsed.location == "강남역")
    #expect(parsed.isAllDay == false)
  }

  @Test("휴리스틱_다음주_금요일_저녁_입력을_파싱합니다")
  func parseNextWeekFridayEveningByHeuristic() async throws {
    let referenceDate = Self.referenceDate
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: false
    )

    let parsed = try await parser.parse(
      text: "다음주 금요일 저녁 7시 홍대에서 친구들이랑 저녁",
      referenceDate: referenceDate
    )

    #expect(parsed.dateString == Self.nextWeekdayDateString(from: referenceDate, weekday: 6))
    #expect(parsed.startTime == "19:00")
    #expect(parsed.location == "홍대")
    #expect(parsed.isAllDay == false)
  }

  @Test("휴리스틱_담주_금욜_표현을_파싱합니다")
  func parseNextWeekFridayAbbreviationByHeuristic() async throws {
    let referenceDate = Self.referenceDate
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: false
    )

    let parsed = try await parser.parse(
      text: "담주 금욜 저녁 7시 홍대에서 친구들이랑 저녁",
      referenceDate: referenceDate
    )

    #expect(parsed.dateString == Self.nextWeekdayDateString(from: referenceDate, weekday: 6))
    #expect(parsed.startTime == "19:00")
    #expect(parsed.location == "홍대")
    #expect(parsed.isAllDay == false)
  }

  @Test("휴리스틱_시간없는_입력은_종일로_처리합니다")
  func parseTextWithoutTimeAsAllDayByHeuristic() async throws {
    let referenceDate = Self.referenceDate
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: false
    )

    let parsed = try await parser.parse(
      text: "다음주 월요일 연차",
      referenceDate: referenceDate
    )

    #expect(parsed.dateString == Self.nextWeekdayDateString(from: referenceDate, weekday: 2))
    #expect(parsed.startTime == nil)
    #expect(parsed.isAllDay == true)
    #expect(parsed.durationMinutes == 1440)
  }

  @Test("휴리스틱_알림_표현을_오프셋으로_파싱합니다")
  func parseAlarmOffsetsByHeuristic() async throws {
    let referenceDate = Self.referenceDate
    let parser = FoundationModelsParser(
      calendar: Self.fixedCalendar,
      locale: Locale(identifier: "ko_KR"),
      preferFoundationModels: false
    )

    let parsed = try await parser.parse(
      text: "내일 오후 3시 회의 1시간 전이랑 30분 전에 알려줘",
      referenceDate: referenceDate
    )

    #expect(parsed.startTime == "15:00")
    #expect(parsed.alarms == [ScheduleAlarm(offset: -3600), ScheduleAlarm(offset: -1800)])
  }
}

private extension AITests {
  static var fixedCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
    calendar.locale = Locale(identifier: "ko_KR")
    return calendar
  }

  static let referenceDate: Date = {
    let startOfDay = fixedCalendar.startOfDay(for: Date())
    return startOfDay.after(.hour(12))
  }()

  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = fixedCalendar
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = fixedCalendar.timeZone
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  static func dateString(from date: Date) -> String {
    dateFormatter.string(from: date)
  }

  static func tomorrowDateString(from referenceDate: Date) -> String {
    let normalizedReferenceDate = fixedCalendar.startOfDay(for: referenceDate)
    return dateString(from: normalizedReferenceDate.after(.day(1)))
  }

  static func nextWeekdayDateString(from referenceDate: Date, weekday: Int) -> String {
    let normalizedReferenceDate = fixedCalendar.startOfDay(for: referenceDate)
    let currentWeekday = fixedCalendar.component(.weekday, from: normalizedReferenceDate)

    var daysToAdd = (weekday - currentWeekday + 7) % 7
    if daysToAdd == 0 {
      daysToAdd = 7
    }
    daysToAdd += 7

    return dateString(from: normalizedReferenceDate.after(.day(daysToAdd)))
  }
}
