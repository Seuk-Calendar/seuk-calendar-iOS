import CalendarDomain
import Foundation

public extension CalendarViewModel {
  enum ViewMode: String, CaseIterable, Identifiable {
    case month
    case week
    case day

    public var id: String { rawValue }

    public var title: String {
      switch self {
      case .month:
        "월"
      case .week:
        "주"
      case .day:
        "일"
      }
    }
  }

  enum PermissionState: Equatable {
    case idle
    case granted
    case denied(String)

    public var isDenied: Bool {
      if case .denied = self {
        return true
      }

      return false
    }
  }

  struct ParsedEventDraft: Equatable {
    public var title: String
    public var dateString: String
    public var startTime: String
    public var durationMinutesText: String
    public var location: String
    public var notes: String
    public var isAllDay: Bool

    public init(
      title: String,
      dateString: String,
      startTime: String,
      durationMinutesText: String,
      location: String,
      notes: String,
      isAllDay: Bool
    ) {
      self.title = title
      self.dateString = dateString
      self.startTime = startTime
      self.durationMinutesText = durationMinutesText
      self.location = location
      self.notes = notes
      self.isAllDay = isAllDay
    }

    init(parsedEvent: ParsedEvent) {
      self.title = parsedEvent.title
      self.dateString = parsedEvent.dateString
      self.startTime = parsedEvent.startTime ?? ""
      if let durationMinutes = parsedEvent.durationMinutes {
        self.durationMinutesText = String(durationMinutes)
      } else {
        self.durationMinutesText = ""
      }
      self.location = parsedEvent.location ?? ""
      self.notes = parsedEvent.notes ?? ""
      self.isAllDay = parsedEvent.isAllDay
    }

    var parsedEvent: ParsedEvent {
      ParsedEvent(
        title: title,
        dateString: dateString,
        startTime: startTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : startTime,
        durationMinutes: Int(durationMinutesText),
        location: location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : location,
        notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes,
        isAllDay: isAllDay
      )
    }
  }
}
