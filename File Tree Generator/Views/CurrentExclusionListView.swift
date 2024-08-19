import SwiftUI

/// A view that displays the current list of exclusions in a grid format.
/// Each exclusion can be removed by clicking the associated remove button.
///
/// - Parameters:
///   - exclusionList: A binding to the set of exclusion patterns that are currently applied.
///   - removeExclusion: A closure that is called when the user removes an exclusion.
struct CurrentExclusionListView: View {
    @Binding var exclusionList: Set<String>
    var removeExclusion: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Scrollable grid to display exclusions
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                    // Iterate over the exclusion list and display each item
                    ForEach(Array(exclusionList), id: \.self) { item in
                        HStack {
                            // Display the exclusion pattern with truncation if too long
                            Text(item)
                                .lineLimit(1)
                                .truncationMode(.tail)

                            Spacer()

                            // Remove button for each exclusion
                            Button(action: {
                                removeExclusion(item)
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                            .help("Remove this exclusion.")
                        }
                        .padding(8)
                        .cornerRadius(6)
                    }
                }
                .padding(.horizontal, 5)
            }
            .frame(maxHeight: 300) // Increased height to make the view taller
             // Lighter background color for the entire grid container
            .cornerRadius(8)
        }
        
        .padding(.horizontal)
    }
    
}


// MARK: - Preview
struct CurrentExclusionListView_Previews: PreviewProvider {
    @State static var exclusionList: Set<String> = ["node_modules", "*.pyc", "vendor"]

    static var previews: some View {
        CurrentExclusionListView(exclusionList: $exclusionList) { item in
            exclusionList.remove(item)
        }
        .padding()
        .frame(width: 400)
    }
}
