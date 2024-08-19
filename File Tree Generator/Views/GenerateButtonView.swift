
import SwiftUI

struct GenerateButtonView: View {
    @Binding var inputDirectory: String
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    @Binding var exclusionList: Set<String>
    @Binding var outputFile: String
    @Binding var showingAlertModal: Bool
    var selectedFileFormat: String

    var body: some View {
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
    }

    private func generateFileTree() {
        guard !inputDirectory.isEmpty else {
            alertMessage = "Please select an input directory."
            showAlert = true
            return
        }

        let fileExtension = selectedFileFormat.contains(".txt") ? ".txt" : ".md"
        let outputLocation = outputFile.isEmpty ? getUniqueOutputFileName(for: "\(inputDirectory)/file_tree\(fileExtension)") : getUniqueOutputFileName(for: outputFile)

        let startTime = Date()
        let generator = FileTreeGenerator(inputDirectory: inputDirectory, outputLocation: outputLocation, excludePatterns: Array(exclusionList), selectedFileFormat: selectedFileFormat)
        
        if checkPermissions(for: outputLocation) {
            if generator.run() {
                let endTime = Date()
                let elapsedTime = endTime.timeIntervalSince(startTime)
                alertMessage = "File tree generated at \(outputLocation) in \(String(format: "%.2f", elapsedTime)) seconds."
            } else {
                alertMessage = "Failed to generate file tree. Please check your permissions or file path."
            }
            showAlert = true
        } else {
            showingAlertModal = true
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
}
