import SwiftUI

public struct ScheduleCard: View {
  public let event: CalendarEvent
  public var action: (() -> Void)?

  public init(
    event: CalendarEvent,
    action: (() -> Void)? = nil
  ) {
    self.event = event
    self.action = action
  }

  public var body: some View {
    Button(
      action: { action?() },
      label: {
        HStack(alignment: .top, spacing: 12) {
          RoundedRectangle(cornerRadius: 2, style: .continuous)
            .fill(.blue)
            .frame(width: 4, height: 42)

          VStack(alignment: .leading, spacing: 4) {
            Text(event.title.isEmpty ? "제목 없음" : event.title)
              .font(.system(size: 15, weight: .semibold))
              .foregroundStyle(.primary)
              .lineLimit(1)

            Text(timeText)
              .font(.system(size: 12, weight: .regular))
              .foregroundStyle(.secondary)
              .lineLimit(1)

            if let location = event.location, !location.isEmpty {
              Text(location)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
          }

          Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.primary.opacity(0.06))
        )
      }
    )
    .buttonStyle(.plain)
  }
}

private extension ScheduleCard {
  var timeText: String {
    if event.isAllDay {
      return "하루 종일"
    }

    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateFormat = "a h:mm"
    return "\(formatter.string(from: event.startDate)) - \(formatter.string(from: event.endDate))"
  }
}
