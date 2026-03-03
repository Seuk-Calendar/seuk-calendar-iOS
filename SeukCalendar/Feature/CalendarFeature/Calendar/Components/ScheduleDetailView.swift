import DesignSystem
import SwiftUI

struct ScheduleDetailView: View {
  let event: CalendarEvent

  var body: some View {
    List {
      Section("기본 정보") {
        row(title: "제목", value: event.title)
        row(title: "시간", value: timeText)
      }

      if let location = event.location, !location.isEmpty {
        Section("장소") {
          Text(location)
        }
      }

      if let notes = event.notes, !notes.isEmpty {
        Section("메모") {
          Text(notes)
            .lineLimit(nil)
        }
      }
    }
    .navigationTitle("일정 상세")
    .navigationBarTitleDisplayMode(.inline)
  }
}

private extension ScheduleDetailView {
  func row(title: String, value: String) -> some View {
    HStack(spacing: 8) {
      Text(title)
        .foregroundStyle(.secondary)
      Spacer(minLength: 8)
      Text(value)
        .multilineTextAlignment(.trailing)
    }
  }

  var timeText: String {
    if event.isAllDay {
      return "하루 종일"
    }

    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy.MM.dd a h:mm"
    return "\(formatter.string(from: event.startDate)) - \(formatter.string(from: event.endDate))"
  }
}
