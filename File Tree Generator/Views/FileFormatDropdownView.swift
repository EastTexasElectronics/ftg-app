import SwiftUI

/// A view that displays a dropdown menu for selecting the output file format.
struct FileFormatDropdownView: View {
    @Binding var selectedFileFormat: String
    private let formats = ["Text (.txt)", "Markdown (.md)"]

    var body: some View {
        HStack(spacing: 0) {
            Text("File Type:")
                .padding(.trailing, 5)

            Picker(selection: $selectedFileFormat, label: Text("")) {
                ForEach(formats, id: \.self) { format in
                    Text(format).tag(format)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: 160) // Adjust width to fit content
            .background(Color.clear) // Remove the background color to avoid the grey spot
            .cornerRadius(5)
        }
        .help("Select the desired output file format.")
    }
}
