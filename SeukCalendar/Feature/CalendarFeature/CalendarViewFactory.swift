import CalendarDomain
import SwiftUI

@MainActor
public struct CalendarViewFactory {
  private let repository: any ScheduleRepository

  public init(repository: any ScheduleRepository) {
    self.repository = repository
  }

  @ViewBuilder
  public func makeCalendarView() -> some View {
    CalendarView(viewModel: CalendarViewModel(repository: repository))
  }
}
