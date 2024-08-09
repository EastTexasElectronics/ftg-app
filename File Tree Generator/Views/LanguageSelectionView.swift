import SwiftUI

struct LanguageSelectionView: View {
    @Binding var isShowingLanguageSelector: Bool
    @Binding var selectedLanguages: Set<String>
    @Binding var exclusionList: Set<String>

    var body: some View {
        VStack(alignment: .leading) {
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
