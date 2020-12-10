//
//  ScheduleEntryView.swift
//  Runner
//
//  Created by xamarin build on 10.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import SwiftUI

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
