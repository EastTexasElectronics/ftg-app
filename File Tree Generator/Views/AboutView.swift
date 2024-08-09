import SwiftUI
// TODO: Check the App store to see if a new update is available.
// TODO: Add a button that when no update is available says Leave a Review, if an Update is available it should say Update Now.
// TODO: Add link to website. roberthavelaar.dev/file-tree-generator-app
// TODO: Add Buy Me a Coffee Link
// TODO: Add Github Link
// TODO: Add Close Button
struct AboutView: View {
    var body: some View {
        VStack {
            Text("File Tree Generator")
                .font(.title)
                .padding(.bottom, 10)
            
// TODO: If update available add red text that says new version avaible below.
            Text("Version 1.0.0")
                .font(.subheadline)
                .padding(.bottom, 20)

            Text("This application helps you generate a Markdown file tree of a selected directory, allowing you to exclude files and folders based on programming languages and frameworks.")
                .padding()
                .multilineTextAlignment(.center)

            Spacer()
// TODO: Update this to always show the current year
            Text("© 2024 Robert Havelaar. All rights reserved.")
                .font(.footnote)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: 400, maxHeight: 300)
        .padding()
    }
}
