import CalendarDomain
import SwiftUI

@MainActor
public struct CalendarViewFactory {
  private let repository: any ScheduleRepository
  private let parser: any ScheduleNaturalLanguageParser

  public init(
    repository: any ScheduleRepository,
    parser: any ScheduleNaturalLanguageParser = UnavailableScheduleNaturalLanguageParser()
  ) {
    self.repository = repository
    self.parser = parser
  }

  @ViewBuilder
  public func makeCalendarView(
    initialSelectedDate: Date = Date(),
    initialScheduleID: String? = nil
  ) -> some View {
    CalendarView(
      viewModel: CalendarViewModel(
        selectedDate: initialSelectedDate,
        repository: repository,
        parser: parser
      ),
      initialScheduleID: initialScheduleID
    )
  }
}
