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

struct ScheduleEntryPlaceholderView : View{
    var body: some View {
        return HStack(
            alignment: .top
        ) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.red.opacity(0.5))
                .frame(width:4, height:35)
            
            VStack(
                alignment: .leading
            ) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 10)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 7)
                }
            
            Spacer()
        }.padding(EdgeInsets(
            top: 0,
            leading: 0,
            bottom: 3,
            trailing: 0))
    }
}

struct ScheduleEntryView : View {
    let scheduleEntry: ScheduleEntry
    
    let colors: [Color] = [Color.gray, Color.red, Color.red, Color.gray, Color.yellow]
    
    var body: some View {
        let timeRange = scheduleEntry.start...scheduleEntry.end
        let color = colors[scheduleEntry.type]
        
        return HStack(
            alignment: .top
        ) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width:4, height:35)
            
            VStack(
                alignment: .center
            ) {
                Text(scheduleEntry.title)
                    .font(.caption)
                    .bold()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(timeRange)
                    .font(.caption)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }.padding(EdgeInsets(
            top: 0,
            leading: 0,
            bottom: 3,
            trailing: 0))
    }
}

struct dailyschedulewidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if(entry.isPlaceholder) {
                ScheduleEntryPlaceholderView()
                ScheduleEntryPlaceholderView()
            }
            else if(entry.entries.count > 0) {
                ForEach(entry.entries, id: \.id) { e in
                    ScheduleEntryView(
                        scheduleEntry: e
                    )
                }
                Spacer()
            }
            else {
                Text("Keine weiteren Vorlesungen")
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
