import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    // Halves
    static let leftHalf = Self("leftHalf", default: .init(.leftArrow, modifiers: [.control, .option]))
    static let rightHalf = Self("rightHalf", default: .init(.rightArrow, modifiers: [.control, .option]))
    static let topHalf = Self("topHalf", default: .init(.upArrow, modifiers: [.control, .option]))
    static let bottomHalf = Self("bottomHalf", default: .init(.downArrow, modifiers: [.control, .option]))

    // Quarters
    static let topLeftQuarter = Self("topLeftQuarter", default: .init(.u, modifiers: [.control, .option]))
    static let topRightQuarter = Self("topRightQuarter", default: .init(.i, modifiers: [.control, .option]))
    static let bottomLeftQuarter = Self("bottomLeftQuarter", default: .init(.j, modifiers: [.control, .option]))
    static let bottomRightQuarter = Self("bottomRightQuarter", default: .init(.k, modifiers: [.control, .option]))

    // Thirds
    static let leftThird = Self("leftThird", default: .init(.d, modifiers: [.control, .option]))
    static let centerThird = Self("centerThird", default: .init(.f, modifiers: [.control, .option]))
    static let rightThird = Self("rightThird", default: .init(.g, modifiers: [.control, .option]))
    static let leftTwoThirds = Self("leftTwoThirds", default: .init(.e, modifiers: [.control, .option]))
    static let rightTwoThirds = Self("rightTwoThirds", default: .init(.t, modifiers: [.control, .option]))

    // Other
    static let maximize = Self("maximize", default: .init(.return, modifiers: [.control, .option]))
    static let center = Self("center", default: .init(.c, modifiers: [.control, .option]))
    static let restore = Self("restore", default: .init(.delete, modifiers: [.control, .option]))

    // Displays
    static let nextDisplay = Self("nextDisplay", default: .init(.rightArrow, modifiers: [.control, .option, .command]))
    static let previousDisplay = Self("previousDisplay", default: .init(.leftArrow, modifiers: [.control, .option, .command]))
}

extension WindowAction {
    var shortcutName: KeyboardShortcuts.Name {
        switch self {
        case .leftHalf: return .leftHalf
        case .rightHalf: return .rightHalf
        case .topHalf: return .topHalf
        case .bottomHalf: return .bottomHalf
        case .topLeftQuarter: return .topLeftQuarter
        case .topRightQuarter: return .topRightQuarter
        case .bottomLeftQuarter: return .bottomLeftQuarter
        case .bottomRightQuarter: return .bottomRightQuarter
        case .leftThird: return .leftThird
        case .centerThird: return .centerThird
        case .rightThird: return .rightThird
        case .leftTwoThirds: return .leftTwoThirds
        case .rightTwoThirds: return .rightTwoThirds
        case .maximize: return .maximize
        case .center: return .center
        case .restore: return .restore
        case .nextDisplay: return .nextDisplay
        case .previousDisplay: return .previousDisplay
        }
    }
}
