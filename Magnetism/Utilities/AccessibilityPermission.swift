import Cocoa
import ApplicationServices

enum AccessibilityPermission {
    static var isTrusted: Bool {
        AXIsProcessTrusted()
    }

    /// Show the system accessibility prompt. Only call when isTrusted is false.
    static func promptForAccess() {
        let options = ["AXTrustedCheckOptionPrompt": true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }
}
