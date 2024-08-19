import SwiftUI

/// A view that provides a toggle for selecting the output file format.
struct ToggleFileFormatView: View {
    @Binding var selectedFileFormat: String

    var body: some View {
        HStack {
            Picker("", selection: $selectedFileFormat) {
                Text("Markdown").tag("Markdown")
                Text("Pain Text").tag("Pain Text")
                Text("HTML").tag("HTML")
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 200)
            
        }
        .help("Select the desired output file format.")
    }
}
