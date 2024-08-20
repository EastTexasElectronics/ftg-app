import SwiftUI

struct FileTreeView: View {
    @Binding var fileTree: String
    @Binding var isGenerating: Bool
    @Binding var isSuccess: Bool
    @Binding var alertMessage: String
    var directorySize: Int64
    var elapsedTime: Double
    var outputLocation: String

    var body: some View {
        VStack {
            // Title with PWD path
            Text("File Tree Generated for:")
                .font(.headline)
                .padding(.top)
            Text(outputLocation)
                .font(.subheadline)
                .foregroundColor(.blue)
                .onTapGesture {
                    openInFinder(path: outputLocation)
                }
                .padding(.bottom, 10)

            // Scrollable File Tree View
            ScrollView {
                VStack(alignment: .leading) {
                    Text(fileTree)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        .overlay(
                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: copyToClipboard) {
                                        Image(systemName: "doc.on.doc")
                                            .padding(4)
                                    }
                                    .help("Copy File Tree to Clipboard")
                                    Spacer()
                                }
                            }
                        )
                        .padding()
                        .contextMenu {
                            Button(action: {
                                copyToClipboard()
                            }) {
                                Text("Copy File Tree")
                                Image(systemName: "doc.on.doc")
                            }
                        }
                        .onTapGesture {
                            openFileOrDirectory(path: outputLocation)
                        }
                }
            }

            // Additional Info
            HStack {
                Text("Generated in \(String(format: "%.2f", elapsedTime)) seconds")
                    .font(.footnote)
                Spacer()
                Text("Directory Size: \(formatSize(bytes: directorySize))")
                    .font(.footnote)
            }
            .padding([.leading, .trailing])

            Spacer()

            // Close button at the bottom right
            HStack {
                Spacer()
                Button("Close") {
                    isGenerating = false
                }
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
            }
            .padding([.bottom, .trailing])
        }
        .frame(width: 500, height: 600)
        .cornerRadius(20)
        .shadow(radius: 20)
        .onAppear {
            if fileTree.isEmpty {
                alertMessage = "Failed to load the generated file tree."
            }
        }
    }

    private func openInFinder(path: String) {
        let url = URL(fileURLWithPath: path)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

    private func openFileOrDirectory(path: String) {
        guard let url = URL(string: path) else { return }
        NSWorkspace.shared.open(url)
    }

    private func copyToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(fileTree, forType: .string)
        // Provide feedback to the user
        alertMessage = "File Tree copied to clipboard!"
    }

    private func formatSize(bytes: Int64) -> String {
        let kb: Int64 = 1_000
        let mb: Int64 = kb * 1_000
        let gb: Int64 = mb * 1_000
        let tb: Int64 = gb * 1_000

        if bytes >= tb {
            return String(format: "%.2f TB (%,d bytes)", Double(bytes) / Double(tb), bytes)
        } else if bytes >= gb {
            return String(format: "%.2f GB (%,d bytes)", Double(bytes) / Double(gb), bytes)
        } else if bytes >= mb {
            return String(format: "%.2f MB (%,d bytes)", Double(bytes) / Double(mb), bytes)
        } else if bytes >= kb {
            return String(format: "%.2f KB (%,d bytes)", Double(bytes) / Double(kb), bytes)
        } else {
            return "\(bytes) bytes"
        }
    }
}

struct FileTreeView_Previews: PreviewProvider {
    @State static var fileTree = "Sample File Tree\nüìÅ Folder\nüìÑ File.txt"
    @State static var isGenerating = true
    @State static var isSuccess = false
    @State static var alertMessage = "Generating file tree..."
    static var directorySize: Int64 = 672
    static var elapsedTime: Double = 0.31
    static var outputLocation = "/Users/username/Documents/Project/file_tree.md"

    static var previews: some View {
        FileTreeView(
            fileTree: $fileTree,
            isGenerating: $isGenerating,
            isSuccess: $isSuccess,
            alertMessage: $alertMessage,
            directorySize: directorySize,
            elapsedTime: elapsedTime,
            outputLocation: outputLocation
        )
    }
}
