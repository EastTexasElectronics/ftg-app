import SwiftUI

/**
 A view that provides a multi-selection grid for choosing programming languages or frameworks to exclude from the file tree generation process.

 - Parameters:
    - selectedLanguages: A binding to a set of selected languages/frameworks.
    - exclusionList: A binding to a set of exclusion patterns based on the selected languages/frameworks.
*/
struct CheckboxGridView: View {
    @Binding var selectedLanguages: Set<String>
    @Binding var exclusionList: Set<String>

    @State private var tempSelectedLanguages: Set<String> = []
    @State private var searchText: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 10) {
            // Search Bar for filtering languages/frameworks
            TextField("Search Languages/Frameworks", text: $searchText)
                .padding(7)
                .cornerRadius(8)
                .padding(.horizontal)

            // Grid of languages/frameworks with checkboxes
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 150)), count: 5), spacing: 10) {
                    ForEach(filteredLanguages(), id: \.name) { language in
                        CheckboxView(isChecked: tempSelectedLanguages.contains(language.name), label: language.name) {
                            toggleSelection(of: language.name)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 400)

            Button(action: {
                applyChanges()
                presentationMode.wrappedValue.dismiss() // Close and apply changes if nothing is selected applies nothing.
            }) {
                Text("Apply")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .buttonStyle(PlainButtonStyle())
            .help("Apply changes and close the window")
            .padding(.bottom, 10)
        }
        .onAppear {
            // Initialize tempSelectedLanguages with current selections
            tempSelectedLanguages = selectedLanguages
        }
        .padding()
    }

    /**
     Filters the list of languages/frameworks based on the search text.

     - Returns: A list of `LanguageExclusion` objects that match the search criteria.
    */
    private func filteredLanguages() -> [LanguageExclusion] {
        if searchText.isEmpty {
            return languagesAndExclusions.sorted { $0.name < $1.name }
        } else {
            return languagesAndExclusions.filter { $0.name.localizedCaseInsensitiveStarts(with: searchText) }.sorted { $0.name < $1.name }
        }
    }

    /**
     Toggles the selection state of a given language/framework.

     - Parameter item: The name of the language/framework to toggle.
    */
    private func toggleSelection(of item: String) {
        if tempSelectedLanguages.contains(item) {
            tempSelectedLanguages.remove(item)
        } else {
            tempSelectedLanguages.insert(item)
        }
    }

    /**
     Applies the temporary selection to the actual selection and updates the exclusion list.
    */
    private func applyChanges() {
        selectedLanguages = tempSelectedLanguages
        updateExclusionList()
    }

    /**
     Updates the exclusion list based on the selected languages/frameworks.
    */
    private func updateExclusionList() {
        exclusionList.removeAll()
        for language in selectedLanguages {
            if let patterns = languagesAndExclusions.first(where: { $0.name == language })?.patterns {
                exclusionList.formUnion(patterns)
            }
        }
    }
}

/**
 A view that represents an individual checkbox with a label.

 - Parameters:
    - isChecked: A state variable that indicates whether the checkbox is checked.
    - label: The text label displayed next to the checkbox.
    - onToggle: A closure that is called when the checkbox is toggled.
*/
struct CheckboxView: View {
    @State var isChecked: Bool
    let label: String
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                isChecked.toggle()
                onToggle()
            }) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
            }
            .buttonStyle(PlainButtonStyle())
            .help("Toggle to select or deselect \(label).")

            Text(label)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading) // Left-align the text
        }
        .frame(minWidth: 150)
    }
}

/**
 An extension to the `String` class to add a case-insensitive prefix match.

 - Parameter prefix: The prefix to match against.
 - Returns: A Boolean value indicating whether the string starts with the specified prefix.
*/
extension String {
    func localizedCaseInsensitiveStarts(with prefix: String) -> Bool {
        return self.lowercased().hasPrefix(prefix.lowercased())
    }
}
