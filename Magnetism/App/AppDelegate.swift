import Cocoa

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    let menuBarManager = MenuBarManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Only prompt for accessibility if not already trusted
        if !AccessibilityPermission.isTrusted {
            AccessibilityPermission.promptForAccess()
        }

        // Set up menu bar
        menuBarManager.setup()

        // Register keyboard shortcuts
        ShortcutManager.shared.registerAll()

        // Start drag-to-edge snapping if enabled
        let snappingEnabled = UserDefaults.standard.object(forKey: UserDefaultsKeys.snappingEnabled) as? Bool ?? true
        if snappingEnabled {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.snappingEnabled)
            SnapManager.shared.start()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        SnapManager.shared.stop()
    }
}
