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

  enum SyncStatusTone: Equatable {
    case normal
    case warning
    case success
    case error
  }

  enum AlarmPreset: String, CaseIterable, Identifiable {
    case none
    case atStart
    case fiveMinutesBefore
    case fifteenMinutesBefore
    case thirtyMinutesBefore
    case oneHourBefore
    case oneDayBefore

    public var id: String { rawValue }

    var title: String {
      switch self {
      case .none:
        "없음"
      case .atStart:
        "시작 시간"
      case .fiveMinutesBefore:
        "5분 전"
      case .fifteenMinutesBefore:
        "15분 전"
      case .thirtyMinutesBefore:
        "30분 전"
      case .oneHourBefore:
        "1시간 전"
      case .oneDayBefore:
        "1일 전"
      }
    }

    var alarm: ScheduleAlarm? {
      switch self {
      case .none:
        nil
      case .atStart:
        ScheduleAlarm(offset: 0)
      case .fiveMinutesBefore:
        ScheduleAlarm(offset: -300)
      case .fifteenMinutesBefore:
        ScheduleAlarm(offset: -900)
      case .thirtyMinutesBefore:
        ScheduleAlarm(offset: -1800)
      case .oneHourBefore:
        ScheduleAlarm(offset: -3600)
      case .oneDayBefore:
        ScheduleAlarm(offset: -86400)
      }
    }

    static func title(for alarm: ScheduleAlarm) -> String {
      if let preset = Self.allCases.first(where: { $0.alarm == alarm }) {
        return preset.title
      }

      if alarm.offset == 0 {
        return "시작 시간"
      }

      let seconds = Int(abs(alarm.offset.rounded()))
      if seconds % 86400 == 0 {
        return "\(seconds / 86400)일 전"
      }
      if seconds % 3600 == 0 {
        return "\(seconds / 3600)시간 전"
      }
      if seconds % 60 == 0 {
        return "\(seconds / 60)분 전"
      }
      return "\(seconds)초 전"
    }
  }

  struct ParsedEventDraft: Equatable {
    public var title: String
    public var dateString: String
    public var startTime: String
    public var durationMinutesText: String
    public var alarms: [ScheduleAlarm]
    public var location: String
    public var notes: String
    public var isAllDay: Bool

    public init(
      title: String,
      dateString: String,
      startTime: String,
      durationMinutesText: String,
      alarms: [ScheduleAlarm],
      location: String,
      notes: String,
      isAllDay: Bool
    ) {
      self.title = title
      self.dateString = dateString
      self.startTime = startTime
      self.durationMinutesText = durationMinutesText
      self.alarms = Self.normalizedAlarms(alarms)
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
      self.alarms = Self.normalizedAlarms(parsedEvent.alarms)
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
        isAllDay: isAllDay,
        alarms: Self.normalizedAlarms(alarms)
      )
    }

    static func normalizedAlarms(_ alarms: [ScheduleAlarm]) -> [ScheduleAlarm] {
      Array(Set(alarms)).sorted(by: { $0.offset < $1.offset })
    }
  }
}
