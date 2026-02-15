import Cocoa

@MainActor
final class SnapManager {
    static let shared = SnapManager()

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let overlayWindow = SnapOverlayWindow()
    private var isDragging = false
    private var dragStartWindowOrigin: CGPoint?
    private var dragStartWindowSize: CGSize?
    private var currentSnapZone: SnapZone?

    private init() {}

    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: UserDefaultsKeys.snappingEnabled) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.snappingEnabled) }
    }

    func start() {
        guard eventTap == nil else { return }

        // Need to capture self for the C callback
        let selfPtr = Unmanaged.passUnretained(self).toOpaque()

        let mask: CGEventMask = (1 << CGEventType.leftMouseDown.rawValue)
            | (1 << CGEventType.leftMouseDragged.rawValue)
            | (1 << CGEventType.leftMouseUp.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: mask,
            callback: { _, type, event, userInfo in
                guard let userInfo = userInfo else { return Unmanaged.passUnretained(event) }
                let manager = Unmanaged<SnapManager>.fromOpaque(userInfo).takeUnretainedValue()
                DispatchQueue.main.async {
                    manager.handleEvent(type: type, event: event)
                }
                return Unmanaged.passUnretained(event)
            },
            userInfo: selfPtr
        ) else {
            print("SnapManager: Failed to create event tap. Accessibility permission may be missing.")
            return
        }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }

    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            if let source = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
            }
            eventTap = nil
            runLoopSource = nil
        }
        overlayWindow.hide()
        isDragging = false
        currentSnapZone = nil
    }

    private func handleEvent(type: CGEventType, event: CGEvent) {
        guard isEnabled else { return }

        switch type {
        case .leftMouseDown:
            handleMouseDown(event: event)
        case .leftMouseDragged:
            handleMouseDragged(event: event)
        case .leftMouseUp:
            handleMouseUp(event: event)
        default:
            break
        }
    }

    private func handleMouseDown(event: CGEvent) {
        isDragging = false
        currentSnapZone = nil
        // Capture current focused window state for drag detection
        if let window = AccessibilityElement.focusedWindow(),
           let frame = window.frame {
            dragStartWindowOrigin = frame.origin
            dragStartWindowSize = frame.size
        }
    }

    private func handleMouseDragged(event: CGEvent) {
        guard let startOrigin = dragStartWindowOrigin,
              let startSize = dragStartWindowSize else { return }

        // Check if we're actually dragging a window (size unchanged, origin changed)
        if let window = AccessibilityElement.focusedWindow(),
           let frame = window.frame {
            let sizeChanged = abs(frame.width - startSize.width) > 5 || abs(frame.height - startSize.height) > 5
            let originChanged = abs(frame.origin.x - startOrigin.x) > 5 || abs(frame.origin.y - startOrigin.y) > 5

            if sizeChanged {
                // Resizing, not dragging
                if isDragging {
                    overlayWindow.hide()
                    isDragging = false
                    currentSnapZone = nil
                }
                return
            }

            if originChanged {
                isDragging = true
            }
        }

        guard isDragging else { return }

        let mouseLocation = event.location

        if let zone = SnapZoneDetector.detect(mouseLocation: mouseLocation) {
            if currentSnapZone?.action != zone.action {
                currentSnapZone = zone
                overlayWindow.show(at: zone.rect)
            }
        } else {
            if currentSnapZone != nil {
                currentSnapZone = nil
                overlayWindow.hide()
            }
        }
    }

    private func handleMouseUp(event: CGEvent) {
        defer {
            isDragging = false
            dragStartWindowOrigin = nil
            dragStartWindowSize = nil
            overlayWindow.hide()
        }

        guard isDragging, let zone = currentSnapZone else { return }
        currentSnapZone = nil
        WindowManager.shared.execute(zone.action)
    }
}
