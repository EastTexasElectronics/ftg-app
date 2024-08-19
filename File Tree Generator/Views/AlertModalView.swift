import SwiftUI

/// A view that displays an alert modal informing the user about permission issues.
/// - Parameters:
///   - showingAlertModal: A binding that controls the visibility of the alert modal.
struct AlertModalView: View {
    @Binding var showingAlertModal: Bool  // Binding to control the visibility of the modal

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Warning message about permission issues
            Text("Manual input fields may not function properly because the application does not have the necessary permissions. Please enable the required permissions in System Preferences.")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
                .layoutPriority(1) // Ensures that this text is prioritized for space

            // Button to open the appropriate settings in System Preferences
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
        .frame(width: 400)  // Only set the width, let height adjust dynamically
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
    @State static var showingAlertModal = true

    static var previews: some View {
        AlertModalView(showingAlertModal: $showingAlertModal)
    }
}
