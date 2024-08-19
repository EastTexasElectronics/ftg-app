import SwiftUI

struct GettingStartedView: View {
    @Binding var isPresented: Bool
    @AppStorage("showGettingStartedOnLaunch") private var showGettingStartedOnLaunch = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to File Tree Generator!")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Quick Start:")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                bulletPoint("Select an input directory to generate a file tree.")
                bulletPoint("Choose an output file location for the generated tree.")
                bulletPoint("Use exclusions to omit certain files or directories.")
                bulletPoint("Save your settings as profiles for quick access.")
                bulletPoint("Customize the output format to suit your needs.")
                
                Link("Learn more", destination: URL(string: "https://roberthavelaar.dev/file-tree-generator-app#help")!)
                    .font(.subheadline)
                    .padding(.top, 5)
            }
            .padding()
            
            HStack(spacing: 10) {
                Button("Never Show This Again") {
                    showGettingStartedOnLaunch = false
                    isPresented = false
                }
                .buttonStyle(DefaultButtonStyle())
                
                Button("Buy Me a Coffee") {
                    if let url = URL(string: "https://www.buymeacoffee.com/yourname") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .buttonStyle(DefaultButtonStyle())
                
                Button("Close") {
                    isPresented = false
                }
                .buttonStyle(DefaultButtonStyle())
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 450)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(.body)
    }
}

struct GettingStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GettingStartedView(isPresented: .constant(true))
    }
}
