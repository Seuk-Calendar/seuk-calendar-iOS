//
//  SeukCalendarTimelineProvider.swift
//  SeukCalendar
//
//  Created by YoungK on 6/1/26.
//

import SwiftUI
import WidgetKit

struct SeukCalendarTimelineProvider: TimelineProvider {
  func placeholder(in context: Context) -> SeukCalendarEntry {
    let placeholderDate = WidgetScheduleSnapshot.placeholderReferenceDate
    return SeukCalendarEntry(
      date: placeholderDate,
      snapshot: .placeholder(for: placeholderDate),
      showsPlaceholderPreview: true
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (SeukCalendarEntry) -> Void) {
    Task {
      let referenceDate = Date()
      let dataSource = WidgetScheduleDataSource()
      let snapshot = dataSource.loadSnapshot(referenceDate: referenceDate)
      let placeholderDate = WidgetScheduleSnapshot.placeholderReferenceDate
      let isPlaceholderPreview = context.isPreview && snapshot == nil
      let resolvedSnapshot = snapshot ?? (isPlaceholderPreview ? .placeholder(for: placeholderDate) : .empty)
      let entryDate = isPlaceholderPreview ? placeholderDate : referenceDate

      completion(
        SeukCalendarEntry(
          date: entryDate,
          snapshot: resolvedSnapshot,
          showsPlaceholderPreview: isPlaceholderPreview
        )
      )
    }
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<SeukCalendarEntry>) -> Void) {
    Task {
      let referenceDate = Date()
      let snapshot = WidgetScheduleDataSource().loadSnapshot(referenceDate: referenceDate) ?? .empty
      let entry = SeukCalendarEntry(
        date: referenceDate,
        snapshot: snapshot,
        showsPlaceholderPreview: false
      )
      let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: referenceDate)
        ?? referenceDate.addingTimeInterval(300)
      completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
  }
}
