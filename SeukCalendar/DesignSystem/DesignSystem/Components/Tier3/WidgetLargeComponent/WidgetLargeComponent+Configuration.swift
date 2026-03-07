import Foundation

public extension WidgetLargeComponent {
  struct Configuration: Hashable, Sendable {
    public let title: String
    public let weeks: [[WidgetDayCellComponent.Configuration]]

    public init(
      title: String,
      weeks: [[WidgetDayCellComponent.Configuration]]
    ) {
      self.title = title
      self.weeks = weeks
    }
  }
}

extension WidgetLargeComponent.Configuration {
  var displayedWeeks: [[WidgetDayCellComponent.Configuration]] {
    Array(weeks.prefix(5)).map { Array($0.prefix(7)) }
  }
}
