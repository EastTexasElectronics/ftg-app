import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Title Section
            Text("File Tree Generator Help")
                .font(.title)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .center)

            // Instructions Section
            VStack(alignment: .leading, spacing: 5) {
                Text("How to use this application:")
                    .font(.headline)
                    .padding(.bottom, 10)

                Text("1. Select an input directory using the 'Select Directory' button.")
                Text("2. Choose an output file location. By default, the file will be saved to the input directory with the name 'file-tree-HH-MM-SS.md'.")
                Text("3. Use the 'Select Languages/Frameworks' button to exclude specific patterns.")
                Text("4. You can manually add custom exclusion patterns as well by entering them in the 'Exclusion Patterns' text field.")
                Text("5. Click 'Generate File Tree' to create the file tree.")
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            // Bottom Button Section
            HStack {
                // Visit Help Page Button
                Button("Visit Help Page") {
                    if let url = URL(string: "https://roberthavelaar.com/file-tree-generator-app#help") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .buttonStyle(DefaultButtonStyle())
                .padding(.leading, 40)

                Spacer()

                // Email Support Button
                Button("Email Support") {
                    if let url = URL(string: "mailto:contact@eastetexaselectronics.com") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .buttonStyle(DefaultButtonStyle())
                .padding(.bottom, 10)

                Spacer()

                // Close Button
                Button("Close") {
                    presentationMode.wrappedValue.dismiss() // Use presentationMode to dismiss the view
                }
                .buttonStyle(DefaultButtonStyle())
                .padding(.trailing, 40)
            }
            .padding(.vertical, 20)
        }
        .padding()
        .frame(minWidth: 450, minHeight: 400)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
