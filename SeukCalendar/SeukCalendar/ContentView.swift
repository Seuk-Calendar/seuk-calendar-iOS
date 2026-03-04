//
//  ContentView.swift
//  SeukCalendar
//
//  Created by YoungK on 2/27/26.
//

import AI
import CalendarData
import CalendarDomain
import CalendarFeature
import SwiftUI

@MainActor
struct ContentView: View {
  @State private var widgetRoute = WidgetRoute()

  private let calendarViewFactory: CalendarViewFactory

  init() {
    let baseRepository: any ScheduleRepository = EventKitScheduleRepository()
    let repository: any ScheduleRepository = WidgetSyncingScheduleRepository(base: baseRepository)
    let parser: any ScheduleNaturalLanguageParser = FoundationModelsParser()
    self.calendarViewFactory = CalendarViewFactory(
      repository: repository,
      parser: parser
    )
  }

  var body: some View {
    calendarViewFactory
      .makeCalendarView(
        initialSelectedDate: widgetRoute.selectedDate,
        initialScheduleID: widgetRoute.scheduleID
      )
      .id(widgetRoute.renderID)
      .onOpenURL { url in
        guard let deepLink = WidgetScheduleDeepLink(url: url) else {
          return
        }

        widgetRoute = WidgetRoute(
          selectedDate: deepLink.selectedDate(),
          scheduleID: deepLink.scheduleID,
          renderID: UUID()
        )
      }
  }
}

#Preview {
  ContentView()
}

private struct WidgetRoute {
  var selectedDate: Date = Date()
  var scheduleID: String?
  var renderID: UUID = UUID()
}
