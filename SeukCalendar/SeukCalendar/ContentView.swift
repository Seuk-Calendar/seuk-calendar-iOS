//
//  ContentView.swift
//  SeukCalendar
//
//  Created by YoungK on 2/27/26.
//

import CalendarData
import CalendarDomain
import CalendarFeature
import SwiftUI

@MainActor
struct ContentView: View {
  private let calendarViewFactory: CalendarViewFactory

  init() {
    let repository: any ScheduleRepository = EventKitScheduleRepository()
    self.calendarViewFactory = CalendarViewFactory(repository: repository)
  }

  var body: some View {
    calendarViewFactory.makeCalendarView()
  }
}

#Preview {
    ContentView()
}
