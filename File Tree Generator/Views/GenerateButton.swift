import SwiftUI

/// A view that provides a button to generate a file tree based on the selected input directory, output file location, exclusion patterns, and file format.
///
/// - Parameters:
///   - inputDirectory: A binding to the input directory path.
///   - alertMessage: A binding to the message that will be displayed in the alert after generation.
///   - showAlert: A binding to a boolean that controls whether the alert is shown.
///   - exclusionList: A binding to the set of exclusion patterns.
///   - outputFile: A binding to the output file path.
///   - selectedFileFormat: The selected file format, either `.md` for Markdown or `.txt` for plain text.
struct GenerateButton: View {
    @Binding var inputDirectory: String
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    @Binding var exclusionList: Set<String>
    @Binding var outputFile: String
    var selectedFileFormat: String

    var body: some View {
        Button("Generate File Tree") {
            generateFileTree()
        }
        .disabled(inputDirectory.isEmpty)
        .padding()
        .help("Click to generate the file tree based on the selected directory and exclusion patterns.")
        .foregroundColor(inputDirectory.isEmpty ? .gray : .blue)
    }

    /// Generates the file tree based on the selected directory, exclusion patterns, and file format.
    /// Displays a success or failure message based on the outcome.
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
        let generator = FileTreeGenerator(inputDirectory: inputDirectory, outputLocation: outputLocation, excludePatterns: Array(exclusionList), selectedFileFormat: selectedFileFormat)
        
        // Run the generator and display the appropriate alert message
        if generator.run() {
            let endTime = Date()
            let elapsedTime = endTime.timeIntervalSince(startTime)
            alertMessage = "File tree generated at \(outputLocation) in \(String(format: "%.2f", elapsedTime)) seconds."
        } else {
            alertMessage = "Failed to generate file tree. Please check your permissions or file path."
        }
        
        showAlert = true
    }

    /// Generates a unique output file name by appending a counter if a file with the same name already exists.
    ///
    /// - Parameter path: The initial file path.
    /// - Returns: A unique file path by appending a counter if necessary.
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
            
            // Reset to original base name before next iteration
            url = URL(fileURLWithPath: path)
        }

        return url.path
    }
}

// MARK: - Preview
struct GenerateButton_Previews: PreviewProvider {
    @State static var inputDirectory: String = ""
    @State static var alertMessage: String = ""
    @State static var showAlert: Bool = false
    @State static var exclusionList: Set<String> = []
    @State static var outputFile: String = ""
    @State static var selectedFileFormat: String = "Markdown (.md)"

    static var previews: some View {
        GenerateButton(
            inputDirectory: $inputDirectory,
            alertMessage: $alertMessage,
            showAlert: $showAlert,
            exclusionList: $exclusionList,
            outputFile: $outputFile,
            selectedFileFormat: selectedFileFormat
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
