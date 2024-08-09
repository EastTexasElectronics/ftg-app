import SwiftUI

/// The main content view for the File Tree Generator application.
/// This view allows users to configure directory selections, options, and exclusions,
/// and provides an interface to generate a file tree.
struct ContentView: View {
    @State private var showingHelp = false
    @State private var showingAbout = false
    @State private var showingAlertModal = false
    @State private var inputDirectory: String = ""
    @State private var outputFile: String = ""
    @State private var selectedLanguages: Set<String> = []
    @State private var exclusionList: Set<String> = []
    @State private var manualExclusion: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isShowingLanguageSelector = false
    @State private var isFullDiskAccessEnabled = true // Default to true, will check on appear
    @State private var selectedFileFormat: String = "Markdown (.md)" // Default selection
    @State private var profiles: [String: SettingsProfile] = [:]
    @State private var selectedProfile: String = ""
    @State private var showingSaveSettings = false
    @State private var profileName: String = ""
    @State private var showError = false
    @State private var showingManageProfiles = false

    var body: some View {
        VStack(spacing: 20) {
            // Header Section
            HeaderView(showingAlertModal: $showingAlertModal, showingAbout: $showingAbout, showingHelp: $showingHelp, isFullDiskAccessEnabled: $isFullDiskAccessEnabled)

            // Main Title
            Text("File Tree Generator")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 5)

            // Directory Selection Section
            SectionTitleView(title: "Directory Selection")
            DirectorySelectionView(inputDirectory: $inputDirectory, outputFile: $outputFile)
                .padding(.horizontal)

            // Options Section
            SectionTitleView(title: "Options")
            OptionsView(isShowingLanguageSelector: $isShowingLanguageSelector, selectedLanguages: $selectedLanguages, exclusionList: $exclusionList, selectedFileFormat: $selectedFileFormat, manualExclusion: $manualExclusion)

            // Current Exclusion List Section
            SectionTitleView(title: "Current Exclusion List")
            CurrentExclusionListView(exclusionList: $exclusionList, removeExclusion: removeExclusion)
                .frame(maxHeight: 200)

            Spacer()

            HStack {
                // Save Settings Button
                Button("Save Settings") {
                    showingSaveSettings = true
                }
                .padding()
                .sheet(isPresented: $showingSaveSettings, onDismiss: {
                    showError = false
                }) {
                    SaveSettingsView(isPresented: $showingSaveSettings, profileName: $profileName, showError: $showError) {
                        saveProfile(named: profileName)
                    }
                }

                // Manage Profiles Button
                Button("Manage Profiles") {
                    showingManageProfiles = true
                }
                .padding()
                .sheet(isPresented: $showingManageProfiles) {
                    ManageProfilesView(profiles: $profiles, selectedProfile: $selectedProfile, loadProfile: loadProfile, removeProfile: removeProfile, onClose: { showingManageProfiles = false })
                }

                Spacer()

                // Profile Selection Dropdown
                Picker("Profiles", selection: $selectedProfile) {
                    Text("Select Profile").tag("")
                    ForEach(Array(profiles.keys), id: \.self) { key in
                        Text(key).tag(key)
                    }
                }
//                TODO: 'onChange(of:perform:)' was deprecated in macOS 14.0: Use `onChange` with a two or zero parameter action closure instead.
                .onChange(of: selectedProfile, perform: { value in
                    loadProfile(named: value)
                })
                .pickerStyle(MenuPickerStyle())
                .padding()

                Spacer()

                GenerateButton(inputDirectory: $inputDirectory, alertMessage: $alertMessage, showAlert: $showAlert, exclusionList: $exclusionList, outputFile: $outputFile, selectedFileFormat: selectedFileFormat)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: 1000, height: 800)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            checkFullDiskAccess()
            loadProfiles()
        }
    }

    /// Removes the given exclusion from the exclusion list.
    /// - Parameter item: The exclusion pattern to remove.
    private func removeExclusion(_ item: String) {
        exclusionList.remove(item)
    }

    /// Checks if Full Disk Access is enabled by attempting to read from a protected directory.
    /// Updates the `isFullDiskAccessEnabled` state based on the result.
    private func checkFullDiskAccess() {
        let protectedPath = "/Library/Application Support"
        let fileManager = FileManager.default

        if fileManager.isReadableFile(atPath: protectedPath) {
            isFullDiskAccessEnabled = true
        } else {
            isFullDiskAccessEnabled = false
        }
    }

    /// Saves the current profile settings under the specified name.
    /// - Parameter name: The name to save the profile under.
    private func saveProfile(named name: String) {
        guard !name.isEmpty else {
            showError = true
            return
        }

        let profile = SettingsProfile(exclusionList: exclusionList, selectedFileFormat: selectedFileFormat)
        profiles[name] = profile
        saveProfilesToUserDefaults()
        profileName = ""
        showError = false
        showingSaveSettings = false
    }

    /// Loads the profile with the specified name.
    /// - Parameter name: The name of the profile to load.
    private func loadProfile(named name: String) {
        guard let profile = profiles[name] else {
            print("Profile not found: \(name)")
            return
        }
        exclusionList = profile.exclusionList
        selectedFileFormat = profile.selectedFileFormat
    }

    /// Removes the profile with the specified name.
    /// - Parameter name: The name of the profile to remove.
    private func removeProfile(named name: String) {
        profiles.removeValue(forKey: name)
        saveProfilesToUserDefaults()
    }

    /// Saves the profiles to user defaults.
    private func saveProfilesToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "savedProfiles")
        }
    }

    /// Loads the profiles from user defaults.
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
    static var previews: some View {
        ContentView()
    }
}
