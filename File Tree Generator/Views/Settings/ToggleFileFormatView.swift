// ToggleFileFormatView.swift
import SwiftUI

struct ToggleFileFormatView: View {
    @Binding var selectedFileFormat: String

    var body: some View {
        HStack {
            Picker("", selection: $selectedFileFormat) {
                Text("Markdown").tag("Markdown")
                Text("Plain Text").tag("Plain Text")
                Text("HTML").tag("HTML")
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 200)
        }
        .help("Select the desired output file format.")
    }
}
