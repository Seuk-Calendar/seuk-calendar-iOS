import SwiftUI

@MainActor
public struct CalendarViewFactory {
  public init() {}

  @ViewBuilder
  public func makeCalendarView() -> some View {
    CalendarView()
  }
}
