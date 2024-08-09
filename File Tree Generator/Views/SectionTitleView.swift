import SwiftUI

/// A view that displays a section title with a consistent style.
/// - Parameter title: The title text to display.
struct SectionTitleView: View {
    let title: String  // The text to be displayed as the section title

    var body: some View {
        Text(title)
            .font(.title2)  // Apply a title2 font style
            .bold()  // Make the text bold
            .padding(.vertical, 5)  // Add vertical padding
            .frame(maxWidth: .infinity, alignment: .center)  // Center the text horizontally
    }
}

// MARK: - Preview
struct SectionTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitleView(title: "Sample Section Title")  // Preview with a sample title
    }
}
