import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: View {
    @State private var showDocumentPicker = false
    @State private var pickedDocuments: [URL] = []
    @State private var selectedFileURL: URL?
    @State private var showModelView = false
    @State private var retryCount = 0
    @State private var isActive = false  // State to track if the ModelView is actively being used
    let maxRetryCount = 10  // Try for 10 seconds

    var body: some View {
        VStack {
            Button("Pick Files") {
                showDocumentPicker = true
            }
            .padding()
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker(pickedDocuments: $pickedDocuments)
            }

            List(pickedDocuments, id: \.self) { url in
                Button(action: {
                    self.selectFile(url)
                }) {
                    Text(url.lastPathComponent)
                }
            }
        }
        .sheet(isPresented: $showModelView, onDismiss: {
            self.cleanupAfterDismiss()
        }) {
            if let url = selectedFileURL {
                ModelView(modelFile: url, endCaptureCallback: {
                    print("Model view is being dismissed")
                    self.isActive = false  // Set isActive to false when ModelView is dismissed
                    self.cleanupAfterDismiss()
                })
            } else {
                EmptyView()  // No longer showing ProgressView, using EmptyView instead
            }
        }
        .onChange(of: showModelView) { _, newValue in
            if !newValue && selectedFileURL != nil && retryCount < maxRetryCount && isActive {
                // Only retry if the view was not actively dismissed by the user
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.retryCount += 1
                    self.showModelView = true
                }
            }
        }
    }

    private func selectFile(_ url: URL) {
        selectedFileURL = url
        retryCount = 0  // Reset retry count whenever a new file is selected
        showModelView = true
        isActive = true  // Activate the view when a file is selected
    }

    private func cleanupAfterDismiss() {
        // Reset all relevant states
        showModelView = false
        selectedFileURL = nil
        retryCount = 0
        isActive = false  // Ensure retries are stopped
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var pickedDocuments: [URL]

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ documentPicker: DocumentPicker) {
            self.parent = documentPicker
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            DispatchQueue.main.async {
                self.parent.pickedDocuments = urls
            }
        }
    }
}
