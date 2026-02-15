import SwiftUI

struct GeneralPreferencesView: View {
    @AppStorage(UserDefaultsKeys.launchAtLogin) private var launchAtLogin = false
    @AppStorage(UserDefaultsKeys.snappingEnabled) private var snappingEnabled = true

    var body: some View {
        Form {
            Section {
                Toggle("Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, newValue in
                        LaunchOnLogin.setEnabled(newValue)
                    }

                Toggle("Enable drag-to-edge snapping", isOn: $snappingEnabled)
                    .onChange(of: snappingEnabled) { _, newValue in
                        if newValue {
                            SnapManager.shared.start()
                        } else {
                            SnapManager.shared.stop()
                        }
                    }
            }

            Section("Accessibility") {
                HStack {
                    Image(systemName: AccessibilityPermission.isTrusted ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(AccessibilityPermission.isTrusted ? .green : .red)
                    Text(AccessibilityPermission.isTrusted ? "Accessibility permission granted" : "Accessibility permission required")
                    Spacer()
                    if !AccessibilityPermission.isTrusted {
                        Button("Grant Access") {
                            AccessibilityPermission.promptForAccess()
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}
