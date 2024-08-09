import Foundation

struct FileTreeGenerator {

    var inputDirectory: String
    var outputLocation: String
    var excludePatterns: [String]

    func shouldExclude(_ path: String) -> Bool {
        for pattern in excludePatterns {
            if path.contains(pattern) {
                return true
            }
        }
        return false
    }

    func isDirectory(_ url: URL) -> Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        return isDir.boolValue
    }

    func generateMarkdown(from directory: URL) -> String {
        var result = ""

        let fileManager = FileManager.default
        if let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil) {
            for case let fileURL as URL in enumerator {
                let relativePath = fileURL.path.replacingOccurrences(of: directory.path + "/", with: "")

                if shouldExclude(relativePath) {
                    enumerator.skipDescendants()
                    continue
                }

                let depth = relativePath.components(separatedBy: "/").count
                let indent = String(repeating: "\t", count: depth - 1)

                if isDirectory(fileURL) {
                    result += "\(indent)- \(fileURL.lastPathComponent)/\n"
                } else {
                    result += "\(indent)- \(fileURL.lastPathComponent)\n"
                }
            }
        }

        return result
    }

    func writeMarkdown(_ markdown: String, to location: URL) {
        do {
            try markdown.write(to: location, atomically: true, encoding: .utf8)
            print("Markdown file created at: \(location.path)")
        } catch {
            print("Failed to write file: \(error.localizedDescription)")
        }
    }

    func run() {
        let inputURL = URL(fileURLWithPath: inputDirectory)
        let outputURL = URL(fileURLWithPath: outputLocation)

        let markdown = generateMarkdown(from: inputURL)
        writeMarkdown(markdown, to: outputURL)
    }
}
