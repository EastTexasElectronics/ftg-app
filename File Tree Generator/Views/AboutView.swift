import SwiftUI

/// A view that provides information about the File Tree Generator app,
/// including the current version, latest version, and links to relevant resources.
struct AboutView: View {
    /// A binding to control the presentation of the view.
    @Binding var isPresented: Bool
    
    /// The latest version available on the App Store, if any.
    var latestVersion: String? = nil
    
    /// The URL to the App Store page for the app.
    private let appStoreURL = "https://apps.apple.com/app/id6581479697"

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text("About This App")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Update message, shown if a new version is available
                    if latestVersion != nil {
                        Text("An update is available. Please visit the App Store to download the latest version.")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    // Current app version
                    AboutSection(title: "App Version:", description: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")
                    
                    // Latest version if available
                    if let latestVersion = latestVersion {
                        AboutSection(title: "Latest Version:", description: latestVersion)
                    }

                    // Website link
                    AboutSection(title: "Website:", description: "Visit our website for more information.", link: "https://www.roberthavelaar.dev/file-tree-generator-app")
                    
                    // Contact email link
                    AboutSection(title: "Contact:", description: "Contact us at Contact@EastTexasElectronics.com", link: "mailto:Contact@EastTexasElectronics.com")
                }
                .padding()
            }

            HStack {
                // Button to update the app or leave a review on the App Store
                Button(action: {
                    if let url = URL(string: appStoreURL) {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text(latestVersion != nil ? "Update Now" : "Leave a Review")
                        .padding(.horizontal)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .accessibilityLabel(latestVersion != nil ? "Update to the latest version" : "Leave a review on the App Store")
                }
                .buttonStyle(DefaultButtonStyle())
                .padding()

                Spacer()
                
                // Close button to dismiss the About view
                Button("Close") {
                    isPresented = false
                }
                .buttonStyle(DefaultButtonStyle())
                .padding()
                .accessibilityIdentifier("CloseButton")
            }
            .padding(.horizontal)
        }
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

/// A view that displays a section of information in the AboutView, which may include a title,
/// description, and optionally a link.
struct AboutSection: View {
    /// The title of the section.
    let title: String
    
    /// The description or content of the section.
    let description: String
    
    /// An optional URL to be displayed as a link.
    let link: String?

    init(title: String, description: String, link: String? = nil) {
        self.title = title
        self.description = description
        self.link = link
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .fontWeight(.semibold)
            
            // Display a link if provided, otherwise just the description text
            if let link = link, let url = URL(string: link) {
                Link(description, destination: url)
                    .foregroundColor(.blue)
                    .accessibilityHint("Opens in your default browser")
            } else {
                Text(description)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview
struct AboutView_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        AboutView(isPresented: $isPresented, latestVersion: "1.0.1")
        AboutView(isPresented: $isPresented, latestVersion: nil)
    }
}
