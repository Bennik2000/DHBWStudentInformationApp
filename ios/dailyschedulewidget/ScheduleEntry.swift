//
//  scheduleentry.swift
//  Runner
//
//  Created by xamarin build on 04.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

public struct ScheduleEntry : Identifiable {
    public let id: Int
    public let start: Date
    public let end: Date
    public let details: String
    public let professor: String
    public let room: String
    public let title: String
    public let type: Int
}
