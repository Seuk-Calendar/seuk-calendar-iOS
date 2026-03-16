import CalendarDomain
import Foundation

final class WidgetSyncingScheduleRepository: ScheduleRepository {
  private let baseRepository: any ScheduleRepository
  private let snapshotStore: WidgetScheduleSnapshotStore
  private let calendar: Calendar

  init(
    base: any ScheduleRepository,
    snapshotStore: WidgetScheduleSnapshotStore = WidgetScheduleSnapshotStore(),
    calendar: Calendar = .current
  ) {
    baseRepository = base
    self.snapshotStore = snapshotStore
    self.calendar = calendar
  }

  func requestAccess() async throws -> Bool {
    let granted = try await baseRepository.requestAccess()

    if granted {
      await syncWidgetSnapshotIfPossible()
    } else {
      snapshotStore.clear()
    }

    return granted
  }

  func fetchAuthorizationStatus() -> ScheduleAuthorizationStatus {
    baseRepository.fetchAuthorizationStatus()
  }

  func hasNotificationPermission() async -> Bool {
    await baseRepository.hasNotificationPermission()
  }

  func observeScheduleChanges() -> AsyncStream<Void> {
    let upstream = baseRepository.observeScheduleChanges()

    return AsyncStream { continuation in
      let task = Task {
        for await _ in upstream {
          await syncWidgetSnapshotIfPossible()
          continuation.yield(())
        }

        continuation.finish()
      }

      continuation.onTermination = { _ in
        task.cancel()
      }
    }
  }

  func create(schedule: Schedule) async throws -> Schedule {
    let created = try await baseRepository.create(schedule: schedule)
    await syncWidgetSnapshotIfPossible()
    return created
  }

  func fetchSchedule(id: String) async throws -> Schedule? {
    try await baseRepository.fetchSchedule(id: id)
  }

  func fetchSchedules(in range: DateInterval) async throws -> [Schedule] {
    let schedules = try await baseRepository.fetchSchedules(in: range)
    let referenceDate = Date()
    await syncWidgetSnapshotIfPossible(
      using: schedules,
      fetchedRange: range,
      referenceDate: referenceDate
    )
    return schedules
  }

  func update(schedule: Schedule) async throws -> Schedule {
    let updated = try await baseRepository.update(schedule: schedule)
    await syncWidgetSnapshotIfPossible()
    return updated
  }

  func deleteSchedule(id: String) async throws {
    try await baseRepository.deleteSchedule(id: id)
    await syncWidgetSnapshotIfPossible()
  }

  func hasICloudCalendar() -> Bool {
    baseRepository.hasICloudCalendar()
  }

  func refreshWidgetSnapshot(referenceDate: Date = Date()) async {
    guard fetchAuthorizationStatus() == .fullAccess else {
      debugLog("foreground sync skipped: authorization is not full access")
      return
    }

    await syncWidgetSnapshotIfPossible(referenceDate: referenceDate)
  }
}

private extension WidgetSyncingScheduleRepository {
  func syncWidgetSnapshotIfPossible(referenceDate: Date = Date()) async {
    guard fetchAuthorizationStatus() == .fullAccess else {
      debugLog("widget snapshot sync skipped: authorization is not full access")
      return
    }

    do {
      let schedules = try await baseRepository.fetchSchedules(in: widgetRange(referenceDate: referenceDate))
      snapshotStore.save(schedules: schedules, generatedAt: referenceDate, calendar: calendar)
      debugLog("widget snapshot synced via repository fetch: \(schedules.count) items")
    } catch {
      // 위젯 동기화 실패는 본 앱 흐름을 중단시키지 않습니다.
      debugLog("widget snapshot sync failed: \(error.localizedDescription)")
    }
  }

  func syncWidgetSnapshotIfPossible(
    using schedules: [Schedule],
    fetchedRange: DateInterval,
    referenceDate: Date
  ) async {
    guard fetchAuthorizationStatus() == .fullAccess else {
      debugLog("widget snapshot reuse skipped: authorization is not full access")
      return
    }

    let widgetRange = widgetRange(referenceDate: referenceDate)

    guard fetchedRange.start <= widgetRange.start,
          fetchedRange.end >= widgetRange.end
    else {
      debugLog("fetched range does not cover widget range, falling back to dedicated widget sync")
      await syncWidgetSnapshotIfPossible(referenceDate: referenceDate)
      return
    }

    let widgetSchedules = schedules.filter { overlapsWidgetRange($0, widgetRange: widgetRange) }
    snapshotStore.save(schedules: widgetSchedules, generatedAt: referenceDate, calendar: calendar)
    debugLog("widget snapshot reused visible fetch result: \(widgetSchedules.count) items")
  }

  func widgetRange(referenceDate: Date) -> DateInterval {
    let dayStart = calendar.startOfDay(for: referenceDate)
    let monthStart = calendar.dateInterval(of: .month, for: dayStart)?.start ?? dayStart
    let gridStart = calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart
    let gridEnd = calendar.date(byAdding: .day, value: 35, to: gridStart) ?? gridStart

    return DateInterval(start: gridStart, end: gridEnd)
  }

  func overlapsWidgetRange(_ schedule: Schedule, widgetRange: DateInterval) -> Bool {
    guard let startDate = schedule.startDate(using: calendar),
          let endDate = schedule.endDate(using: calendar)
    else {
      return false
    }

    return startDate < widgetRange.end && endDate > widgetRange.start
  }

  func debugLog(_ message: String) {
    #if DEBUG
      print("[WidgetSyncingScheduleRepository] \(message)")
    #endif
  }
}
