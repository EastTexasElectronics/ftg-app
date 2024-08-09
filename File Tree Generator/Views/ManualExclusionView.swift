import SwiftUI

/// A view that allows users to manually add custom exclusion patterns.
/// The user can enter patterns in a text field and add them to the exclusion list.
///
/// - Parameters:
///   - manualExclusion: A binding to the text entered by the user for a custom exclusion pattern.
///   - exclusionList: A binding to the set of exclusion patterns that are currently applied.
struct ManualExclusionView: View {
    @Binding var manualExclusion: String
    @Binding var exclusionList: Set<String>

    var body: some View {
        HStack {
            // Text field for entering custom exclusion patterns
            TextField("Manually add a custom exclusion pattern. Comma Seperated ex(pattern,.pattern1,pattern2).", text: $manualExclusion, onCommit: {
                addManualExclusion()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .help("Please ensure items are comma seperated with no spaces.")
            .padding(.trailing, 10)

            // Button to add the entered exclusion pattern to the list
            Button("Add") {
                addManualExclusion()
            }
            .help("Click to add the exclusion pattern.")
        }
    }

    /// Adds the entered exclusion pattern to the exclusion list.
    /// If the text field is empty, the function does nothing.
    private func addManualExclusion() {
        guard !manualExclusion.isEmpty else { return }
        exclusionList.insert(manualExclusion)
        manualExclusion = ""
    }
}

// MARK: - Preview
struct ManualExclusionView_Previews: PreviewProvider {
    @State static var manualExclusion: String = ""
    @State static var exclusionList: Set<String> = []

    static var previews: some View {
        ManualExclusionView(manualExclusion: $manualExclusion, exclusionList: $exclusionList)
            .padding()
            .frame(width: 400)
    }
}
