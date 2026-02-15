import Cocoa

final class SnapOverlayWindow: NSWindow {
    private let overlayView = SnapOverlayView()
    private var isShowing = false

    init() {
        super.init(
            contentRect: .zero,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        isOpaque = false
        backgroundColor = .clear
        level = .floating
        ignoresMouseEvents = true
        hasShadow = false
        collectionBehavior = [.canJoinAllSpaces, .stationary]
        contentView = overlayView
        alphaValue = 0
    }

    /// Show overlay at the given rect (in AX/top-left coordinate space).
    /// Converts to NSWindow coordinate space (bottom-left origin) for display.
    func show(at rect: CGRect) {
        let nsRect = rect.screenFlipped()

        if !isShowing {
            // First appearance: position instantly, then fade in
            setFrame(nsRect, display: true)
            orderFront(nil)
            isShowing = true

            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.15
                context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                self.animator().alphaValue = 1
            }
        } else {
            // Already visible: animate frame change smoothly (zone-to-zone transition)
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.2
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                self.animator().setFrame(nsRect, display: true)
            }
        }
    }

    func hide() {
        guard isShowing else { return }
        isShowing = false

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            self.animator().alphaValue = 0
        } completionHandler: {
            self.orderOut(nil)
        }
    }
}

private final class SnapOverlayView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }

        let insetRect = bounds.insetBy(dx: 4, dy: 4)
        let path = CGPath(roundedRect: insetRect, cornerWidth: 10, cornerHeight: 10, transform: nil)

        // Soft fill
        context.setFillColor(NSColor.controlAccentColor.withAlphaComponent(0.2).cgColor)
        context.addPath(path)
        context.fillPath()

        // Border
        context.setStrokeColor(NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor)
        context.setLineWidth(2)
        context.addPath(path)
        context.strokePath()
    }
}
