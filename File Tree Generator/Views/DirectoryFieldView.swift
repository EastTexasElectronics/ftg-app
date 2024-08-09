import SwiftUI

struct DirectoryField: View {
    var title: String
    @Binding var text: String
    var buttonAction: () -> Void

    var body: some View {
        HStack {
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing, 10)
            
            Button(action: buttonAction) {
                Text("Browse")
            }
        }
    }
}
