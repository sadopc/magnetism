import Cocoa

@MainActor
final class WindowManager {
    static let shared = WindowManager()

    private init() {}

    func execute(_ action: WindowAction) {
        guard AccessibilityPermission.isTrusted else {
            AccessibilityPermission.promptForAccess()
            return
        }

        guard let window = AccessibilityElement.focusedWindow() else { return }
        guard let currentFrame = window.frame else { return }

        // Handle Enhanced User Interface (Terminal.app workaround)
        let wasEnhancedUI = window.isEnhancedUserInterfaceEnabled == true
        if wasEnhancedUI {
            window.isEnhancedUserInterfaceEnabled = false
        }
        defer {
            if wasEnhancedUI {
                window.isEnhancedUserInterfaceEnabled = true
            }
        }

        switch action {
        case .restore:
            executeRestore(window: window)
        case .nextDisplay:
            executeMoveDisplay(window: window, currentFrame: currentFrame, direction: .next)
        case .previousDisplay:
            executeMoveDisplay(window: window, currentFrame: currentFrame, direction: .previous)
        default:
            executeSnap(action: action, window: window, currentFrame: currentFrame)
        }
    }

    private func executeSnap(action: WindowAction, window: AccessibilityElement, currentFrame: CGRect) {
        guard let screen = ScreenManager.shared.screenContaining(rect: currentFrame) else { return }
        guard let calculation = WindowCalculationFactory.calculation(for: action) else { return }

        let visibleFrame = screen.flippedVisibleFrame
        let targetRect = calculation.calculateRect(visibleFrame: visibleFrame, windowFrame: currentFrame)

        // Save current frame for restore
        if let windowID = window.windowID {
            WindowHistory.shared.save(windowID: windowID, frame: currentFrame)
        }

        animateWindow(window, to: targetRect)
    }

    private func executeRestore(window: AccessibilityElement) {
        guard let windowID = window.windowID else { return }
        guard let savedFrame = WindowHistory.shared.restore(windowID: windowID) else { return }
        animateWindow(window, to: savedFrame)
    }

    private func executeMoveDisplay(window: AccessibilityElement, currentFrame: CGRect, direction: ScreenManager.Direction) {
        guard let currentScreen = ScreenManager.shared.screenContaining(rect: currentFrame) else { return }
        guard let targetScreen = ScreenManager.shared.adjacentScreen(to: currentScreen, direction: direction) else { return }

        let sourceVisible = currentScreen.flippedVisibleFrame
        let targetVisible = targetScreen.flippedVisibleFrame

        // Calculate proportional position on target display
        let relativeX = (currentFrame.origin.x - sourceVisible.origin.x) / sourceVisible.width
        let relativeY = (currentFrame.origin.y - sourceVisible.origin.y) / sourceVisible.height
        let relativeW = currentFrame.width / sourceVisible.width
        let relativeH = currentFrame.height / sourceVisible.height

        let newRect = CGRect(
            x: targetVisible.origin.x + relativeX * targetVisible.width,
            y: targetVisible.origin.y + relativeY * targetVisible.height,
            width: relativeW * targetVisible.width,
            height: relativeH * targetVisible.height
        )

        if let windowID = window.windowID {
            WindowHistory.shared.save(windowID: windowID, frame: currentFrame)
        }

        // Cross-display moves: skip animation, just snap (avoids weird mid-flight frames)
        window.frame = newRect
    }

    private nonisolated func animateWindow(_ window: AccessibilityElement, to target: CGRect) {
        // Run animation off the main thread so the stepped sleeps don't block UI
        DispatchQueue.global(qos: .userInteractive).async {
            window.animateFrame(to: target)
        }
    }
}
