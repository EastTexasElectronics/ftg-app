import SwiftUI
import AVFoundation

struct ContentView: View {
    // MARK: - Properties

    @Binding var selectedProfile: String?
    @Binding var profiles: [String: SettingsProfile]
    let appDelegate: AppDelegate
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
    @State private var selectedFileFormat: String = "Markdown"
    @State private var profileName: String = ""
    @State private var showError = false
    @State private var showingHelpView = false
    @State private var showingAboutView = false
    @State private var showingExclusionView = false

    // Audio players
    @State private var successAudioPlayer: AVAudioPlayer?
    @State private var failureAudioPlayer: AVAudioPlayer?

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            profileSelectionSection
            buttonGroup
            manualExclusionSection
            generateButtonSection
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
        .sheet(isPresented: $showingHelpView) {
            HelpView()
        }
        .sheet(isPresented: $showingAboutView) {
            AboutView(isPresented: $showingAboutView)
        }
        .sheet(isPresented: $showingExclusionView) {
            CheckboxGridView(selectedLanguages: $selectedLanguages, exclusionList: $exclusionList)
        }
        .onAppear {
            setupAudioPlayers()
        }
    }

    // MARK: - Profile Selection Section

    private var profileSelectionSection: some View {
        ProfileSelectionView(
            selectedProfile: $selectedProfile,
            profiles: profiles,
            loadProfile: loadProfile
        )
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    // MARK: - Button Group

    private var buttonGroup: some View {
        HStack(alignment: .center) {
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
                Button("Add Exclusions") {
                    showingExclusionView = true  // Show the CheckboxGridView
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
                .focusable(false)

                ToggleFileFormatView(selectedFileFormat: $selectedFileFormat)
                    .padding(.horizontal, 22)
                    .frame(maxWidth: .infinity)
                    .help("Select the file format for the output file.")
                    .accessibilityLabel("Select file format for output")
            }
            .frame(maxWidth: 200)

            Spacer()

            VStack(spacing: 10) {
                Button("Save to Profile") {
                    showingSaveSettings = true
                }
                .sheet(isPresented: $showingSaveSettings) {
                    SaveSettingsView(
                        isPresented: $showingSaveSettings,
                        profileName: $selectedProfile,
                        showError: $showError
                    ) {
                        saveProfile(named: selectedProfile ?? "")
                    }
                }
                .accessibilityLabel("Save current settings to profile")
                .padding(.horizontal, 15)
                .padding(.vertical, 2)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
                .focusable(false)

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
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Generate Button Section

    private var generateButtonSection: some View {
        VStack {
            HStack(spacing: 20) {
                Button("Help") {
                    showingHelpView = true
                }
                .accessibilityLabel("Help")
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
                .focusable(false)

                GenerateButtonView(
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
                .onChange(of: showAlert) { newValue in
                    if newValue {
                        playFailureSound()
                    } else {
                        playSuccessSound()
                    }
                }

                Button("About") {
                    showingAboutView = true
                }
                .accessibilityLabel("About")
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: - Manual Exclusion Section

    private var manualExclusionSection: some View {
        VStack {
            HStack {
                ManualExclusionView(
                    manualExclusion: $manualExclusion,
                    exclusionList: $exclusionList
                )
                .padding(.leading)
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
                        .focusable(false)
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
    
    private func addDefaultExclusions() {
        for language in selectedLanguages {
            if let patterns = languagesAndExclusions.first(where: { $0.name == language })?.patterns {
                exclusionList.formUnion(patterns)
            }
        }
    }
    
    private func addManualExclusion() {
        if !manualExclusion.isEmpty {
            exclusionList.insert(manualExclusion)
            manualExclusion = ""
        }
    }
    
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
    
    private func loadProfile(named name: String?) {
        guard let name = name, let profile = profiles[name] else { return }
        exclusionList = profile.exclusionList
        selectedFileFormat = profile.selectedFileFormat
    }
    
    private func removeProfile(named name: String) {
        profiles.removeValue(forKey: name)
        saveProfilesToUserDefaults()
    }
    
    private func renameProfile(oldName: String, newName: String) {
        guard !newName.isEmpty else { return }
        if let profile = profiles.removeValue(forKey: oldName) {
            profiles[newName] = profile
            saveProfilesToUserDefaults()
        }
    }
    
    private func saveProfilesToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "savedProfiles")
        }
    }
    
    private func loadProfiles() {
        let decoder = JSONDecoder()
        if let savedProfiles = UserDefaults.standard.object(forKey: "savedProfiles") as? Data {
            if let loadedProfiles = try? decoder.decode([String: SettingsProfile].self, from: savedProfiles) {
                profiles = loadedProfiles
            }
        }
    }

    // MARK: - Audio Setup

    private func setupAudioPlayers() {
        guard let successURL = Bundle.main.url(forResource: "Complete_Audio", withExtension: "mp3"),
              let failureURL = Bundle.main.url(forResource: "Fail_Audio", withExtension: "mp3") else {
            print("Audio files not found")
            return
        }

        do {
            successAudioPlayer = try AVAudioPlayer(contentsOf: successURL)
            failureAudioPlayer = try AVAudioPlayer(contentsOf: failureURL)
        } catch {
            print("Failed to initialize audio players: \(error.localizedDescription)")
        }
    }

    // MARK: - Audio Playback

    private func playSuccessSound() {
        successAudioPlayer?.play()
    }

    private func playFailureSound() {
        failureAudioPlayer?.play()
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    @State static var selectedProfile: String? = nil
    @State static var profiles: [String: SettingsProfile] = [
        "Default Profile": SettingsProfile(exclusionList: ["node_modules", "*.log"], selectedFileFormat: "Markdown (.md)")
    ]

    static var previews: some View {
        ContentView(selectedProfile: $selectedProfile, profiles: $profiles, appDelegate: AppDelegate())
    }
}
