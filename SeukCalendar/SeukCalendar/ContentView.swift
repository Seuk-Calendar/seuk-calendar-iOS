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
  @Environment(\.scenePhase) private var scenePhase
  @State private var widgetRoute = WidgetRoute()

  private let calendarViewFactory: CalendarViewFactory
  private let scheduleRepository: WidgetSyncingScheduleRepository

  init() {
    let baseRepository: any ScheduleRepository = EventKitScheduleRepository()
    let scheduleRepository = WidgetSyncingScheduleRepository(base: baseRepository)
    let parser: any ScheduleNaturalLanguageParser = FoundationModelsParser()
    self.scheduleRepository = scheduleRepository
    self.calendarViewFactory = CalendarViewFactory(
      repository: scheduleRepository,
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
      .task {
        await scheduleRepository.refreshWidgetSnapshot()
      }
      .onChange(of: scenePhase) { _, newPhase in
        guard newPhase == .active else {
          return
        }

        Task {
          await scheduleRepository.refreshWidgetSnapshot()
        }
      }
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
