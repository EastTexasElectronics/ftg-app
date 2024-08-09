import SwiftUI

struct OptionsView: View {
    @Binding var isShowingLanguageSelector: Bool
    @Binding var selectedLanguages: Set<String>
    @Binding var exclusionList: Set<String>
    @Binding var selectedFileFormat: String
    @Binding var manualExclusion: String

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                LanguageSelectionView(isShowingLanguageSelector: $isShowingLanguageSelector, selectedLanguages: $selectedLanguages, exclusionList: $exclusionList)
                    .padding(.horizontal)

                FileFormatDropdownView(selectedFileFormat: $selectedFileFormat)
                    .padding(.trailing, 20)
            }
            
            ManualExclusionView(manualExclusion: $manualExclusion, exclusionList: $exclusionList)
                .padding(.horizontal)
        }
        .padding(.top, 10)
    }
}
