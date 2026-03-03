import SwiftUI

@MainActor
public struct CalendarViewFactory {
  private let makeViewModel: () -> CalendarViewModel

  public init() {
    self.makeViewModel = { CalendarViewModel() }
  }

  public init(
    makeViewModel: @escaping () -> CalendarViewModel
  ) {
    self.makeViewModel = makeViewModel
  }

  @ViewBuilder
  public func makeCalendarView() -> some View {
    CalendarView(viewModel: makeViewModel())
  }
}
