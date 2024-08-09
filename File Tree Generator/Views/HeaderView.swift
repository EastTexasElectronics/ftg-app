import SwiftUI

/// A view that displays the header section, including the Alert, About, and Help buttons.
struct HeaderView: View {
    @Binding var showingAlertModal: Bool
    @Binding var showingAbout: Bool
    @Binding var showingHelp: Bool
    @Binding var isFullDiskAccessEnabled: Bool

    var body: some View {
        HStack {
            Spacer()

            // Alert Button
            Button(action: {
                showingAlertModal.toggle()
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Alert!")
                        .foregroundColor(.red)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
            }
            .help("Click to see the alert details.")
            .sheet(isPresented: $showingAlertModal) {
                AlertModalView(isFullDiskAccessEnabled: $isFullDiskAccessEnabled, showingAlertModal: $showingAlertModal)
            }

            // About Button
            Button(action: { showingAbout.toggle() }) {
                Text("About")
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }

            // Help Button
            Button(action: { showingHelp.toggle() }) {
                Text("Help")
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showingHelp) {
                HelpView()
            }
        }
        .padding(.top, 10)
        .padding(.horizontal)
    }
}
