import Cocoa

struct TopRightQuarterCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x + visibleFrame.width / 2,
            y: visibleFrame.origin.y,
            width: visibleFrame.width / 2,
            height: visibleFrame.height / 2
        )
    }
}
