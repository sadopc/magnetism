import Cocoa

struct SnapZone {
    let action: WindowAction
    let rect: CGRect
}

final class SnapZoneDetector {
    private static let edgeThreshold: CGFloat = 2
    private static let cornerSize: CGFloat = 100

    /// Detect snap zone based on mouse position (in screen/top-left coordinates).
    static func detect(mouseLocation: CGPoint) -> SnapZone? {
        for screen in NSScreen.screens {
            let frame = screen.flippedFrame

            guard mouseLocation.x >= frame.minX - edgeThreshold,
                  mouseLocation.x <= frame.maxX + edgeThreshold,
                  mouseLocation.y >= frame.minY - edgeThreshold,
                  mouseLocation.y <= frame.maxY + edgeThreshold else {
                continue
            }

            let atLeft = mouseLocation.x <= frame.minX + edgeThreshold
            let atRight = mouseLocation.x >= frame.maxX - edgeThreshold
            let atTop = mouseLocation.y <= frame.minY + edgeThreshold
            let atBottom = mouseLocation.y >= frame.maxY - edgeThreshold

            let nearTop = mouseLocation.y <= frame.minY + cornerSize
            let nearBottom = mouseLocation.y >= frame.maxY - cornerSize

            let visibleFrame = screen.flippedVisibleFrame

            // Corners first (higher priority)
            if atLeft && nearTop {
                return SnapZone(action: .topLeftQuarter, rect: topLeftQuarterRect(visibleFrame))
            }
            if atLeft && nearBottom {
                return SnapZone(action: .bottomLeftQuarter, rect: bottomLeftQuarterRect(visibleFrame))
            }
            if atRight && nearTop {
                return SnapZone(action: .topRightQuarter, rect: topRightQuarterRect(visibleFrame))
            }
            if atRight && nearBottom {
                return SnapZone(action: .bottomRightQuarter, rect: bottomRightQuarterRect(visibleFrame))
            }

            // Edges
            if atLeft {
                return SnapZone(action: .leftHalf, rect: leftHalfRect(visibleFrame))
            }
            if atRight {
                return SnapZone(action: .rightHalf, rect: rightHalfRect(visibleFrame))
            }
            if atTop {
                return SnapZone(action: .maximize, rect: visibleFrame)
            }
            if atBottom {
                return SnapZone(action: .bottomHalf, rect: bottomHalfRect(visibleFrame))
            }
        }
        return nil
    }

    // MARK: - Rect calculations for preview overlay

    private static func leftHalfRect(_ vf: CGRect) -> CGRect {
        CGRect(x: vf.minX, y: vf.minY, width: vf.width / 2, height: vf.height)
    }

    private static func rightHalfRect(_ vf: CGRect) -> CGRect {
        CGRect(x: vf.midX, y: vf.minY, width: vf.width / 2, height: vf.height)
    }

    private static func bottomHalfRect(_ vf: CGRect) -> CGRect {
        CGRect(x: vf.minX, y: vf.midY, width: vf.width, height: vf.height / 2)
    }

    private static func topLeftQuarterRect(_ vf: CGRect) -> CGRect {
        CGRect(x: vf.minX, y: vf.minY, width: vf.width / 2, height: vf.height / 2)
    }

    private static func topRightQuarterRect(_ vf: CGRect) -> CGRect {
        CGRect(x: vf.midX, y: vf.minY, width: vf.width / 2, height: vf.height / 2)
    }

    private static func bottomLeftQuarterRect(_ vf: CGRect) -> CGRect {
        CGRect(x: vf.minX, y: vf.midY, width: vf.width / 2, height: vf.height / 2)
    }

    private static func bottomRightQuarterRect(_ vf: CGRect) -> CGRect {
        CGRect(x: vf.midX, y: vf.midY, width: vf.width / 2, height: vf.height / 2)
    }
}
