//
//  WidgetPlatformChannel.swift
//  Runner
//
//  Created by xamarin build on 10.12.20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class WidgetPlatformChannel {
    func register(controller: FlutterViewController) {
        let widgetPlatformChannel = FlutterMethodChannel(
            name:"de.bennik2000.dhbwstudentapp/widget",
            binaryMessenger: controller.binaryMessenger)
        
        widgetPlatformChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if(call.method == "enableWidget") {
                WidgetUserDefaults().enableWidget()
                result(nil)
            }
            else if(call.method == "disableWidget") {
                WidgetUserDefaults().disableWidget()
                result(nil)
            }
            else if (call.method == "areWidgetsSupported") {
                if #available(iOS 14.0, *) {
                    result(true)
                }
                else {
                    result(false)
                }
            }
        })
    }
}
