import Cocoa
import ApplicationServices

// Private API to get CGWindowID from AXUIElement
@_silgen_name("_AXUIElementGetWindow")
func _AXUIElementGetWindow(_ element: AXUIElement, _ windowID: UnsafeMutablePointer<CGWindowID>) -> AXError

final class AccessibilityElement {
    let element: AXUIElement

    init(_ element: AXUIElement) {
        self.element = element
    }

    // MARK: - Static Constructors

    static func frontmostApplication() -> AccessibilityElement? {
        guard let app = NSWorkspace.shared.frontmostApplication else { return nil }
        let element = AXUIElementCreateApplication(app.processIdentifier)
        return AccessibilityElement(element)
    }

    static func focusedWindow() -> AccessibilityElement? {
        guard let app = frontmostApplication() else { return nil }
        var windowRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(app.element, kAXFocusedWindowAttribute as CFString, &windowRef)
        guard result == .success,
              let window = windowRef,
              CFGetTypeID(window) == AXUIElementGetTypeID() else { return nil }
        return AccessibilityElement(window as! AXUIElement)
    }

    // MARK: - Properties

    var position: CGPoint? {
        get {
            var ref: CFTypeRef?
            let result = AXUIElementCopyAttributeValue(element, kAXPositionAttribute as CFString, &ref)
            guard result == .success, let ref = ref, CFGetTypeID(ref) == AXValueGetTypeID() else { return nil }
            var point = CGPoint.zero
            guard AXValueGetValue(ref as! AXValue, .cgPoint, &point) else { return nil }
            return point
        }
        set {
            guard var point = newValue else { return }
            guard let value = AXValueCreate(.cgPoint, &point) else { return }
            AXUIElementSetAttributeValue(element, kAXPositionAttribute as CFString, value)
        }
    }

    var size: CGSize? {
        get {
            var ref: CFTypeRef?
            let result = AXUIElementCopyAttributeValue(element, kAXSizeAttribute as CFString, &ref)
            guard result == .success, let ref = ref, CFGetTypeID(ref) == AXValueGetTypeID() else { return nil }
            var size = CGSize.zero
            guard AXValueGetValue(ref as! AXValue, .cgSize, &size) else { return nil }
            return size
        }
        set {
            guard var size = newValue else { return }
            guard let value = AXValueCreate(.cgSize, &size) else { return }
            AXUIElementSetAttributeValue(element, kAXSizeAttribute as CFString, value)
        }
    }

    var frame: CGRect? {
        get {
            guard let position = position, let size = size else { return nil }
            return CGRect(origin: position, size: size)
        }
        set {
            guard let rect = newValue else { return }
            // Triple-set pattern for cross-display moves:
            // macOS enforces per-display size limits, so we must set size, then position, then size again.
            size = rect.size
            position = rect.origin
            size = rect.size
        }
    }

    /// Animate frame change with ease-out curve for buttery-smooth movement.
    func animateFrame(to target: CGRect, duration: TimeInterval = 0.2, steps: Int = 12) {
        guard let start = frame else {
            frame = target
            return
        }

        // If the window is already at the target, skip
        if start.equalTo(target) { return }

        let stepDuration = duration / Double(steps)

        for i in 1...steps {
            let t = Double(i) / Double(steps)
            // Ease-out cubic: 1 - (1-t)^3
            let eased = 1.0 - pow(1.0 - t, 3)

            let interpolated = CGRect(
                x: start.origin.x + (target.origin.x - start.origin.x) * eased,
                y: start.origin.y + (target.origin.y - start.origin.y) * eased,
                width: start.width + (target.width - start.width) * eased,
                height: start.height + (target.height - start.height) * eased
            )

            // Set size first, then position, then size (triple-set for cross-display)
            size = interpolated.size
            position = interpolated.origin
            if i == steps {
                size = target.size
            }

            Thread.sleep(forTimeInterval: stepDuration)
        }

        // Final precise snap to exact target
        size = target.size
        position = target.origin
        size = target.size
    }

    // MARK: - Enhanced User Interface (Terminal.app workaround)

    var isEnhancedUserInterfaceEnabled: Bool? {
        get {
            guard let app = Self.frontmostApplication() else { return nil }
            var ref: CFTypeRef?
            let result = AXUIElementCopyAttributeValue(app.element, "AXEnhancedUserInterface" as CFString, &ref)
            guard result == .success, let value = ref as? Bool else { return nil }
            return value
        }
        set {
            guard let app = Self.frontmostApplication(), let value = newValue else { return }
            AXUIElementSetAttributeValue(app.element, "AXEnhancedUserInterface" as CFString, value as CFTypeRef)
        }
    }

    // MARK: - Window ID

    var windowID: CGWindowID? {
        var windowID: CGWindowID = 0
        let result = _AXUIElementGetWindow(element, &windowID)
        return result == .success ? windowID : nil
    }
}
