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
    await syncWidgetSnapshotIfPossible()
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
}

private extension WidgetSyncingScheduleRepository {
  func syncWidgetSnapshotIfPossible(referenceDate: Date = Date()) async {
    guard fetchAuthorizationStatus() == .fullAccess else {
      snapshotStore.clear()
      return
    }

    do {
      let schedules = try await baseRepository.fetchSchedules(in: widgetRange(referenceDate: referenceDate))
      snapshotStore.save(schedules: schedules, generatedAt: referenceDate, calendar: calendar)
    } catch {
      // 위젯 동기화 실패는 본 앱 흐름을 중단시키지 않습니다.
    }
  }

  func widgetRange(referenceDate: Date) -> DateInterval {
    let start = calendar.startOfDay(for: referenceDate)
    let end = calendar.date(byAdding: .day, value: 2, to: start) ?? start
    return DateInterval(start: start, end: end)
  }
}
