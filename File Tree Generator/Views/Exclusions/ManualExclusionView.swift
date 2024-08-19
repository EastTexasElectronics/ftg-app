import SwiftUI

struct ManualExclusionView: View {
    @Binding var manualExclusion: String
    @Binding var exclusionList: Set<String>

    var body: some View {
        HStack(spacing: 0) {
            TextField("Manually add a custom exclusion pattern. Comma Separated ex(pattern,.pattern1,pattern2).", text: $manualExclusion, onCommit: {
                addManualExclusion()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .help("Please ensure items are comma separated.")
            .padding(.vertical, 2)

            Button("Add") {
                addManualExclusion()
            }
            .help("Click to add the exclusion pattern.")
        }
    }

    private func addManualExclusion() {
        guard !manualExclusion.isEmpty else { return }
        
        let patterns = manualExclusion.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        for pattern in patterns {
            exclusionList.insert(pattern)
            print("Added manual exclusion: \(pattern)")
        }
        
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
