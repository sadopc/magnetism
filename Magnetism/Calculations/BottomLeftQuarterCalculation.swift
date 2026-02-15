import Cocoa

struct BottomLeftQuarterCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x,
            y: visibleFrame.origin.y + visibleFrame.height / 2,
            width: visibleFrame.width / 2,
            height: visibleFrame.height / 2
        )
    }
}
