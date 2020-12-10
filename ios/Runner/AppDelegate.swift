import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UIApplication.shared.isStatusBarHidden = false
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))

    registerMethodCannel()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func registerMethodCannel() {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        WidgetPlatformChannel().register(controller: controller)
    }
}
