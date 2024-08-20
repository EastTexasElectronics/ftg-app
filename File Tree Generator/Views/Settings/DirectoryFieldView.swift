// DirectoryFieldView.swift
import SwiftUI

struct DirectoryField: View {
    var title: String
    @Binding var text: String
    var buttonAction: () -> Void

    var body: some View {
        HStack(spacing: 1) {
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 250)
                .accessibilityLabel(title)

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
