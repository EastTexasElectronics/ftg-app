import SwiftUI
import AVFoundation

struct GenerateButtonView: View {
    @Binding var inputDirectory: String
    @Binding var exclusionList: Set<String>
    @Binding var outputFile: String
    @Binding var selectedFileFormat: String

    @State private var fileTree: String = ""
    @State private var isGenerating: Bool = false
    @State private var showFileTreeView: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSuccess: Bool = false

    @State private var successAudioPlayer: AVAudioPlayer?
    @State private var failureAudioPlayer: AVAudioPlayer?

    // New State variables to hold the correct types
    @State private var directorySize: Int64 = 0
    @State private var elapsedTime: Double = 0.0
    @State private var outputLocation: String = ""

    var body: some View {
        VStack {
            Button(action: startFileGeneration) {
                Text("Generate File Tree")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .frame(height: 50)
                    .buttonStyle(PlainButtonStyle())
                    .focusable(false)
            }
            .disabled(inputDirectory.isEmpty)
            .onAppear {
                setupAudioPlayers()
            }
            .sheet(isPresented: $isGenerating) {
                SpinnerView(isGenerating: $isGenerating)
            }
            .sheet(isPresented: $showFileTreeView) {
                FileTreeView(
                    fileTree: $fileTree,
                    isGenerating: $showFileTreeView,
                    isSuccess: $isSuccess,
                    alertMessage: $alertMessage
                )
            }
        }
    }

    private func startFileGeneration() {
        guard !inputDirectory.isEmpty else {
            alertMessage = "Please select an input directory."
            isSuccess = false
            showFileTreeView = false
            isGenerating = false
            playFailureSound()
            return
        }

        fileTree = ""
        isGenerating = true
        showFileTreeView = false

        DispatchQueue.global(qos: .userInitiated).async {
            let fileExtension = self.getFileExtension(for: self.selectedFileFormat)
            self.outputLocation = self.outputFile.isEmpty ? self.getUniqueOutputFileName(for: "\(self.inputDirectory)/file_tree\(fileExtension)") : self.outputFile

            let startTime = Date()
            let generator = FileTreeGenerator(inputDirectory: self.inputDirectory, outputLocation: self.outputLocation, excludePatterns: Array(self.exclusionList), selectedFileFormat: self.selectedFileFormat)

            let success = generator.run { _ in
                // No longer appending lines during the generation process
            }

            DispatchQueue.main.async {
                self.isGenerating = false
                if success {
                    // Directly calculating the directory size and elapsed time
                    self.directorySize = self.calculateDirectorySize(atPath: self.inputDirectory)  // Calculate directory size
                    self.elapsedTime = Date().timeIntervalSince(startTime)  // Capture elapsed time
                    
                    // Logging for debugging
                    print("Directory Size calculated: \(self.directorySize)")
                    print("Elapsed Time calculated: \(self.elapsedTime)")
                    print("Output Location set to: \(self.outputLocation)")
                    
                    self.fileTree = (try? String(contentsOfFile: self.outputLocation)) ?? "Failed to load the generated file tree."
                    self.isSuccess = true
                    self.playSuccessSound()
                } else {
                    self.alertMessage = "Failed to generate file tree. Please check your permissions or file path."
                    self.isSuccess = false
                    self.playFailureSound()
                }
                // Show the FileTreeView upon completion
                self.showFileTreeView = true
            }
        }
    }

    private func getFileExtension(for format: String) -> String {
        switch format {
        case "Markdown":
            return ".md"
        case "Plain Text":
            return ".txt"
        case "HTML":
            return ".html"
        default:
            return ".md"
        }
    }

    private func getUniqueOutputFileName(for path: String) -> String {
        var url = URL(fileURLWithPath: path)
        let fileManager = FileManager.default
        var counter = 1

        let baseName = url.deletingPathExtension().lastPathComponent
        let fileExtension = url.pathExtension

        while fileManager.fileExists(atPath: url.path) {
            let newName = "\(baseName)_\(counter)"
            url.deleteLastPathComponent()
            url.appendPathComponent(newName)
            url.appendPathExtension(fileExtension)
            counter += 1
        }

        return url.path
    }

    private func calculateDirectorySize(atPath path: String) -> Int64 {
        let fileManager = FileManager.default
        var totalSize: Int64 = 0

        if let enumerator = fileManager.enumerator(atPath: path) {
            for file in enumerator {
                let filePath = (path as NSString).appendingPathComponent(file as! String)
                do {
                    let attributes = try fileManager.attributesOfItem(atPath: filePath)
                    if let fileSize = attributes[.size] as? Int64 {
                        totalSize += fileSize
                    }
                } catch {
                    print("Error calculating size for file: \(filePath)")
                }
            }
        }
        return totalSize
    }

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
