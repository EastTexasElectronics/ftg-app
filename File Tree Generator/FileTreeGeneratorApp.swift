import SwiftUI
import WebKit
import StoreKit

@main
struct FileTreeGeneratorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var selectedProfile: String? = "Default"
    @State private var profiles: [String: SettingsProfile] = [
        "Default": SettingsProfile(exclusionList: [], selectedFileFormat: "Markdown (.md)")
    ]
    @State private var showingSaveSettings = false
    @State private var showingManageProfiles = false

    var body: some Scene {
        WindowGroup {
            ContentView(selectedProfile: $selectedProfile, profiles: $profiles)
                .onAppear {
                    appDelegate.loadProfiles { profiles in
                        self.profiles = profiles
                        if self.selectedProfile == nil || !profiles.keys.contains(self.selectedProfile!) {
                            self.selectedProfile = profiles.keys.first
                        }
                    }
                }
                .sheet(isPresented: $showingManageProfiles) {
                    ManageProfilesView(profiles: $profiles, selectedProfile: $selectedProfile, loadProfile: appDelegate.loadProfile, removeProfile: appDelegate.removeProfile, renameProfile: appDelegate.renameProfile) {
                        showingManageProfiles = false
                    }
                }
                .sheet(isPresented: $showingSaveSettings) {
                    SaveSettingsView(isPresented: $showingSaveSettings, profileName: .constant(selectedProfile ?? ""), showError: .constant(false)) {
                        appDelegate.saveProfile(named: selectedProfile ?? "")
                    }
                }
        }
        .commands {
            CommandMenu("Settings") {
                Button("About File Tree Generator") {
                    appDelegate.showAboutWindow()
                }
                .keyboardShortcut("a")

                Button("Help") {
                    appDelegate.showHelpWindow()
                }
                .keyboardShortcut("?")

                Divider()

                // Profile Management
                Menu("Profile") {
                    Picker("Select Profile", selection: $selectedProfile) {
                        ForEach(Array(profiles.keys), id: \.self) { profile in
                            Text(profile).tag(profile as String?)
                        }
                    }
                    .onChange(of: selectedProfile, perform: { value in
                        appDelegate.loadProfile(named: value ?? "")
                    })
                    
                    Button("Manage Profiles") {
                        showingManageProfiles = true
                    }

                    Button("Save Current Settings") {
                        showingSaveSettings = true
                    }
                }
            }
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var helpWindow: NSWindow?
    var aboutWindow: NSWindow?

    @State private var profiles: [String: SettingsProfile] = [:]

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        loadProfiles { profiles in
            self.profiles = profiles
        }
    }

    @objc func showHelpWindow() {
        if helpWindow == nil {
            helpWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
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

    @objc func showAboutWindow() {
        if aboutWindow == nil {
            aboutWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                styleMask: [.titled, .closable],
                backing: .buffered, defer: false)
            aboutWindow?.title = "About File Tree Generator"
            aboutWindow?.contentView = NSHostingView(rootView: AboutView(isPresented: .constant(true)))
            aboutWindow?.center()
            aboutWindow?.makeKeyAndOrderFront(nil)
        } else {
            aboutWindow?.makeKeyAndOrderFront(nil)
        }
    }

    func loadProfiles(completion: @escaping ([String: SettingsProfile]) -> Void) {
        let decoder = JSONDecoder()
        if let savedProfiles = UserDefaults.standard.object(forKey: "savedProfiles") as? Data {
            if let loadedProfiles = try? decoder.decode([String: SettingsProfile].self, from: savedProfiles) {
                completion(loadedProfiles)
                return
            }
        }
        completion([:])
    }

    func loadProfile(named name: String) {
        guard profiles[name] != nil else { return }
        // Update app state based on loaded profile
    }

    func saveProfile(named name: String) {
        guard !name.isEmpty else { return }
        let profile = SettingsProfile(exclusionList: [], selectedFileFormat: "Markdown (.md)")
        profiles[name] = profile
        saveProfilesToUserDefaults()
    }

    func removeProfile(named name: String) {
        profiles.removeValue(forKey: name)
        saveProfilesToUserDefaults()
    }

    func renameProfile(oldName: String, newName: String) {
        guard let profile = profiles.removeValue(forKey: oldName) else { return }
        profiles[newName] = profile
        saveProfilesToUserDefaults()
    }

    private func saveProfilesToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "savedProfiles")
        }
    }

    // Add the review request function
    func requestReview() {
        print("Attempting to request a review...") // Debugging line

        // On macOS, SKStoreReviewController.requestReview() doesn't require any parameters
        SKStoreReviewController.requestReview()

        print("Review request function called.") // Debugging line
    }
}
