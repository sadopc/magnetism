import Cocoa
import SwiftUI

@MainActor
final class PreferencesWindowController {
    static let shared = PreferencesWindowController()

    private var window: NSWindow?

    private init() {}

    func show() {
        if let window = window {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate()
            return
        }

        let preferencesView = PreferencesView()
        let hostingController = NSHostingController(rootView: preferencesView)

        let window = NSWindow(contentViewController: hostingController)
        window.title = "Magnetism Preferences"
        window.styleMask = [.titled, .closable]
        window.setContentSize(NSSize(width: 480, height: 400))
        window.center()
        window.isReleasedWhenClosed = false

        self.window = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate()
    }
}
