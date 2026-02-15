import ServiceManagement
import os.log

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.magnetism.app", category: "LaunchOnLogin")

enum LaunchOnLogin {
    static var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    /// Attempt to register/unregister for launch at login.
    /// Returns `true` if the operation succeeded.
    @discardableResult
    static func setEnabled(_ enabled: Bool) -> Bool {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            return true
        } catch {
            logger.error("LaunchOnLogin failed to \(enabled ? "register" : "unregister"): \(error.localizedDescription)")
            return false
        }
    }
}
