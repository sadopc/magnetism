import Cocoa

struct CenterCalculation: WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect {
        CGRect(
            x: visibleFrame.origin.x + (visibleFrame.width - windowFrame.width) / 2,
            y: visibleFrame.origin.y + (visibleFrame.height - windowFrame.height) / 2,
            width: windowFrame.width,
            height: windowFrame.height
        )
    }
}
