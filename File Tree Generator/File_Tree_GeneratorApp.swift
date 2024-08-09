import SwiftUI

@main
struct FileTreeGeneratorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()  // The main content view for the application
        }
        .commands {
            CommandMenu("About") {
                Button("About File Tree Generator") {
                    NSApp.orderFrontStandardAboutPanel(nil)  // Opens the standard About panel
                }
                .keyboardShortcut("a")  // Keyboard shortcut for the About menu

                Button("Help") {
                    appDelegate.showHelpWindow()
                }
                .keyboardShortcut("?")  // Keyboard shortcut for the Help menu
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var helpWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
    }

    @objc func showHelpWindow() {
        if helpWindow == nil {
            helpWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 600),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered, defer: false)
            helpWindow?.title = "Help"
            helpWindow?.contentView = NSHostingView(rootView: HelpView())
            helpWindow?.center()
            helpWindow?.makeKeyAndOrderFront(nil)
        } else {
            helpWindow?.makeKeyAndOrderFront(nil)
        }
    }

    @objc func closeHelpWindow() {
        helpWindow?.close()
        helpWindow = nil
    }
}
