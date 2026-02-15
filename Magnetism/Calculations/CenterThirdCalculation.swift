import Cocoa

struct CenterThirdCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x + visibleFrame.width / 3,
            y: visibleFrame.origin.y,
            width: visibleFrame.width / 3,
            height: visibleFrame.height
        )
    }
}
