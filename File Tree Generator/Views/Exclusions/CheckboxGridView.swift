import SwiftUI

struct CheckboxGridView: View {
    @Binding var selectedLanguages: Set<String>
    @Binding var exclusionList: Set<String>

    @State private var tempSelectedLanguages: Set<String> = []
    @State private var searchText: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 10) {
            Text("Select Languages/Frameworks to Exclude")
                .font(.headline)
                .padding(.top)

            TextField("Search Languages/Frameworks", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 150)), count: 5), spacing: 10) {
                    ForEach(filteredLanguages(), id: \.name) { language in
                        CheckboxView(isChecked: tempSelectedLanguages.contains(language.name), label: language.name) {
                            toggleSelection(of: language.name)
                        }
                        .help(language.patterns.joined(separator: ", "))
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 400)

            Spacer()

            HStack {
                Spacer()
                
                Button(action: {
                    applyChanges()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Apply")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .onAppear {
            tempSelectedLanguages = selectedLanguages
        }
        .padding()
        .frame(width: 800, height: 600)
    }

    private func filteredLanguages() -> [LanguageExclusion] {
        if searchText.isEmpty {
            return languagesAndExclusions.sorted { $0.name < $1.name }
        } else {
            return languagesAndExclusions.filter { $0.name.localizedCaseInsensitiveStarts(with: searchText) }.sorted { $0.name < $1.name }
        }
    }

    private func toggleSelection(of item: String) {
        if tempSelectedLanguages.contains(item) {
            tempSelectedLanguages.remove(item)
        } else {
            tempSelectedLanguages.insert(item)
        }
    }

    private func applyChanges() {
        selectedLanguages = tempSelectedLanguages
        updateExclusionList()
    }

    private func updateExclusionList() {
        exclusionList.removeAll()
        for language in selectedLanguages {
            if let patterns = languagesAndExclusions.first(where: { $0.name == language })?.patterns {
                exclusionList.formUnion(patterns)
            }
        }
    }
}

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
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 150)
    }
}

extension String {
    func localizedCaseInsensitiveStarts(with prefix: String) -> Bool {
        return self.lowercased().hasPrefix(prefix.lowercased())
    }
}

// MARK: - Preview
struct CheckboxGridView_Previews: PreviewProvider {
    @State static var selectedLanguages = Set<String>()
    @State static var exclusionList = Set<String>()

    static var previews: some View {
        CheckboxGridView(selectedLanguages: $selectedLanguages, exclusionList: $exclusionList)
            .previewLayout(.sizeThatFits)

        CheckboxView(isChecked: false, label: "Swift", onToggle: {})
            .frame(width: 200)
            .previewLayout(.sizeThatFits)
    }
}
