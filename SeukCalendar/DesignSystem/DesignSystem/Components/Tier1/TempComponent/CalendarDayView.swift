import SwiftUI

public struct CalendarDayView: View {
  public let date: Date
  public let events: [CalendarEvent]
  public var calendar: Calendar
  public var showDateHeader: Bool
  public var wrapsContentInScrollView: Bool
  public var onSelectEvent: (CalendarEvent) -> Void

  public init(
    date: Date,
    events: [CalendarEvent],
    calendar: Calendar = .current,
    showDateHeader: Bool = true,
    wrapsContentInScrollView: Bool = true,
    onSelectEvent: @escaping (CalendarEvent) -> Void
  ) {
    self.date = date
    self.events = events
    self.calendar = calendar
    self.showDateHeader = showDateHeader
    self.wrapsContentInScrollView = wrapsContentInScrollView
    self.onSelectEvent = onSelectEvent
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      if showDateHeader {
        Text(dayHeaderText)
          .font(.system(size: 17, weight: .semibold))
          .foregroundStyle(.primary)
      }

      if events.isEmpty {
        emptyState
      } else if wrapsContentInScrollView {
        ScrollView(showsIndicators: false) {
          contentSections
        }
      } else {
        contentSections
      }
    }
  }
}

private extension CalendarDayView {
  var emptyState: some View {
    Text("해당 날짜에 일정이 없습니다.")
      .font(.system(size: 14, weight: .regular))
      .foregroundStyle(.secondary)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 12)
  }

  var contentSections: some View {
    VStack(alignment: .leading, spacing: 14) {
      allDaySection
      hourlyTimeline
    }
  }

  var dayHeaderText: String {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateFormat = "M월 d일 EEEE"
    return formatter.string(from: date)
  }

  var sortedEvents: [CalendarEvent] {
    events.sorted { lhs, rhs in
      if lhs.startDate == rhs.startDate {
        return lhs.title < rhs.title
      }

      return lhs.startDate < rhs.startDate
    }
  }

  var allDaySection: some View {
    let allDayEvents = sortedEvents.filter(\.isAllDay)

    return Group {
      if !allDayEvents.isEmpty {
        VStack(alignment: .leading, spacing: 8) {
          Text("하루 종일")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.secondary)

          ForEach(allDayEvents) { event in
            ScheduleCard(event: event) {
              onSelectEvent(event)
            }
          }
        }
      }
    }
  }

  var hourlyTimeline: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(Array(0 ..< 24), id: \.self) { hour in
        HStack(alignment: .top, spacing: 10) {
          Text(hourLabel(hour))
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(.secondary)
            .frame(width: 38, alignment: .trailing)
            .padding(.top, 8)

          VStack(alignment: .leading, spacing: 8) {
            Rectangle()
              .fill(Color.secondary.opacity(0.24))
              .frame(height: 1)

            let hourEvents = timedEvents(at: hour)
            if !hourEvents.isEmpty {
              ForEach(hourEvents) { event in
                ScheduleCard(event: event) {
                  onSelectEvent(event)
                }
              }
            }
          }
        }
      }
    }
  }

  func timedEvents(at hour: Int) -> [CalendarEvent] {
    sortedEvents.filter {
      !$0.isAllDay && calendar.component(.hour, from: $0.startDate) == hour
    }
  }

  func hourLabel(_ hour: Int) -> String {
    String(format: "%02d:00", hour)
  }
}
