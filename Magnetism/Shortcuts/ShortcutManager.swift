import KeyboardShortcuts

@MainActor
final class ShortcutManager {
    static let shared = ShortcutManager()

    private init() {}

    func registerAll() {
        for action in WindowAction.allCases {
            let name = action.shortcutName
            KeyboardShortcuts.onKeyUp(for: name) { [weak self] in
                self?.handleAction(action)
            }
        }
    }

    private func handleAction(_ action: WindowAction) {
        WindowManager.shared.execute(action)
    }
}
