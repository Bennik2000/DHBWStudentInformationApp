//
//  DailyScheduleWidgetContent.swift
//  Runner
//
//  Created by xamarin build on 10.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import SwiftUI

struct DailyScheduleWidgetContent : View {
    let entries: [ScheduleEntry]
    
    var body: some View {
        ForEach(entries, id: \.id) { e in
            ScheduleEntryView(
                scheduleEntry: e
            )
        }
        Spacer()
    }
}
