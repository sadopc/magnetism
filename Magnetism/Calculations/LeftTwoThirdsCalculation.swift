import Cocoa

struct LeftTwoThirdsCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x,
            y: visibleFrame.origin.y,
            width: (visibleFrame.width / 3) * 2,
            height: visibleFrame.height
        )
    }
}
