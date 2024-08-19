import Foundation

struct FileTreeGenerator {
    var inputDirectory: String
    var outputLocation: String
    var excludePatterns: [String]
    var selectedFileFormat: String
    
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
    
    func generateContent(from directory: URL) -> String {
        switch selectedFileFormat {
        case "Markdown":
            return generateMarkdown(from: directory)
        case "Plain Text":
            return generatePlainText(from: directory)
        case "HTML":
            return generateHTML(from: directory)
        default:
            return generateMarkdown(from: directory)
        }
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
                let indent = String(repeating: "  ", count: depth - 1)
                
                if isDirectory(fileURL) {
                    result += "\(indent)- 📁 \(fileURL.lastPathComponent)/\n"
                } else {
                    result += "\(indent)- 📄 \(fileURL.lastPathComponent)\n"
                }
            }
        }
        return result
    }
    
    func generatePlainText(from directory: URL) -> String {
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
                let indent = String(repeating: "  ", count: depth - 1)
                
                if isDirectory(fileURL) {
                    result += "\(indent)\(fileURL.lastPathComponent)/\n"
                } else {
                    result += "\(indent)\(fileURL.lastPathComponent)\n"
                }
            }
        }
        return result
    }
    
    func generateHTML(from directory: URL) -> String {
        var result = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>File Tree</title>
            <style>
                body { font-family: Arial, sans-serif; }
                ul { list-style-type: none; }
                .folder::before { content: "📁 "; }
                .file::before { content: "📄 "; }
            </style>
        </head>
        <body>
        <ul>
        """
        
        let fileManager = FileManager.default
        
        if let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil) {
            var currentDepth = 0
            for case let fileURL as URL in enumerator {
                let relativePath = fileURL.path.replacingOccurrences(of: directory.path + "/", with: "")
                
                if shouldExclude(relativePath) {
                    enumerator.skipDescendants()
                    continue
                }
                
                let depth = relativePath.components(separatedBy: "/").count
                if depth > currentDepth {
                    result += "<ul>"
                } else if depth < currentDepth {
                    result += String(repeating: "</ul>", count: currentDepth - depth)
                }
                currentDepth = depth
                
                let itemClass = isDirectory(fileURL) ? "folder" : "file"
                result += "<li class=\"\(itemClass)\">\(fileURL.lastPathComponent)</li>"
            }
            result += String(repeating: "</ul>", count: currentDepth)
        }
        
        result += """
        </ul>
        </body>
        </html>
        """
        
        return result
    }
    
    func writeContent(_ content: String, to location: URL) -> Bool {
        do {
            try content.write(to: location, atomically: true, encoding: .utf8)
            print("File saved successfully at: \(location.path)")
            return true
        } catch {
            print("Failed to write file: \(error.localizedDescription)")
            return false
        }
    }
    
    func run() -> Bool {
        let inputURL = URL(fileURLWithPath: inputDirectory)
        let outputURL = URL(fileURLWithPath: outputLocation)
        
        let content = generateContent(from: inputURL)
        return writeContent(content, to: outputURL)
    }
}
