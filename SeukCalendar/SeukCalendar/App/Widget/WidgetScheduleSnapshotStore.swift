import CalendarDomain
import Foundation
import WidgetKit

struct WidgetScheduleSnapshot: Codable, Sendable {
  struct Item: Codable, Hashable, Sendable, Identifiable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
    let location: String?
  }

  let generatedAt: Date
  let items: [Item]
}

struct WidgetScheduleSnapshotStore {
  private let userDefaults: UserDefaults?
  private let encoder: JSONEncoder

  init(appGroupIdentifier: String = WidgetSharedConstants.appGroupIdentifier) {
    userDefaults = UserDefaults(suiteName: appGroupIdentifier)

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    self.encoder = encoder
  }

  func save(
    schedules: [Schedule],
    generatedAt: Date = Date(),
    calendar: Calendar = .current
  ) {
    let mappedItems: [WidgetScheduleSnapshot.Item] = schedules
      .compactMap { (schedule: Schedule) -> WidgetScheduleSnapshot.Item? in
        guard let startDate = schedule.startDate(using: calendar),
              let endDate = schedule.endDate(using: calendar)
        else {
          return nil
        }

        let fallbackIdentifier = "\(Int(startDate.timeIntervalSince1970))_\(schedule.title)"

        return WidgetScheduleSnapshot.Item(
          id: schedule.id ?? fallbackIdentifier,
          title: schedule.title.isEmpty ? "제목 없음" : schedule.title,
          startDate: startDate,
          endDate: endDate,
          isAllDay: schedule.isAllDay,
          location: schedule.location
        )
      }
      .sorted(by: { (lhs: WidgetScheduleSnapshot.Item, rhs: WidgetScheduleSnapshot.Item) in
        if lhs.startDate == rhs.startDate {
          return lhs.title < rhs.title
        }
        return lhs.startDate < rhs.startDate
      })

    let snapshot = WidgetScheduleSnapshot(generatedAt: generatedAt, items: mappedItems)
    persist(snapshot)
  }

  func clear() {
    persist(WidgetScheduleSnapshot(generatedAt: Date(), items: []))
  }
}

private extension WidgetScheduleSnapshotStore {
  func persist(_ snapshot: WidgetScheduleSnapshot) {
    guard let userDefaults,
          let encoded = try? encoder.encode(snapshot)
    else {
      return
    }

    userDefaults.set(encoded, forKey: WidgetSharedConstants.snapshotStorageKey)
    WidgetCenter.shared.reloadTimelines(ofKind: WidgetSharedConstants.widgetKind)
  }
}
