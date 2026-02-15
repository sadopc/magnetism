import SwiftUI

struct AboutView: View {
    private var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "rectangle.split.2x2")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(.accentColor)

            Text("Magnetism")
                .font(.title)
                .fontWeight(.bold)

            Text("Version \(version) (\(build))")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("A free, open-source window manager for macOS.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Link("View on GitHub", destination: URL(string: "https://github.com/sadopc/magnetism")!)
                .font(.body)

            Spacer()
        }
        .padding()
    }
}
