// AlertModalView.swift
import SwiftUI

struct AlertModalView: View {
    @Binding var showingAlertModal: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Manual input fields may not function properly because the application does not have the necessary permissions. Please enable the required permissions in System Preferences.")
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
        .frame(width: 400)
    }

    private func openFullDiskAccessSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"),
              NSWorkspace.shared.open(url) else {
            print("Unable to open Full Disk Access settings.")
            return
        }
    }
}

struct AlertModalView_Previews: PreviewProvider {
    @State static var showingAlertModal = true

    static var previews: some View {
        AlertModalView(showingAlertModal: $showingAlertModal)
    }
}
