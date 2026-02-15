import Testing
@testable import Magnetism

@Suite("WindowAction")
struct WindowActionTests {
    @Test("All actions have display names")
    func allActionsHaveDisplayNames() {
        for action in WindowAction.allCases {
            #expect(!action.displayName.isEmpty, "Action \(action) should have a display name")
        }
    }

    @Test("All actions have a category")
    func allActionsHaveCategory() {
        for action in WindowAction.allCases {
            #expect(!action.category.rawValue.isEmpty, "Action \(action) should have a category")
        }
    }

    @Test("Calculation factory returns a calculation for every action")
    func calculationFactoryCoversAllActions() {
        // restore, nextDisplay, previousDisplay are handled directly by WindowManager
        let calculatedActions = WindowAction.allCases.filter {
            $0 != .restore && $0.category != .displays
        }
        for action in calculatedActions {
            let calc = WindowCalculationFactory.calculation(for: action)
            #expect(calc != nil, "Missing calculation for \(action)")
        }
    }
}
