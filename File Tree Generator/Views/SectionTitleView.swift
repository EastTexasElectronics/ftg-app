import SwiftUI

/// A view that displays a section title with a consistent style.
struct SectionTitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
