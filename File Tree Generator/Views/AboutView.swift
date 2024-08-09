import SwiftUI

struct AboutView: View {
    @State private var updateAvailable: Bool = false

    var body: some View {
        VStack {
            Text("File Tree Generator")
                .font(.title)
                .padding(.bottom, 10)

            if updateAvailable {
                Text("New version available!")
                    .foregroundColor(.red)
                    .padding(.bottom, 5)
            }

            Text("Version 1.0.0")
                .font(.subheadline)
                .padding(.bottom, 20)

            Text("This application helps you generate a Markdown file tree of a selected directory, allowing you to exclude files and folders based on programming languages and frameworks.")
                .padding()
                .multilineTextAlignment(.center)

            Spacer()

            // Website Link
            Link("Visit Website", destination: URL(string: "https://roberthavelaar.dev/file-tree-generator-app")!)
                .padding(.bottom, 10)

            // Buy Me a Coffee Link
            Link("Buy Me a Coffee", destination: URL(string: "https://www.buymeacoffee.com/roberthavelaar")!)
                .padding(.bottom, 10)

            // GitHub Link
            Link("View on GitHub", destination: URL(string: "https://github.com/roberthavelaar/file-tree-generator")!)
                .padding(.bottom, 10)

            // Update or Leave a Review Button
            if updateAvailable {
                Button("Update Now") {
                    if let url = URL(string: "https://apps.apple.com/app/file-tree-generator/id6621270239") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .padding(.bottom, 20)
            } else {
                Link("Leave a Review", destination: URL(string: "https://apps.apple.com/app/file-tree-generator/id6621270239?action=write-review")!)
                    .padding(.bottom, 20)
            }

            // Dynamic Year
            Text("© \(Calendar.current.component(.year, from: Date())) Robert Havelaar. All rights reserved.")
                .font(.footnote)
                .padding(.bottom, 20)

            // Close Button
            Button("Close") {
                NSApplication.shared.keyWindow?.close()
            }
            .padding(.bottom, 10)
        }
        .frame(maxWidth: 400, maxHeight: 400)
        .padding()
        .onAppear {
            checkForUpdate()
        }
    }

    private func checkForUpdate() {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=6621270239") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch App Store data.")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {

                    let currentVersion = "1.0.0" // Replace this with your app's current version

                    DispatchQueue.main.async {
                        if appStoreVersion != currentVersion {
                            self.updateAvailable = true
                        }
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
