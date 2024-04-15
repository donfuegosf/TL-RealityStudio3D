import SwiftUI

struct ScansFolderView: View {
    @ObservedObject var scansFolderManager = ScansFolderManager()
    @State private var activeAlert: ActiveAlert?

    var body: some View {
        NavigationView {
            List {
                if scansFolderManager.currentPath.count > 1 {
                    Button("Go Up") {
                        scansFolderManager.goUp()
                    }
                }
                ForEach(scansFolderManager.files, id: \.name) { file in
                    HStack {
                        if file.isDirectory {
                            Button(file.name) {
                                scansFolderManager.goIntoDirectory(file.name)
                            }
                            .buttonStyle(PlainButtonStyle())  // Apply plain style to prevent any unintended button effects
                        } else {
                            Text(file.name)
                        }
                        Spacer()
                        Button(action: {
                            activeAlert = .deleteConfirm(file.name)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())  // Ensure this button doesn't affect the layout or clickable area of the text
                    }
                }
            }
            .navigationBarTitle(Text(scansFolderManager.currentPath.last?.components(separatedBy: "/").last ?? "Scans"), displayMode: .inline)
            .alert(item: $activeAlert) { alertType in
                switch alertType {
                case .deleteConfirm(let fileName):
                    return Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete \(fileName)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            scansFolderManager.deleteFile(fileName: fileName)
                            activeAlert = nil  // Manually dismiss the alert after action
                        },
                        secondaryButton: .cancel()
                    )
                default:
                    return Alert(title: Text("Unhandled Alert"), message: Text("An unexpected error occurred."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct ScansFolderView_Previews: PreviewProvider {
    static var previews: some View {
        ScansFolderView()
    }
}
