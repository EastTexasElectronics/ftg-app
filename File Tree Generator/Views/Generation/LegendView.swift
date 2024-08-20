import SwiftUI

/// A view that displays a legend of icons used in the file tree, showing what each icon represents.
struct LegendView: View {
    @Environment(\.presentationMode) var presentationMode

    // Sorted list of categories from the categoryIcons dictionary.
    private let categories = categoryIcons.keys.sorted()

    var body: some View {
        VStack {
            Text("Legend")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)

            Text("Hover over an item to see which extensions it includes.")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom)
                .padding(.top, 1)

            // Grid displaying the icons and categories in a two-column layout.
            LazyVGrid(columns: [GridItem(.flexible(), alignment: .leading), GridItem(.flexible(), alignment: .leading)], spacing: 20) {
                ForEach(categories, id: \.self) { category in
                    if let icon = categoryIcons[category], let fileTypes = fileTypeCategories[category] {
                        HStack {
                            Text(icon)
                                .font(.title2)
                            Text(category)
                                .font(.headline)
                                .padding(.leading, 8)
                            Spacer()
                        }
                        // Tooltip showing the file types included in each category.
                        .help(fileTypes.joined(separator: ", "))
                    } else if let icon = categoryIcons[category], category == "Unknown" {
                        HStack {
                            Text(icon)
                                .font(.title2)
                            Text("Unknown")
                                .font(.headline)
                                .padding(.leading, 8)
                            Spacer()
                        }
                        // Tooltip for unknown file types.
                        .help("Unknown file types")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)

            // Close button to dismiss the legend view.
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
                    .font(.headline)
                    .buttonStyle(PlainButtonStyle())
                    .focusable(false)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .frame(width: 350, height: 420) // Nice
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

struct LegendView_Previews: PreviewProvider {
    static var previews: some View {
        LegendView()
    }
}
