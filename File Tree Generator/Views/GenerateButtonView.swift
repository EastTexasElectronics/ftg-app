import SwiftUI
import AVFoundation

struct GenerateButtonView: View {
    @Binding var inputDirectory: String
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    @Binding var exclusionList: Set<String>
    @Binding var outputFile: String
    @Binding var showingAlertModal: Bool
    var selectedFileFormat: String

    // Audio players
    @State private var successAudioPlayer: AVAudioPlayer?
    @State private var failureAudioPlayer: AVAudioPlayer?

    // State to track the progress
    @State private var isGenerating: Bool = false

    var body: some View {
        VStack {
            if isGenerating {
                ProgressView("Generating File Tree...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Button(action: generateFileTree) {
                    Text("Generate File Tree")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .frame(height: 50)
                        .accessibilityLabel("Select a Directory")
                        .buttonStyle(PlainButtonStyle())
                        .focusable(false)
                }
                .disabled(inputDirectory.isEmpty)
                .help("Click to generate the file tree based on the selected directory and exclusion patterns.")
                .onAppear {
                    setupAudioPlayers()
                }
            }
        }
    }

    private func generateFileTree() {
        guard !inputDirectory.isEmpty else {
            alertMessage = "Please select an input directory."
            showAlert = true
            playFailureSound()
            print("Attempted to generate file tree without selecting input directory")
            return
        }

        isGenerating = true
        DispatchQueue.global(qos: .userInitiated).async {
            let fileExtension: String
            switch selectedFileFormat {
            case "Markdown":
                fileExtension = ".md"
            case "Plain Text":
                fileExtension = ".txt"
            case "HTML":
                fileExtension = ".html"
            default:
                fileExtension = ".md"
            }
            
            let outputLocation = outputFile.isEmpty ? getUniqueOutputFileName(for: "\(inputDirectory)/file_tree\(fileExtension)") : getUniqueOutputFileName(for: outputFile)

            let startTime = Date()
            let generator = FileTreeGenerator(inputDirectory: inputDirectory, outputLocation: outputLocation, excludePatterns: Array(exclusionList), selectedFileFormat: selectedFileFormat)
            
            DispatchQueue.main.async {
                if checkPermissions(for: outputLocation) {
                    if generator.run() {
                        let endTime = Date()
                        let elapsedTime = endTime.timeIntervalSince(startTime)
                        alertMessage = "File tree generated at \(outputLocation) in \(String(format: "%.2f", elapsedTime)) seconds."
                        playSuccessSound()
                        print("File tree generated successfully at \(outputLocation) in \(elapsedTime) seconds")
                    } else {
                        alertMessage = "Failed to generate file tree. Please check your permissions or file path."
                        playFailureSound()
                        print("Failed to generate file tree at \(outputLocation)")
                    }
                    showAlert = true
                } else {
                    showingAlertModal = true
                    playFailureSound()
                    print("Permission denied for output location: \(outputLocation)")
                }
                isGenerating = false
            }
        }
    }

    private func getUniqueOutputFileName(for path: String) -> String {
        var url = URL(fileURLWithPath: path)
        let fileManager = FileManager.default
        var counter = 1

        while fileManager.fileExists(atPath: url.path) {
            let baseName = url.deletingPathExtension().lastPathComponent
            let fileExtension = url.pathExtension
            let newName = "\(baseName)_\(counter)"
            url.deleteLastPathComponent()
            url.appendPathComponent(newName)
            url.appendPathExtension(fileExtension)
            counter += 1
        }

        return url.path
    }

    private func checkPermissions(for path: String) -> Bool {
        let fileManager = FileManager.default
        let directory = (path as NSString).deletingLastPathComponent
        var isDir: ObjCBool = true

        if fileManager.fileExists(atPath: directory, isDirectory: &isDir), isDir.boolValue {
            return fileManager.isWritableFile(atPath: directory)
        }
        return false
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

    private func playSuccessSound() {
        successAudioPlayer?.play()
    }

    private func playFailureSound() {
        failureAudioPlayer?.play()
    }
}

struct GenerateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateButtonView(
            inputDirectory: .constant(""),
            alertMessage: .constant(""),
            showAlert: .constant(false),
            exclusionList: .constant([]),
            outputFile: .constant(""),
            showingAlertModal: .constant(false),
            selectedFileFormat: "Markdown"
        )
    }
}
