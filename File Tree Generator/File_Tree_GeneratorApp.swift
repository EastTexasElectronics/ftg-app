import SwiftUI

@main
struct FileTreeGeneratorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()  // This is your main UI view
        }
        .commands {
            CommandMenu("Help") {
                Button("About File Tree Generator") {
                    NSApp.orderFrontStandardAboutPanel(nil)
                }
                .keyboardShortcut("a")
                .help("Show information about the File Tree Generator application.")

                Button("Help") {
                    showHelp()
                }
                .keyboardShortcut("?")
                .help("Show help information.")
            }
        }
    }

    func showHelp() {
        let helpWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered, defer: false)
        helpWindow.title = "Help"
        helpWindow.contentView = NSHostingView(rootView: HelpView())
        helpWindow.makeKeyAndOrderFront(nil)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
    }
}
