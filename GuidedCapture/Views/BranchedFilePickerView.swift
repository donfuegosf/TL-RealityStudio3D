import SwiftUI
import UniformTypeIdentifiers

class SharedViewModel: ObservableObject {
    @Published var selectedModelURL: URL? {
        didSet {
            saveSelectedModelURL()
        }
    }
    @Published var isARViewActive: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var pickedDocuments: [URL] = []

    init() {
        loadInitialData()
        setupObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.saveSelectedModelURL()
            self?.savePickedDocuments()
        }
    }

    private func saveSelectedModelURL() {
        guard let url = selectedModelURL else {
            UserDefaults.standard.removeObject(forKey: "selectedModelURL")
            return
        }
        do {
            let bookmark = try url.bookmarkData()
            UserDefaults.standard.set(bookmark, forKey: "selectedModelURL")
        } catch {
            print("Bookmarking failed: \(error)")
        }
    }

    func savePickedDocuments() {
        let bookmarks = pickedDocuments.compactMap { url in
            try? url.bookmarkData()
        }
        UserDefaults.standard.set(bookmarks, forKey: "pickedDocuments")
    }

    private func loadInitialData() {
        if let bookmarks = UserDefaults.standard.array(forKey: "pickedDocuments") as? [Data] {
            let urls = bookmarks.compactMap { data -> URL? in
                var isStale = false
                // Attempt to resolve bookmark data to a URL, handling the possibility it may be stale
                return try? URL(resolvingBookmarkData: data, bookmarkDataIsStale: &isStale)
            }
            self.pickedDocuments = urls
        }

        if let bookmarkData = UserDefaults.standard.data(forKey: "selectedModelURL") {
            var isStale = false
            // Restore the URL from bookmark data
            self.selectedModelURL = try? URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
        }
    }


}


struct BranchedFilePickerView: View {
    @EnvironmentObject var viewModel: SharedViewModel
    @State private var showDocumentPicker = false
    @State private var activeAlert: ActiveAlert?
    
    var body: some View {
        VStack {
            List(viewModel.pickedDocuments, id: \.self) { url in
                Button(url.lastPathComponent) {
                    if url.pathExtension.lowercased() == "usdz" {
                        viewModel.selectedModelURL = url
                        viewModel.isARViewActive = true
                    } else {
                        viewModel.alertMessage = "Only .usdz files are supported."
                        viewModel.showAlert = true
                        activeAlert = .unsupportedFile
                    }
                }
            }

            Spacer()

            Button("Pick Files") {
                showDocumentPicker = true
            }
            .styledAsFilePickerButton()

            if !viewModel.pickedDocuments.isEmpty {
                Button("Clear All") {
                    activeAlert = .clearConfirm
                }
                .styledAsClearButton()
            }
        }
        .padding(.bottom, 20)
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .clearConfirm:
                return Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to clear all documents?"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.pickedDocuments.removeAll()
                    },
                    secondaryButton: .cancel()
                )
            case .unsupportedFile:
                return Alert(title: Text("Unsupported File Type"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK"))
                )
            default:
                    return Alert(
                        title: Text("Error"),
                        message: Text("An unexpected situation occurred."),
                        dismissButton: .default(Text("OK"))
                    )
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            CustomDocumentPicker(pickedDocuments: $viewModel.pickedDocuments)
        }
        .navigationDestination(isPresented: $viewModel.isARViewActive) {
            if let url = viewModel.selectedModelURL {
                SimpleCameraAr(modelURL: url)
            } else {
                Text("No model selected")
            }
        }
    }
}

extension View {
    func styledAsFilePickerButton() -> some View {
        self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }

    func styledAsClearButton() -> some View {
        self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct CustomDocumentPicker: UIViewControllerRepresentable {
    @Binding var pickedDocuments: [URL]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.usdz], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: CustomDocumentPicker
        
        init(_ documentPicker: CustomDocumentPicker) {
            self.parent = documentPicker
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            DispatchQueue.main.async {
                let newUrls = urls.filter { $0.pathExtension.lowercased() == "usdz" } // Only allow 'usdz' files
                for newUrl in newUrls {
                    if let index = self.parent.pickedDocuments.firstIndex(where: { $0.lastPathComponent == newUrl.lastPathComponent }) {
                        // If a document with the same name exists, replace it
                        self.parent.pickedDocuments[index] = newUrl
                    } else {
                        // If no document with the same name exists, add the new document
                        self.parent.pickedDocuments.append(newUrl)
                    }
                }
            }
        }
    }
}
