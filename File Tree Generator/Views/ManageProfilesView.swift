import SwiftUI

struct ManageProfilesView: View {
    @Binding var profiles: [String: SettingsProfile]
    @Binding var selectedProfile: String
    var loadProfile: (String) -> Void
    var removeProfile: (String) -> Void
    var renameProfile: (String, String) -> Void
    var onClose: () -> Void

    @State private var newName: String = ""
    @State private var showingRenameAlert = false
    @State private var profileToRename: String?

    var body: some View {
        VStack {
            Text("Manage Profiles")
                .font(.title)
                .padding(.bottom, 10)

            List {
                ForEach(Array(profiles.keys), id: \.self) { key in
                    HStack {
                        Text(key)

                        Spacer()

                        Button(action: {
                            profileToRename = key
                            newName = key
                            showingRenameAlert = true
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                                .frame(width: 24, height: 24)
                        }

                        Button(action: {
                            removeProfile(key)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .onTapGesture {
                        loadProfile(key)
                        selectedProfile = key
                    }
                }
            }

            Spacer()

            HStack {
                Spacer()

                Button("Close") {
                    onClose()
                }
                .padding()
                .buttonStyle(DefaultButtonStyle())

                Spacer()
            }
        }
        .padding()
        .frame(width: 400, height: 300)
        .alert(isPresented: $showingRenameAlert) {
            Alert(
                title: Text("Rename Profile"),
                message: Text("Enter a new name for the profile:"),
                primaryButton: .default(Text("Rename"), action: {
                    if let oldName = profileToRename, !newName.isEmpty {
                        renameProfile(oldName, newName)
                        selectedProfile = newName
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }
}
