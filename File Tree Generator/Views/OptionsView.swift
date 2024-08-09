import SwiftUI

/// A view that contains and organizes options for selecting languages/frameworks,
/// choosing a file format, and adding manual exclusion patterns.
/// - Parameters:
///   - isShowingLanguageSelector: A binding that controls whether the language selector is displayed.
///   - selectedLanguages: A binding that stores the selected languages/frameworks.
///   - exclusionList: A binding that stores the list of exclusion patterns.
///   - selectedFileFormat: A binding that stores the selected file format.
///   - manualExclusion: A binding that stores manually added exclusion patterns.
struct OptionsView: View {
    @Binding var isShowingLanguageSelector: Bool  // Controls the display of the language selector
    @Binding var selectedLanguages: Set<String>  // Stores the selected languages/frameworks
    @Binding var exclusionList: Set<String>  // Stores the list of exclusion patterns
    @Binding var selectedFileFormat: String  // Stores the selected file format
    @Binding var manualExclusion: String  // Stores manually added exclusion patterns

    var body: some View {
        VStack(spacing: 15) {
            // Language selection and file format section
            HStack {
                LanguageSelectionView(isShowingLanguageSelector: $isShowingLanguageSelector, selectedLanguages: $selectedLanguages, exclusionList: $exclusionList)
                    .padding(.horizontal)

                FileFormatDropdownView(selectedFileFormat: $selectedFileFormat)
                    .padding(.trailing, 20)
            }
            
            // Manual exclusion entry section
            ManualExclusionView(manualExclusion: $manualExclusion, exclusionList: $exclusionList)
                .padding(.horizontal)
        }
        .padding(.top, 10)
    }
}

// MARK: - Preview
struct OptionsView_Previews: PreviewProvider {
    @State static var isShowingLanguageSelector = false
    @State static var selectedLanguages: Set<String> = []
    @State static var exclusionList: Set<String> = []
    @State static var selectedFileFormat = "Markdown (.md)"
    @State static var manualExclusion = ""

    static var previews: some View {
        OptionsView(
            isShowingLanguageSelector: $isShowingLanguageSelector,
            selectedLanguages: $selectedLanguages,
            exclusionList: $exclusionList,
            selectedFileFormat: $selectedFileFormat,
            manualExclusion: $manualExclusion
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
