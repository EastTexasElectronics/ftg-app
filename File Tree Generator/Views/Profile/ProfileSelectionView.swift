import SwiftUI

struct ProfileSelectionView: View {
    @Binding var selectedProfile: String?
    var profiles: [String: SettingsProfile]
    var loadProfile: (String) -> Void

    var body: some View {
        VStack {
            Picker("Profile:", selection: Binding(
                get: { selectedProfile ?? "" },
                set: { newValue in
                    if !newValue.isEmpty && profiles.keys.contains(newValue) {
                        selectedProfile = newValue
                        loadProfile(newValue)
                    } else {
                        selectedProfile = nil
                    }
                }
            )) {
                Text("Select a Profile").tag("")
                ForEach(profiles.keys.sorted(), id: \.self) { profileName in
                    Text(profileName).tag(profileName)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.clear)
            .cornerRadius(8)
            .frame(width: 210)
        }
        .onAppear {
            // Ensure the selected profile is not pre-selected unless explicitly set.
            if selectedProfile == nil || !profiles.keys.contains(selectedProfile ?? "") {
                selectedProfile = nil
            }
        }
    }
}

// MARK: - Preview
struct ProfileSelectionView_Previews: PreviewProvider {
    @State static var selectedProfile: String? = nil
    @State static var profiles: [String: SettingsProfile] = [
        "Default": SettingsProfile(exclusionList: [], selectedFileFormat: "Markdown (.md)"),
        "Another Profile": SettingsProfile(exclusionList: ["vendor", "*.tmp"], selectedFileFormat: "Plain Text")
    ]

    static var previews: some View {
        ProfileSelectionView(
            selectedProfile: $selectedProfile,
            profiles: profiles,
            loadProfile: { _ in print("Profile Loaded") }
        )
        .padding()
        .frame(width: 300, height: 150)
    }
}
