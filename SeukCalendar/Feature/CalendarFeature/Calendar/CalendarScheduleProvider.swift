import DesignSystem
import EventKit
import Foundation

@MainActor
protocol CalendarScheduleProviding: AnyObject {
  func authorizationStatus() -> EKAuthorizationStatus
  func requestFullAccess() async throws -> Bool
  func fetchEvents(in range: DateInterval) async throws -> [CalendarEvent]
}

@MainActor
final class EventKitCalendarScheduleProvider: CalendarScheduleProviding {
  private let eventStore: EKEventStore

  init(eventStore: EKEventStore = EKEventStore()) {
    self.eventStore = eventStore
  }

  func authorizationStatus() -> EKAuthorizationStatus {
    EKEventStore.authorizationStatus(for: .event)
  }

  func requestFullAccess() async throws -> Bool {
    try await eventStore.requestFullAccessToEvents()
  }

  func fetchEvents(in range: DateInterval) async throws -> [CalendarEvent] {
    let predicate = eventStore.predicateForEvents(
      withStart: range.start,
      end: range.end,
      calendars: nil
    )

    return eventStore.events(matching: predicate).map {
      CalendarEvent(
        id: $0.eventIdentifier ?? UUID().uuidString,
        title: $0.title ?? "제목 없음",
        startDate: $0.startDate,
        endDate: $0.endDate,
        isAllDay: $0.isAllDay,
        location: $0.location,
        notes: $0.notes
      )
    }
  }
}
