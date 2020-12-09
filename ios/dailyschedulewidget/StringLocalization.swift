//
//  StringLocalization.swift
//  Runner
//
//  Created by xamarin build on 09.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation


extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
