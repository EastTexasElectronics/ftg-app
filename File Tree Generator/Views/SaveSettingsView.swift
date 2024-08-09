import SwiftUI

/// A view that allows the user to save the current settings as a profile.
/// This view includes text input for the profile name and handles validation
/// to ensure a profile name is entered before saving.
struct SaveSettingsView: View {
    @Binding var isPresented: Bool  // Controls whether the view is presented
    @Binding var profileName: String  // The name of the profile to save
    @Binding var showError: Bool  // Indicates whether an error should be shown
    var onSave: () -> Void  // Closure to execute when the save button is pressed

    var body: some View {
        VStack {
            // Title for the save settings profile dialog
            Text("Save Settings Profile")
                .font(.title2)
                .padding(.bottom, 10)

            // TextField for entering the profile name
            TextField("Enter profile name", text: $profileName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Error message displayed if no profile name is entered
            if showError {
                Text("Please enter a profile name.")
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
            }

            // Button row for Cancel and Save actions
            HStack {
                // Cancel button to close the view and clear the error
                Button("Cancel") {
                    isPresented = false
                    showError = false
                }
                .padding()

                Spacer()

                // Save button to save the profile and close the view if successful
                Button("Save") {
                    onSave()
                    if !profileName.isEmpty {
                        isPresented = false
                    }
                }
                .padding()
            }
        }
        .padding()
        .frame(width: 300, height: 200)  // Set the size of the view
    }
}

// MARK: - Preview
struct SaveSettingsView_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var profileName = ""
    @State static var showError = false

    static var previews: some View {
        SaveSettingsView(
            isPresented: $isPresented,
            profileName: $profileName,
            showError: $showError,
            onSave: { print("Profile Saved!") }
        )
    }
}
