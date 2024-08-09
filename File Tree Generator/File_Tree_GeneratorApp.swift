import SwiftUI

/// The main entry point for the File Tree Generator application.
@main
struct FileTreeGeneratorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()  // The main content view for the application
        }
        .commands {
            CommandMenu("Help") {
                // About File Tree Generator Button
                Button("About File Tree Generator") {
                    NSApp.orderFrontStandardAboutPanel(nil)  // Opens the standard About panel
                }
                .keyboardShortcut("a")  // Keyboard shortcut for the About menu
                .help("Show information about the File Tree Generator application.")

                // Help Button
                Button("Help") {
                    showHelp()  // Opens the Help window
                }
                .keyboardShortcut("?")  // Keyboard shortcut for the Help menu
                .help("Show help information.")
            }
        }
    }

    /// Displays the Help window with the HelpView content.
    func showHelp() {
        let helpWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered, defer: false)
        helpWindow.title = "Help"  // Title of the Help window
        helpWindow.contentView = NSHostingView(rootView: HelpView())  // Embeds the HelpView in the window
        helpWindow.makeKeyAndOrderFront(nil)  // Displays the Help window
    }
}

/// The application delegate for the File Tree Generator.
class AppDelegate: NSObject, NSApplicationDelegate {

    /// Called when the application has finished launching.
    /// - Parameter notification: The notification indicating the application has finished launching.
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)  // Sets the app activation policy to regular
    }
}
