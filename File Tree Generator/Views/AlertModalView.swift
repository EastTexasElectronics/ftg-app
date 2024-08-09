import SwiftUI

struct AlertModalView: View {
    @Binding var isFullDiskAccessEnabled: Bool
    @Binding var showingAlertModal: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Manual input fields may not function properly because Full Disk Access is not enabled. Please enable Full Disk Access in System Preferences.")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Open Full Disk Access Settings") {
                openFullDiskAccessSettings()
            }
            .padding()
            .help("Click to open the Full Disk Access settings in System Preferences.")
            
            Button("Close") {
                showingAlertModal = false
            }
            .padding()
            .help("Click to close this alert.")

            Spacer()
        }
        .padding()
        .frame(width: 400, height: 250)
    }

    private func openFullDiskAccessSettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!
        NSWorkspace.shared.open(url)
    }
}
