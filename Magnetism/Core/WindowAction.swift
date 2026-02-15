import Foundation

enum WindowAction: String, CaseIterable {
    case leftHalf
    case rightHalf
    case topHalf
    case bottomHalf
    case topLeftQuarter
    case topRightQuarter
    case bottomLeftQuarter
    case bottomRightQuarter
    case leftThird
    case centerThird
    case rightThird
    case leftTwoThirds
    case rightTwoThirds
    case maximize
    case center
    case restore
    case nextDisplay
    case previousDisplay

    var displayName: String {
        switch self {
        case .leftHalf: return "Left Half"
        case .rightHalf: return "Right Half"
        case .topHalf: return "Top Half"
        case .bottomHalf: return "Bottom Half"
        case .topLeftQuarter: return "Top Left"
        case .topRightQuarter: return "Top Right"
        case .bottomLeftQuarter: return "Bottom Left"
        case .bottomRightQuarter: return "Bottom Right"
        case .leftThird: return "Left Third"
        case .centerThird: return "Center Third"
        case .rightThird: return "Right Third"
        case .leftTwoThirds: return "Left Two Thirds"
        case .rightTwoThirds: return "Right Two Thirds"
        case .maximize: return "Maximize"
        case .center: return "Center"
        case .restore: return "Restore"
        case .nextDisplay: return "Next Display"
        case .previousDisplay: return "Previous Display"
        }
    }

    var category: Category {
        switch self {
        case .leftHalf, .rightHalf, .topHalf, .bottomHalf:
            return .halves
        case .topLeftQuarter, .topRightQuarter, .bottomLeftQuarter, .bottomRightQuarter:
            return .quarters
        case .leftThird, .centerThird, .rightThird, .leftTwoThirds, .rightTwoThirds:
            return .thirds
        case .maximize, .center, .restore:
            return .other
        case .nextDisplay, .previousDisplay:
            return .displays
        }
    }

    enum Category: String, CaseIterable {
        case halves = "Halves"
        case quarters = "Quarters"
        case thirds = "Thirds"
        case other = "Other"
        case displays = "Displays"
    }
}
