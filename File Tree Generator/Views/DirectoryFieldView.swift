import SwiftUI

/// A view that displays a labeled text field with a "Browse" button.
/// This view is used to allow the user to enter or select a directory path.
///
/// - Parameters:
///   - title: The placeholder text for the text field, indicating its purpose.
///   - text: A binding to the text field's value, representing the directory path.
///   - buttonAction: The action to be performed when the "Browse" button is clicked.
struct DirectoryField: View {
    var title: String
    @Binding var text: String
    var buttonAction: () -> Void

    var body: some View {
        HStack {
            // Text field for entering directory path
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing, 10)

            // Browse button that triggers the provided action
            Button(action: buttonAction) {
                Text("Browse")
            }
        }
    }
}

// MARK: - Preview
struct DirectoryField_Previews: PreviewProvider {
    @State static var text = ""

    static var previews: some View {
        DirectoryField(title: "Select Directory", text: $text) {
            // Example action for preview
            print("Browse button tapped")
        }
        .padding()
        .frame(width: 400)
    }
}
