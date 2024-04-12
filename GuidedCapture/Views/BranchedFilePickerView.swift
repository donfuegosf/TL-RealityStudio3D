import SwiftUI
import UniformTypeIdentifiers

class SharedViewModel: ObservableObject {
    @Published var selectedModelURL: URL?
    @Published var isARViewActive: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
}

struct BranchedFilePickerView: View {
    @EnvironmentObject var viewModel: SharedViewModel
    @State private var showDocumentPicker = false
    @State private var pickedDocuments: [URL] = []

    var body: some View {
        VStack {
            Button("Pick Files") {
                showDocumentPicker = true
            }
            .padding()
            .sheet(isPresented: $showDocumentPicker) {
                CustomDocumentPicker(pickedDocuments: $pickedDocuments, viewModel: viewModel)
            }

            List(pickedDocuments, id: \.self) { url in
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
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Unsupported File Type"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
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

struct CustomDocumentPicker: UIViewControllerRepresentable {
    @Binding var pickedDocuments: [URL]
    var viewModel: SharedViewModel  // Passing the ViewModel to the DocumentPicker

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.usdz], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)  // Pass the ViewModel to the Coordinator
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: CustomDocumentPicker
        var viewModel: SharedViewModel  // Store ViewModel in the Coordinator

        init(_ documentPicker: CustomDocumentPicker, viewModel: SharedViewModel) {
            self.parent = documentPicker
            self.viewModel = viewModel
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            DispatchQueue.main.async {
                // Directly add only usdz files or show alert if non-usdz files somehow get selected
                let filteredUrls = urls.filter { $0.pathExtension.lowercased() == "usdz" }
                if filteredUrls.isEmpty || urls.count != filteredUrls.count {
                    self.viewModel.alertMessage = "Only .usdz files are supported."
                    self.viewModel.showAlert = true
                } else {
                    self.parent.pickedDocuments = filteredUrls
                }
            }
        }
    }
}
