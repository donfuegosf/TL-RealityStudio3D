import SwiftUI
import UniformTypeIdentifiers

class SharedViewModel: ObservableObject {
    @Published var selectedModelURL: URL?
    @Published var isARViewActive: Bool = false
}

struct BranchedFilePickerView: View {
    @EnvironmentObject var viewModel: SharedViewModel
    @State private var showDocumentPicker = false
    @State private var pickedDocuments: [URL] = []

    var body: some View {
        NavigationStack {
            VStack {
                Button("Pick Files") {
                    showDocumentPicker = true
                }
                .padding()
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker(pickedDocuments: $pickedDocuments)
                }

                List(pickedDocuments, id: \.self) { url in
                    Button(url.lastPathComponent) {
                        viewModel.selectedModelURL = url
                        viewModel.isARViewActive = true
                    }
                }
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
}


