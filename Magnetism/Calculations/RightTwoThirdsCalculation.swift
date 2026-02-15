import Cocoa

struct RightTwoThirdsCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x + visibleFrame.width / 3,
            y: visibleFrame.origin.y,
            width: (visibleFrame.width / 3) * 2,
            height: visibleFrame.height
        )
    }
}
