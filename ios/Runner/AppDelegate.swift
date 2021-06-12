import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAhNU3sIYHFdd20rDD6r7nwk54jbeEeUio")
    FirebaseApp.configure()
    return true
  }
}
