import Cocoa
import KeyboardShortcuts

@MainActor
final class MenuBarManager: NSObject {
    private var statusItem: NSStatusItem!

    func setup() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "rectangle.split.2x2", accessibilityDescription: "Magnetism")
            button.image?.size = NSSize(width: 18, height: 18)
            button.image?.isTemplate = true
        }

        statusItem.menu = buildMenu()
    }

    func rebuildMenu() {
        statusItem?.menu = buildMenu()
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()

        for category in WindowAction.Category.allCases {
            let actionsInCategory = WindowAction.allCases.filter { $0.category == category }
            if actionsInCategory.isEmpty { continue }

            if menu.items.count > 0 {
                menu.addItem(.separator())
            }

            for action in actionsInCategory {
                let item = NSMenuItem(
                    title: action.displayName,
                    action: #selector(menuItemClicked(_:)),
                    keyEquivalent: ""
                )
                item.target = self
                item.representedObject = action.rawValue
                menu.addItem(item)
            }
        }

        menu.addItem(.separator())

        let prefsItem = NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: ",")
        prefsItem.target = self
        menu.addItem(prefsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Quit Magnetism", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        return menu
    }

    @objc private func menuItemClicked(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let action = WindowAction(rawValue: rawValue) else { return }
        WindowManager.shared.execute(action)
    }

    @objc private func openPreferences() {
        PreferencesWindowController.shared.show()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}

