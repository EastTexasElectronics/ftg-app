import SwiftUI

/// A view that allows the user to select programming languages or frameworks to exclude from the file tree generation.
/// This view provides a button that opens a modal with a grid of checkboxes to select or deselect languages/frameworks.
///
/// - Parameters:
///   - isShowingLanguageSelector: A binding to a boolean value that determines whether the language selector modal is displayed.
///   - selectedLanguages: A binding to a set of selected languages/frameworks.
///   - exclusionList: A binding to a set of exclusion patterns based on the selected languages/frameworks.
struct LanguageSelectionView: View {
    @Binding var isShowingLanguageSelector: Bool
    @Binding var selectedLanguages: Set<String>
    @Binding var exclusionList: Set<String>

    var body: some View {
        VStack(alignment: .leading) {
            // Button to open the language selection modal
            Button("Select Default Exclusions") {
                isShowingLanguageSelector.toggle()
            }
            .help("Click to select the pre-set languages or frameworks you want to exclude.")
            .sheet(isPresented: $isShowingLanguageSelector) {
                CheckboxGridView(selectedLanguages: $selectedLanguages, exclusionList: $exclusionList)
            }
        }
    }
}

// MARK: - Preview
struct LanguageSelectionView_Previews: PreviewProvider {
    @State static var isShowingLanguageSelector = false
    @State static var selectedLanguages: Set<String> = []
    @State static var exclusionList: Set<String> = []

    static var previews: some View {
        LanguageSelectionView(isShowingLanguageSelector: $isShowingLanguageSelector, selectedLanguages: $selectedLanguages, exclusionList: $exclusionList)
            .padding()
            .frame(width: 400)
    }
}
