import SwiftUI

struct AboutView: View {
    @Binding var isPresented: Bool
    
    var latestVersion: String? = nil

    private let appStoreURL = "https://apps.apple.com/us/app/file-tree-generator/id6621270239?mt=12"
    private let buyMeACoffeeURL = "https://buymeacoffee.com/rmhavelaar"
    private let mitLicenseURL = "https://opensource.org/licenses/MIT"

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("About File Tree Generator")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    if latestVersion != nil {
                        Text("An update is available. Please visit the App Store to download the latest version.")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    AboutSection(title: "App Version:", description: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown", link: appStoreURL)
                    
                    if let latestVersion = latestVersion {
                        AboutSection(title: "Latest Version:", description: latestVersion, link: appStoreURL)
                    }

                    AboutSection(title: "Website:", description: "roberthavelaar.dev", link: "https://www.roberthavelaar.dev/file-tree-generator-app")
                    
                    AboutSection(title: "Contact:", description: "RMHavelaar@Gmail.com", link: "mailto:RMHavelaar@Gmail.com")
                    
                    AboutSection(title: "Buy Me a Coffee:", description: "buymeacoffee.com/rmhavelaar", link: buyMeACoffeeURL)
                    
                    AboutSection(title: "App License:", description: "MIT", link: mitLicenseURL)
                    
                    AboutSection(title: "Privacy Policy:", description: "View Privacy Policy", link: "https://www.roberthavelaar.dev/file-tree-generator-app#privacy-policy")
                    
                    AboutSection(title: "Version History:", description: "View Changelog", link: "https://www.roberthavelaar.dev/file-tree-generator-app#changelog")
                }
                .padding()
            }

            HStack {
                Button(action: {
                    if let url = URL(string: appStoreURL) {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text(latestVersion != nil ? "Update Now" : "Leave a Review")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        .foregroundColor(.white)
                        .accessibilityLabel(latestVersion != nil ? "Update to the latest version" : "Leave a review on the App Store")
                }
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
                .padding(.leading)

                Spacer()

                Button(action: {
                    if let url = URL(string: buyMeACoffeeURL) {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.5)))
                        .foregroundColor(.white)
                        .accessibilityLabel("Support by buying a coffee")
                }
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
                .padding(.horizontal)

                Spacer()
                
                Button("Close") {
                    isPresented = false
                }
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.5)))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
                .padding(.trailing)
                .accessibilityIdentifier("CloseButton")
            }
            .padding(.horizontal)
            .padding(.bottom, 15)
        }
        .frame(width: 400, height: 420)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct AboutSection: View {
    let title: String
    let description: String
    let link: String?

    init(title: String, description: String, link: String? = nil) {
        self.title = title
        self.description = description
        self.link = link
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(title)
                .fontWeight(.semibold)
                .frame(width: 120, alignment: .leading)
            
            if let link = link, let url = URL(string: link) {
                Link(description, destination: url)
                    .foregroundColor(.blue)
                    .accessibilityHint("Opens in your default browser")
                    .buttonStyle(PlainButtonStyle())
                    .focusable(false)
            } else {
                Text(description)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

struct AboutView_Previews: PreviewProvider {
    @State static var isPresented = true

    static var previews: some View {
        AboutView(isPresented: $isPresented, latestVersion: "1.1")
        AboutView(isPresented: $isPresented, latestVersion: nil)
    }
}
