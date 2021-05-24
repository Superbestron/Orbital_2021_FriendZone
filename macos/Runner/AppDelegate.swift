import Cocoa
import FlutterMacOS
import Firebase

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    return true
  }
}
