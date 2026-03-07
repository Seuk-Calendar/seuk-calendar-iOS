import Foundation

public extension WidgetMediumComponent {
  struct Configuration: Hashable, Sendable {
    public let title: String
    public let dayCells: [WidgetDayCellComponent.Configuration]

    public init(
      title: String,
      dayCells: [WidgetDayCellComponent.Configuration]
    ) {
      self.title = title
      self.dayCells = dayCells
    }
  }
}

extension WidgetMediumComponent.Configuration {
  var displayedDayCells: [WidgetDayCellComponent.Configuration] {
    Array(dayCells.prefix(7))
  }

  var isEmptyState: Bool {
    displayedDayCells.allSatisfy { !$0.hasSchedules }
  }
}
