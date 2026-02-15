import Cocoa

@MainActor
final class WindowHistory {
    static let shared = WindowHistory()

    private var history: [CGWindowID: CGRect] = [:]

    private init() {}

    func save(windowID: CGWindowID, frame: CGRect) {
        if history[windowID] == nil {
            history[windowID] = frame
        }
    }

    func restore(windowID: CGWindowID) -> CGRect? {
        return history.removeValue(forKey: windowID)
    }

    func clear(windowID: CGWindowID) {
        history.removeValue(forKey: windowID)
    }
}
