import SwiftUI

/// A view that displays the main title of the File Tree Generator application.
struct MainTitleView: View {
    var body: some View {
        Text("File Tree Generator")  // The main title text
            .font(.largeTitle)
            .bold()
            .padding(.bottom, 10)
    }
}

// MARK: - Preview
struct MainTitleView_Previews: PreviewProvider {
    static var previews: some View {
        MainTitleView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
