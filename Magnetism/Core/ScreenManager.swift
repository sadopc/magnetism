import Cocoa

@MainActor
final class ScreenManager {
    static let shared = ScreenManager()

    private init() {}

    /// All screens in a deterministic order: left-to-right, then top-to-bottom.
    /// Uses both X and Y to handle vertically stacked or same-X monitor layouts.
    var orderedScreens: [NSScreen] {
        NSScreen.screens.sorted {
            if $0.frame.origin.x != $1.frame.origin.x {
                return $0.frame.origin.x < $1.frame.origin.x
            }
            return $0.frame.origin.y < $1.frame.origin.y
        }
    }

    /// Find the screen that contains the center of the given rect (in AX/top-left coordinate space).
    func screenContaining(rect: CGRect) -> NSScreen? {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        for screen in NSScreen.screens {
            if screen.flippedFrame.contains(center) {
                return screen
            }
        }
        // Fallback: find closest screen
        return closestScreen(to: center)
    }

    /// Get adjacent screen in the given direction.
    func adjacentScreen(to current: NSScreen, direction: Direction) -> NSScreen? {
        let ordered = orderedScreens
        guard let index = ordered.firstIndex(of: current) else { return nil }
        switch direction {
        case .next:
            let nextIndex = index + 1
            return nextIndex < ordered.count ? ordered[nextIndex] : ordered.first
        case .previous:
            let prevIndex = index - 1
            return prevIndex >= 0 ? ordered[prevIndex] : ordered.last
        }
    }

    private func closestScreen(to point: CGPoint) -> NSScreen? {
        var closest: NSScreen?
        var minDistance = CGFloat.greatestFiniteMagnitude
        for screen in NSScreen.screens {
            let frame = screen.flippedFrame
            let cx = max(frame.minX, min(point.x, frame.maxX))
            let cy = max(frame.minY, min(point.y, frame.maxY))
            let distance = hypot(point.x - cx, point.y - cy)
            if distance < minDistance {
                minDistance = distance
                closest = screen
            }
        }
        return closest
    }

    enum Direction {
        case next, previous
    }
}
