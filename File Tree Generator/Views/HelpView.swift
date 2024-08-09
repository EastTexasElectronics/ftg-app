import SwiftUI

// TODO: Add link to help page roberthavelaar.com/file-tree-generator-app#help
// TODO: Add Email Support link contact@eastetexaselectronics.com (should open default mail client)
// TODO: Add Close Button

struct HelpView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("File Tree Generator Help")
                .font(.title)
                .padding(.bottom, 10)

            Text("How to use this application:")
                .font(.headline)
                .padding(.bottom, 5)

            Text("1. Select an input directory using the 'Select Directory' button.")
            Text("2. Choose an output file location. By default, the file will be saved to the input directory. with the name 'file-tree-HH-MM-SS.md'.")
            Text("3. Use the 'Select Languages/Frameworks' button to exclude specific patterns.")
            Text("4. You can manually add custom exclusion patterns as well by entering them in the 'Exclusion Patterns' text field in a comma-separated list.")
            Text("5. Click 'Generate File Tree' to create the file tree.")

            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 400)
    }
}
