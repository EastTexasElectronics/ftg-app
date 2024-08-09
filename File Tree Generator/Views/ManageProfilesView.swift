import SwiftUI

/// A view that allows users to manage saved profiles, including loading and deleting profiles.
/// The view displays a list of profiles, where each profile can be loaded by tapping or deleted by pressing the trash icon.
struct ManageProfilesView: View {
    @Binding var profiles: [String: SettingsProfile]  // A dictionary of profile names to settings profiles
    @Binding var selectedProfile: String  // The currently selected profile
    var loadProfile: (String) -> Void  // Closure to load a profile
    var removeProfile: (String) -> Void  // Closure to remove a profile
    var onClose: () -> Void  // Closure to execute when the close button is pressed

    var body: some View {
        VStack {
            // Title of the manage profiles view
            Text("Manage Profiles")
                .font(.title)
                .padding(.bottom, 10)

            // List of profiles with options to load or delete
            List {
                ForEach(Array(profiles.keys), id: \.self) { key in
                    HStack {
                        // Display profile name
                        Text(key)

                        Spacer()

                        // Delete button with trash icon
                        Button(action: {
                            removeProfile(key)  // Remove the selected profile
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .onTapGesture {
                        loadProfile(key)  // Load the selected profile
                        selectedProfile = key  // Update the selected profile
                    }
                }
            }

            Spacer()

            // Close button at the bottom of the view
            HStack {
                Spacer()

                Button("Close") {
                    onClose()  // Close the manage profiles view
                }
                .padding()
                .buttonStyle(DefaultButtonStyle())

                Spacer()
            }
        }
        .padding()
        .frame(width: 400, height: 300)  // Set the size of the view
    }
}

// MARK: - Preview
struct ManageProfilesView_Previews: PreviewProvider {
    @State static var profiles = ["Profile 1": SettingsProfile(exclusionList: ["*.tmp"], selectedFileFormat: "Markdown (.md)")]
    @State static var selectedProfile = "Profile 1"

    static var previews: some View {
        ManageProfilesView(
            profiles: $profiles,
            selectedProfile: $selectedProfile,
            loadProfile: { _ in },
            removeProfile: { _ in },
            onClose: { }
        )
    }
}
