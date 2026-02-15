import Cocoa

struct TopHalfCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x,
            y: visibleFrame.origin.y,
            width: visibleFrame.width,
            height: visibleFrame.height / 2
        )
    }
}
