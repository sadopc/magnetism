import Cocoa

struct BottomRightQuarterCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x + visibleFrame.width / 2,
            y: visibleFrame.origin.y + visibleFrame.height / 2,
            width: visibleFrame.width / 2,
            height: visibleFrame.height / 2
        )
    }
}
