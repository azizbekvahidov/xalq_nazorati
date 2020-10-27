import UIKit
import Flutter
import GoogleMaps
import YandexMapKit
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDXPBpKelAQdT0nHHWW4LoZs78JpHeIn4s")
    YMKMapKit.setApiKey("c8faaaf7-6b6b-44ba-84a8-e298a0e513b3")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
