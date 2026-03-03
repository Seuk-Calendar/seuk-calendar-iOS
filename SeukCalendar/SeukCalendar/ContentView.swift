//
//  ContentView.swift
//  SeukCalendar
//
//  Created by YoungK on 2/27/26.
//

import CalendarFeature
import SwiftUI

@MainActor
struct ContentView: View {
  private let calendarViewFactory = CalendarViewFactory()

  var body: some View {
    calendarViewFactory.makeCalendarView()
  }
}

#Preview {
    ContentView()
}
