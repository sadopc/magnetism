import Cocoa

struct TopLeftQuarterCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x,
            y: visibleFrame.origin.y,
            width: visibleFrame.width / 2,
            height: visibleFrame.height / 2
        )
    }
}
