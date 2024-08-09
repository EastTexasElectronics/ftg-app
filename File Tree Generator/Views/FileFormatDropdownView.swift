import SwiftUI

/// A view that provides a dropdown menu for selecting the output file format.
/// - Parameters:
///   - selectedFileFormat: A binding to the selected file format, which updates when the user makes a selection.
struct FileFormatDropdownView: View {
    @Binding var selectedFileFormat: String  // Binding to store the selected file format
    private let formats = ["Text (.txt)", "Markdown (.md)"]  // Available file format options

    var body: some View {
        HStack(spacing: 0) {
            // Label for the dropdown menu
            Text("File Type:")
                .padding(.trailing, 5)

            // Dropdown menu for selecting file format
            Picker(selection: $selectedFileFormat, label: Text("")) {
                ForEach(formats, id: \.self) { format in
                    Text(format).tag(format)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: 160)  // Adjust width to fit content
            .background(Color.clear)  // Remove the background color to avoid any unwanted grey spot
            .cornerRadius(5)
        }
        .help("Select the desired output file format.")
    }
}

// MARK: - Preview
struct FileFormatDropdownView_Previews: PreviewProvider {
    @State static var selectedFileFormat = "Markdown (.md)"

    static var previews: some View {
        FileFormatDropdownView(selectedFileFormat: $selectedFileFormat)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
