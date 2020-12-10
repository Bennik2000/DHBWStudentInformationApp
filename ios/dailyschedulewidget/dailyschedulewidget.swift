//
//  dailyschedulewidget.swift
//  dailyschedulewidget
//
//  Created by xamarin build on 03.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents



struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    configuration: ConfigurationIntent(),
                    entries: [],
                    isPlaceholder: true
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let midnight: Date = Calendar.current.startOfDay(
            for: Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: Date())!)
        
        let scheduleEntries = Array(ScheduleEntryAccess()
                                        .queryScheduleEntriesBetween(dateStart: Date(), dateEnd: midnight).prefix(3))
        
        let entry = SimpleEntry(date: Date(),
                                configuration: configuration,
                                entries: scheduleEntries,
                                isPlaceholder: false)
        
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var timelineEntries: [SimpleEntry] = []
        let midnight: Date = Calendar.current.startOfDay(
            for: Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: Date())!)
        
        let scheduleEntries = Array(ScheduleEntryAccess().queryScheduleEntriesBetween(dateStart: Date(), dateEnd: midnight).prefix(3))
        
        // From now on show all entries
        timelineEntries.append(SimpleEntry(
            date: Date(),
            configuration: configuration,
            entries: scheduleEntries,
            isPlaceholder: false))
        
        var i = 0
        for scheduleEntry in scheduleEntries {
            
            // For every entry add two timeline entries
            // one for the beginning and one for the end
            timelineEntries.append(SimpleEntry(
                                    date: scheduleEntry.start,
                                    configuration: configuration,
                                    entries: scheduleEntries.suffix(scheduleEntries.count - i),
                                    isPlaceholder: false))
            
            i += 1
            
            timelineEntries.append(SimpleEntry(
                                    date: scheduleEntry.end,
                                    configuration: configuration,
                                    entries: scheduleEntries.suffix(scheduleEntries.count - i),
                                    isPlaceholder: false))
        }
        
        completion(Timeline(entries: timelineEntries, policy: .after(midnight)))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let entries: [ScheduleEntry]
    let isPlaceholder: Bool
}

struct dailyschedulewidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if(entry.isPlaceholder) {
                DailyScheduleWidgetPlaceholder()
            }
            else if(!WidgetUserDefaults().isWidgetEnabled()){
                DailyScheduleWidgetNotEnabled()
            }
            else if(entry.entries.count > 0) {
                DailyScheduleWidgetContent(entries: entry.entries)
            }
            else {
                DailyScheduleWidgetEmptyState()
            }

        }
        .padding(
            EdgeInsets(
                top: 14, leading: 14, bottom: 14, trailing: 14
            )
        )
    }
}


@main
struct dailyschedulewidget: Widget {
    let kind: String = "dailyschedulewidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()
        ) { entry in
            dailyschedulewidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Schedule")
        .description("Shows the daily schedule")
        .supportedFamilies([
            WidgetFamily.systemMedium,
            WidgetFamily.systemSmall
        ])
    }
}

struct dailyschedulewidget_Previews: PreviewProvider {
    static var previews: some View {
        dailyschedulewidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                configuration: ConfigurationIntent(),
                entries: [],
                isPlaceholder: true)
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
