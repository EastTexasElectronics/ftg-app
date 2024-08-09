import SwiftUI

struct ContentView: View {
    @State private var showingHelp = false
    @State private var showingAbout = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                // About Button
                Button(action: {
                    showingAbout.toggle()
                }) {
                    Text("About")
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .help("Show information about this application.")
                .sheet(isPresented: $showingAbout) {
                    AboutView()
                }

                // Help Button
                Button(action: {
                    showingHelp.toggle()
                }) {
                    Text("Help")
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .help("Show help information.")
                .sheet(isPresented: $showingHelp) {
                    HelpView()
                }
            }
            .padding(.trailing)
            
            Spacer()
            
            // Main Title
            Text("File Tree Generator")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 40)
            
            // Example Section: More UI components go here
            // You could include buttons for input/output directory selection, etc.
            Text("Select your directories and options below...")
                .font(.headline)
                .padding(.bottom, 20)
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
