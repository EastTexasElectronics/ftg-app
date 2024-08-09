import SwiftUI

struct CurrentExclusionListView: View {
    @Binding var exclusionList: Set<String>
    var removeExclusion: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 10) {
                    ForEach(Array(exclusionList), id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Button(action: {
                                removeExclusion(item)
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                            .help("Remove this exclusion.")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: 150)
        }
    }
}
