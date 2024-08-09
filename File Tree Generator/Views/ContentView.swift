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

            Spacer()

            // Generate Button Section
            GenerateButton(inputDirectory: $inputDirectory, alertMessage: $alertMessage, showAlert: $showAlert, exclusionList: $exclusionList, outputFile: $outputFile, selectedFileFormat: selectedFileFormat)
                .padding(.horizontal)
        }
        .padding()
        .frame(width: 800, height: 600)  // Increase the default window size by 50%
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            checkFullDiskAccess()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
