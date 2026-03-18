//
//  SeukCalendarApp.swift
//  SeukCalendar
//
//  Created by YoungK on 2/27/26.
//

import DesignSystem
import SwiftUI

@main
struct SeukCalendarApp: App {
  init() {
    FontManager.shared.register()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
