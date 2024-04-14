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
        UserDefaults.standard.set(url, forKey: "selectedModelURL")
    }

    func savePickedDocuments() {
        let urlsData = pickedDocuments.compactMap { url in
            try? NSKeyedArchiver.archivedData(withRootObject: url, requiringSecureCoding: false)
        }
        UserDefaults.standard.set(urlsData, forKey: "pickedDocuments")
    }

    private func loadInitialData() {
        if let encodedData = UserDefaults.standard.array(forKey: "pickedDocuments") as? [Data] {
            let urls = encodedData.compactMap { data in
                try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSURL.self, from: data) as? URL
            }
            self.pickedDocuments = urls
        }
        self.selectedModelURL = UserDefaults.standard.url(forKey: "selectedModelURL")
    }
}



struct BranchedFilePickerView: View {
    @EnvironmentObject var viewModel: SharedViewModel
    @State private var showDocumentPicker = false

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
                    }
                }
            }

            Spacer()  // Pushes everything below to the bottom of the view

            // 'Pick Files' button with appropriate styling and padding
            Button("Pick Files") {
                showDocumentPicker = true
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .overlay(
                Rectangle() // Overlay a transparent rectangle to catch taps
                .foregroundColor(.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    showDocumentPicker = true
                }
            ) // Apply content shape after background
            .padding(.horizontal) // Padding last to ensure it does not interfere with tappable area
            .sheet(isPresented: $showDocumentPicker) {
                CustomDocumentPicker(pickedDocuments: $viewModel.pickedDocuments)
            }


            // Conditional 'Clear All' button with appropriate styling and padding
            if !viewModel.pickedDocuments.isEmpty {
                Button("Clear All") {
                    viewModel.pickedDocuments.removeAll()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                .foregroundColor(.white)
                .background(Color.red)
                
                .cornerRadius(10)
                .overlay(
                    Rectangle() // Overlay a transparent rectangle to catch taps
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.pickedDocuments.removeAll()
                    }
                )
                .padding(.horizontal)
                
            }
        }
        .padding(.bottom, 20)  // Adds bottom padding to the entire VStack for spacing from the bottom edge
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Unsupported File Type"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationDestination(isPresented: $viewModel.isARViewActive) {
            if let url = viewModel.selectedModelURL {
                SimpleCameraAr(modelURL: url)  // Ensure this view is correctly implemented to handle the AR display
            } else {
                Text("No model selected")
            }
        }
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
