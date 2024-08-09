import SwiftUI

struct ManualExclusionView: View {
    @Binding var manualExclusion: String
    @Binding var exclusionList: Set<String>

    var body: some View {
        HStack {
            TextField("Add exclusion pattern", text: $manualExclusion, onCommit: {
                addManualExclusion()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .help("Manually add a custom exclusion pattern.")
            .padding(.trailing, 10)

            Button("Add") {
                addManualExclusion()
            }
            .help("Click to add the exclusion pattern.")
        }
    }

    private func addManualExclusion() {
        guard !manualExclusion.isEmpty else { return }
        exclusionList.insert(manualExclusion)
        manualExclusion = ""
    }
}
