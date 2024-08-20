import SwiftUI

struct FileTreeView: View {
    @Binding var fileTree: String
    @Binding var isGenerating: Bool
    @Binding var isSuccess: Bool
    @Binding var alertMessage: String
    @State private var showingLegend = false

    var body: some View {
        VStack {
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
                }
            }

            Spacer()

            // Bottom Button Section
            HStack {
                Button("Legend") {
                    showingLegend = true
                }
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
                .sheet(isPresented: $showingLegend) {
                    LegendView()
                }

                Spacer()

                Button("Close") {
                    isGenerating = false
                }
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 6)
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

    private func copyToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(fileTree, forType: .string)
        alertMessage = "File Tree copied to clipboard!"
    }
}

struct FileTreeView_Previews: PreviewProvider {
    @State static var fileTree: String = "Sample file tree content..."
    @State static var isGenerating: Bool = false
    @State static var isSuccess: Bool = true
    @State static var alertMessage: String = ""

    static var previews: some View {
        FileTreeView(
            fileTree: $fileTree,
            isGenerating: $isGenerating,
            isSuccess: $isSuccess,
            alertMessage: $alertMessage
        )
    }
}
