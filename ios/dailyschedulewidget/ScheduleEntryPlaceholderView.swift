//
//  ScheduleEntryPlaceholderView.swift
//  Runner
//
//  Created by xamarin build on 10.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import SwiftUI

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
