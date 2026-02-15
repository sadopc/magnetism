import Cocoa

protocol WindowCalculation {
    func calculateRect(visibleFrame: CGRect, windowFrame: CGRect) -> CGRect
}

enum WindowCalculationFactory {
    static func calculation(for action: WindowAction) -> WindowCalculation? {
        switch action {
        case .leftHalf: return LeftHalfCalculation()
        case .rightHalf: return RightHalfCalculation()
        case .topHalf: return TopHalfCalculation()
        case .bottomHalf: return BottomHalfCalculation()
        case .topLeftQuarter: return TopLeftQuarterCalculation()
        case .topRightQuarter: return TopRightQuarterCalculation()
        case .bottomLeftQuarter: return BottomLeftQuarterCalculation()
        case .bottomRightQuarter: return BottomRightQuarterCalculation()
        case .leftThird: return LeftThirdCalculation()
        case .centerThird: return CenterThirdCalculation()
        case .rightThird: return RightThirdCalculation()
        case .leftTwoThirds: return LeftTwoThirdsCalculation()
        case .rightTwoThirds: return RightTwoThirdsCalculation()
        case .maximize: return MaximizeCalculation()
        case .center: return CenterCalculation()
        case .restore, .nextDisplay, .previousDisplay: return nil
        }
    }
}
