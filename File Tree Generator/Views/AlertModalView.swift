import SwiftUI

/// A view that displays an alert modal informing the user about Full Disk Access requirements.
/// - Parameters:
///   - isFullDiskAccessEnabled: A binding that reflects whether Full Disk Access is enabled.
///   - showingAlertModal: A binding that controls the visibility of the alert modal.
struct AlertModalView: View {
    @Binding var isFullDiskAccessEnabled: Bool  // Binding to track if Full Disk Access is enabled
    @Binding var showingAlertModal: Bool  // Binding to control the visibility of the modal

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Warning message about Full Disk Access
            Text("Manual input fields may not function properly because Full Disk Access is not enabled. Please enable Full Disk Access in System Preferences.")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            
            // Button to open Full Disk Access settings
            Button("Open Full Disk Access Settings") {
                openFullDiskAccessSettings()
            }
            .padding()
            .help("Click to open the Full Disk Access settings in System Preferences.")
            
            // Button to close the modal
            Button("Close") {
                showingAlertModal = false
            }
            .padding()
            .help("Click to close this alert.")

            Spacer()
        }
        .padding()
        .frame(width: 400, height: 250)  // Set the size of the modal
    }

    /// Opens the Full Disk Access settings in System Preferences.
    private func openFullDiskAccessSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
            NSWorkspace.shared.open(url)
        }
    }
}

// MARK: - Preview
struct AlertModalView_Previews: PreviewProvider {
    @State static var isFullDiskAccessEnabled = false
    @State static var showingAlertModal = true

    static var previews: some View {
        AlertModalView(isFullDiskAccessEnabled: $isFullDiskAccessEnabled, showingAlertModal: $showingAlertModal)
    }
}
