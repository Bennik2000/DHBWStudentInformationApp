//
//  DailyScheduleWidgetNotEnabled.swift
//  Runner
//
//  Created by xamarin build on 10.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import SwiftUI

struct DailyScheduleWidgetNotEnabled : View {
    var body: some View {
        ZStack {
            VStack {
                ScheduleEntryPlaceholderView()
                ScheduleEntryPlaceholderView()
            }
            ZStack() {
                Text("EnableProForWidget".localized)
                    .background(Color.white.opacity(0.8))
                    .padding(EdgeInsets.init(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
        }
    }
}
