import Cocoa

struct BottomHalfCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x,
            y: visibleFrame.origin.y + visibleFrame.height / 2,
            width: visibleFrame.width,
            height: visibleFrame.height / 2
        )
    }
}
