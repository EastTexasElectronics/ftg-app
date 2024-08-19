import SwiftUI

/// A view that provides directory and file selection fields for input and output paths.
/// - Parameters:
///   - inputDirectory: A binding to the path of the selected input directory.
///   - outputFile: A binding to the path of the selected output file.
struct DirectorySelectionView: View {
    @Binding var inputDirectory: String
    @Binding var outputFile: String

    var body: some View {
        HStack(spacing: 20) {
            DirectoryField(title: "Input Directory:", text: $inputDirectory, buttonAction: selectDirectory)
            DirectoryField(title: "Output File:", text: $outputFile, buttonAction: selectOutputFile)
        }
    }

    /// Opens a panel to select a directory and updates the `inputDirectory` binding.
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

    /// Opens a panel to select a file location and updates the `outputFile` binding.
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
}

// MARK: - Preview
struct DirectorySelectionView_Previews: PreviewProvider {
    @State static var inputDirectory: String = ""
    @State static var outputFile: String = ""

    static var previews: some View {
        DirectorySelectionView(inputDirectory: $inputDirectory, outputFile: $outputFile)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
