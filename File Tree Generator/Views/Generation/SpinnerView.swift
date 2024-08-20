import SwiftUI

struct SpinnerView: View {
    @Binding var isGenerating: Bool

    var body: some View {
        VStack {
            ProgressView("Generating File Tree...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }
        .frame(width: 200, height: 100)
        .cornerRadius(10)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if !isGenerating {
                    isGenerating = false
                }
            }
        }
    }
}

struct SpinnerView_Previews: PreviewProvider {
    @State static var isGenerating = true

    static var previews: some View {
        SpinnerView(isGenerating: $isGenerating)
    }
}
