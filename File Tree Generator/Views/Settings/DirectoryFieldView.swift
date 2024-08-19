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
        HStack(spacing: 1) {
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 250)

            Button(action: buttonAction) {
                Text("Browse")
                    .accessibilityLabel("Select a Directory")
                    .padding(.vertical, 1)
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                    .focusable(false)
            }
        }
    }
}

// MARK: - Preview
struct DirectoryField_Previews: PreviewProvider {
    @State static var text = ""

    static var previews: some View {
        DirectoryField(title: "Select Directory", text: $text) {
            print("Browse button tapped")
        }
        .padding()
        .frame(width: 400)
    }
}
