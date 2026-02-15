import Cocoa

extension NSScreen {
    /// Convert NSScreen frame (bottom-left origin) to AX API coordinate space (top-left origin).
    var flippedVisibleFrame: CGRect {
        let primaryScreen = NSScreen.screens.first!
        let primaryHeight = primaryScreen.frame.height
        let visibleFrame = self.visibleFrame
        return CGRect(
            x: visibleFrame.origin.x,
            y: primaryHeight - visibleFrame.origin.y - visibleFrame.height,
            width: visibleFrame.width,
            height: visibleFrame.height
        )
    }

    var flippedFrame: CGRect {
        let primaryScreen = NSScreen.screens.first!
        let primaryHeight = primaryScreen.frame.height
        return CGRect(
            x: frame.origin.x,
            y: primaryHeight - frame.origin.y - frame.height,
            width: frame.width,
            height: frame.height
        )
    }
}

extension CGRect {
    /// Convert a rect from NS coordinate space (bottom-left origin) to screen-flipped (top-left origin).
    func screenFlipped() -> CGRect {
        guard let primaryScreen = NSScreen.screens.first else { return self }
        let primaryHeight = primaryScreen.frame.height
        return CGRect(
            x: origin.x,
            y: primaryHeight - origin.y - height,
            width: width,
            height: height
        )
    }
}
