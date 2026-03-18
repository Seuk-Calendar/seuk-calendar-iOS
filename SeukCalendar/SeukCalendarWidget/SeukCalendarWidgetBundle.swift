import DesignSystem
import SwiftUI
import WidgetKit

@main
struct SeukCalendarWidgetBundle: SwiftUI.WidgetBundle {
  init() {
    FontManager.shared.register()
  }

  var body: some SwiftUI.Widget {
    SeukCalendarWidget()
  }
}
