import SwiftUI
import KeyboardShortcuts

struct ShortcutsPreferencesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(WindowAction.Category.allCases, id: \.rawValue) { category in
                    let actions = WindowAction.allCases.filter { $0.category == category }
                    if !actions.isEmpty {
                        Section {
                            ForEach(actions, id: \.rawValue) { action in
                                HStack {
                                    Text(action.displayName)
                                        .frame(width: 150, alignment: .leading)
                                    KeyboardShortcuts.Recorder(for: action.shortcutName)
                                }
                            }
                        } header: {
                            Text(category.rawValue)
                                .font(.headline)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
