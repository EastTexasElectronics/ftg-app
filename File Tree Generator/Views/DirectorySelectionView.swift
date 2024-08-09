import SwiftUI

struct DirectorySelectionView: View {
    @Binding var inputDirectory: String
    @Binding var outputFile: String

    var body: some View {
        HStack(spacing: 20) {
            DirectoryField(title: "Input Directory:", text: $inputDirectory, buttonAction: selectDirectory)
            DirectoryField(title: "Output File:", text: $outputFile, buttonAction: selectOutputFile)
        }
    }

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
}
