import SwiftUI

struct GenerateButton: View {
    @Binding var inputDirectory: String
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    @Binding var exclusionList: Set<String>
    @Binding var outputFile: String
    var selectedFileFormat: String // Update to accept selectedFileFormat

    var body: some View {
        Button("Generate File Tree") {
            generateFileTree()
        }
        .disabled(inputDirectory.isEmpty)
        .padding()
        .help("Click to generate the file tree based on the selected directory and exclusion patterns.")
        .foregroundColor(inputDirectory.isEmpty ? .gray : .blue)
    }

    private func generateFileTree() {
        guard !inputDirectory.isEmpty else {
            alertMessage = "Please select an input directory."
            showAlert = true
            return
        }

        // Determine file extension based on selected file format
        let fileExtension = selectedFileFormat.contains(".txt") ? ".txt" : ".md"
        let outputLocation = outputFile.isEmpty ? getUniqueOutputFileName(for: "\(inputDirectory)/file_tree\(fileExtension)") : getUniqueOutputFileName(for: outputFile)

        let startTime = Date()
        let generator = FileTreeGenerator(inputDirectory: inputDirectory, outputLocation: outputLocation, excludePatterns: Array(exclusionList))
        generator.run()
        let endTime = Date()
        let elapsedTime = endTime.timeIntervalSince(startTime)

        alertMessage = "File tree generated at \(outputLocation) in \(String(format: "%.2f", elapsedTime)) seconds."
        showAlert = true
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
}
