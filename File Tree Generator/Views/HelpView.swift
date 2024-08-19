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
            VStack(alignment: .leading, spacing: 8) {
                Text("How to use this application:")
                    .font(.title2)
                    .padding(.bottom, 2)

                Group {
                    Text("1. Select an input directory using the 'Select Directory' button.")
                    Text("2. (Optional) Choose an output file location. By default, the file will be saved to the input directory.")
                    Text("3. (Optional) Use the 'Add Default Exclusions' button to exclude specific preset patterns.")
                    Text("4. (Optional) You can manually add custom exclusion patterns by entering them in the 'Exclusion Patterns' text field using a comma-separated list of values. For example: pattern1, pattern2, .pattern3.")
                    Text("5. (Optional) Select the output file type: Markdown (default) or Text (.txt).")
                    Text("6. Click 'Generate File Tree' to create the file tree.")
                    Text("7. Find your file tree in the selected output directory, which by default is the same location as the input directory.")
                }
                .font(.title3)
                .padding(.bottom, 8)

                Text("Profile Management:")
                    .font(.title2)
                    .padding(.bottom, 2)

                Group {
                    Text("Save Settings: Saves your current exclusion list and file type to a named profile for commonly used project types.")
                    Text("Manage Profiles: Allows you to rename or remove profiles.")
                    Text("Profile: Select the profile you would like to use.")
                }
                .font(.title3)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil) // Ensure word wrapping instead of truncation

            Spacer(minLength: 10)

            // Bottom Button Section
            HStack {
                Button(action: {
                    if let url = URL(string: "https://www.roberthavelaar.dev/file-tree-generator-app#help") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("Visit Help Page")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        .foregroundColor(.white)
                        .accessibilityLabel("Visit the help page for more information")
                }
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
                .padding(.leading)

                Spacer()

                Button(action: {
                    if let url = URL(string: "mailto:RMHavelaar@gmail.com") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("Email Support")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.5)))
                        .foregroundColor(.white)
                        .accessibilityLabel("Email support for help")
                }
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
                .padding(.horizontal)

                Spacer()
                
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
                .padding(.trailing)
                .accessibilityIdentifier("CloseButton")
            }
            .padding(.horizontal)
            .padding(.bottom, 15)
        }
        .frame(width: 1000, height: 500)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

// MARK: - Preview

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
