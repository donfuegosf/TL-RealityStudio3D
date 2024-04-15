import Foundation

class ScansFolderManager: ObservableObject {
    @Published var files: [(name: String, isDirectory: Bool)] = []
    let fileManager = FileManager.default
    var currentPath: [String]  // Stack of directory paths

    init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let initialPath = (documentsPath as NSString).appendingPathComponent("Scans")
        
        self.currentPath = [initialPath]  // Initialize with the root directory of Scans
        
        if !fileManager.fileExists(atPath: initialPath) {
            try? fileManager.createDirectory(atPath: initialPath, withIntermediateDirectories: true, attributes: nil)
        }

        listFiles(in: initialPath)
    }

    func listFiles(in path: String) {
        do {
            let items = try fileManager.contentsOfDirectory(atPath: path)
            var newFiles = [(String, Bool)]()
            for item in items {
                let itemPath = (path as NSString).appendingPathComponent(item)
                var isDir: ObjCBool = false
                if fileManager.fileExists(atPath: itemPath, isDirectory: &isDir) {
                    newFiles.append((item, isDir.boolValue))
                }
            }
            self.files = newFiles
            if !currentPath.contains(path) {
                currentPath.append(path)  // Only add new paths, avoid duplication
            }
        } catch {
            print("Error listing files: \(error)")
        }
    }

    func goIntoDirectory(_ directoryName: String) {
        let newPath = (currentPath.last! as NSString).appendingPathComponent(directoryName)
        listFiles(in: newPath)
    }

    func goUp() {
        if currentPath.count > 1 {  // Ensure we are not at the initial directory
            currentPath.removeLast()
            listFiles(in: currentPath.last!)
        }
    }

    func deleteFile(fileName: String) {
        let filePath = (currentPath.last! as NSString).appendingPathComponent(fileName)
        do {
            try fileManager.removeItem(atPath: filePath)
            listFiles(in: currentPath.last!)  // Refresh the list after deletion
        } catch {
            print("Failed to delete file: \(error)")
        }
    }
}
