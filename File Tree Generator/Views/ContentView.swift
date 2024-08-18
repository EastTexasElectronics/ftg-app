import SwiftUI

/// The main content view for the File Tree Generator application.
struct ContentView: View {
    // MARK: - Properties

    @Binding var selectedProfile: String
    @Binding var profiles: [String: SettingsProfile]

    @State private var showingSaveSettings = false
    @State private var showingManageProfiles = false
    @State private var inputDirectory: String = ""
    @State private var outputFile: String = ""
    @State private var selectedLanguages: Set<String> = []
    @State private var exclusionList: Set<String> = []
    @State private var manualExclusion: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showingAlertModal = false
    @State private var selectedFileFormat: String = "Markdown.md"
    @State private var profileName: String = ""
    @State private var showError = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            buttonGroup
            generateButtonSection
            manualExclusionSection
            exclusionListView
            Spacer()
        }
        .padding()
        .frame(width: 800, height: 600)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingAlertModal) {
            AlertModalView(showingAlertModal: $showingAlertModal)
        }
    }

    // MARK: - Button Group

    private var buttonGroup: some View {
        HStack(alignment: .top) {
            VStack(spacing: 10) {
                DirectoryField(
                    title: "Input Directory:",
                    text: $inputDirectory,
                    buttonAction: selectDirectory
                )
                .frame(maxWidth: 300)

                DirectoryField(
                    title: "Output File:",
                    text: $outputFile,
                    buttonAction: selectOutputFile
                )
                .frame(maxWidth: 300)
            }

            Spacer()

            VStack(spacing: 10) {
                Button("Add Default Exclusions") {
                    addDefaultExclusions()
                }
                .help("Click to add default exclusions based on selected languages.")
                .accessibilityLabel("Add default exclusions based on selected languages")

                ToggleFileFormatView(selectedFileFormat: $selectedFileFormat)
                    .help("Select the file format for the output file.")
                    .accessibilityLabel("Select file format for output")
            }

            Spacer()

            VStack(spacing: 10) {
                Button("Save to Profile") {
                    showingSaveSettings = true
                }
                .sheet(isPresented: $showingSaveSettings) {
                    SaveSettingsView(
                        isPresented: $showingSaveSettings,
                        profileName: $profileName,
                        showError: $showError
                    ) {
                        saveProfile(named: profileName)
                    }
                }
                .accessibilityLabel("Save current settings to profile")

                Button("Manage Profiles") {
                    showingManageProfiles = true
                }
                .sheet(isPresented: $showingManageProfiles) {
                    ManageProfilesView(
                        profiles: $profiles,
                        selectedProfile: $selectedProfile,
                        loadProfile: loadProfile,
                        removeProfile: removeProfile,
                        renameProfile: renameProfile
                    ) {
                        showingManageProfiles = false
                    }
                }
                .accessibilityLabel("Manage saved profiles")
            }

            Spacer()
        }
        .padding(.horizontal)
    }

    // MARK: - Generate Button Section

    private var generateButtonSection: some View {
        VStack {
            GenerateButton(
                inputDirectory: $inputDirectory,
                alertMessage: $alertMessage,
                showAlert: $showAlert,
                exclusionList: $exclusionList,
                outputFile: $outputFile,
                showingAlertModal: $showingAlertModal,
                selectedFileFormat: selectedFileFormat
            )
            .frame(height: 60)
            .frame(width: 200)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 10)
    }

    // MARK: - Manual Exclusion Section

    private var manualExclusionSection: some View {
        VStack {
            SectionTitleView(title: "Manually Add Exclusions")

            HStack {
                ManualExclusionView(
                    manualExclusion: $manualExclusion,
                    exclusionList: $exclusionList
                )
                .padding(.leading)

                Button("Add") {
                    addManualExclusion()
                }
                .padding(.horizontal)
                .accessibilityLabel("Add manual exclusion")
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Exclusion List View

    private var exclusionListView: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: .init(.flexible()), count: 5),
                spacing: 10
            ) {
                ForEach(Array(exclusionList), id: \.self) { item in
                    HStack {
                        Text(item)
                            .accessibilityLabel("Exclusion: \(item)")
                        Spacer()
                        Button("X") {
                            exclusionList.remove(item)
                        }
                        .foregroundColor(.red)
                        .accessibilityLabel("Remove exclusion: \(item)")
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                }
            }
            .padding()
        }
    }

    // MARK: - Directory Selection Methods

    /// Opens a panel for the user to select an input directory.
    private func selectDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.begin { result in
            if result == .OK, let url = panel.url {
                inputDirectory = url.path
            }
        }
    }

    /// Opens a panel for the user to select an output file.
    private func selectOutputFile() {
        let panel = NSSavePanel()
        panel.title = "Select Output File"
        panel.nameFieldStringValue = "file_tree.md"
        panel.begin { result in
            if result == .OK, let url = panel.url {
                outputFile = url.path
            }
        }
    }

    // MARK: - Exclusion and Profile Management

    /// Adds default exclusion patterns based on the selected languages.
    private func addDefaultExclusions() {
        for language in selectedLanguages {
            if let patterns = languagesAndExclusions.first(where: { $0.name == language })?.patterns {
                exclusionList.formUnion(patterns)
            }
        }
    }

    /// Adds a manual exclusion to the exclusion list.
    private func addManualExclusion() {
        if !manualExclusion.isEmpty {
            exclusionList.insert(manualExclusion)
            manualExclusion = ""
        }
    }

    /// Saves the current exclusion list and file format to a named profile.
    private func saveProfile(named name: String) {
        guard !name.isEmpty else {
            showError = true
            return
        }

        let profile = SettingsProfile(
            exclusionList: exclusionList,
            selectedFileFormat: selectedFileFormat
        )
        profiles[name] = profile
        saveProfilesToUserDefaults()
        profileName = ""
        showError = false
        showingSaveSettings = false
    }

    /// Loads a profile by its name.
    private func loadProfile(named name: String) {
        guard let profile = profiles[name] else { return }
        exclusionList = profile.exclusionList
        selectedFileFormat = profile.selectedFileFormat
    }

    /// Removes a profile by its name.
    private func removeProfile(named name: String) {
        profiles.removeValue(forKey: name)
        saveProfilesToUserDefaults()
    }

    /// Renames an existing profile.
    private func renameProfile(oldName: String, newName: String) {
        guard !newName.isEmpty else { return }
        if let profile = profiles.removeValue(forKey: oldName) {
            profiles[newName] = profile
            saveProfilesToUserDefaults()
        }
    }

    /// Saves profiles to UserDefaults.
    private func saveProfilesToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "savedProfiles")
        }
    }

    /// Loads profiles from UserDefaults.
    private func loadProfiles() {
        let decoder = JSONDecoder()
        if let savedProfiles = UserDefaults.standard.object(forKey: "savedProfiles") as? Data {
            if let loadedProfiles = try? decoder.decode([String: SettingsProfile].self, from: savedProfiles) {
                profiles = loadedProfiles
            }
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    @State static var selectedProfile = "Default Profile"
    @State static var profiles: [String: SettingsProfile] = [
        "Default Profile": SettingsProfile(exclusionList: ["node_modules", "*.log"], selectedFileFormat: "Markdown (.md)")
    ]

    static var previews: some View {
        ContentView(selectedProfile: $selectedProfile, profiles: $profiles)
    }
}
