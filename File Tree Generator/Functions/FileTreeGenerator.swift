import Foundation

/// A utility that generates a file tree from a given directory, formats it in Markdown, and saves it to a specified location.
/// The file tree generation respects user-defined exclusion patterns and supports different output formats.
struct FileTreeGenerator {
    
    /// The input directory from which the file tree will be generated.
    var inputDirectory: String
    
    /// The output location where the generated file tree will be saved.
    var outputLocation: String
    
    /// A list of file patterns to exclude from the generated file tree.
    var excludePatterns: [String]
    
    /// The selected file format (e.g., `.md` or `.txt`) for the output file.
    var selectedFileFormat: String
    
    /// Determines whether a given path should be excluded based on the defined patterns.
    /// - Parameter path: The file or directory path to check.
    /// - Returns: A Boolean value indicating whether the path should be excluded.
    func shouldExclude(_ path: String) -> Bool {
        for pattern in excludePatterns {
            if path.contains(pattern) {
                return true
            }
        }
        return false
    }
    
    /// Checks if the given URL points to a directory.
    /// - Parameter url: The URL to check.
    /// - Returns: A Boolean value indicating whether the URL points to a directory.
    func isDirectory(_ url: URL) -> Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    /// Generates a Markdown-formatted file tree from the specified directory.
    /// - Parameter directory: The URL of the directory to generate the file tree from.
    /// - Returns: A string containing the Markdown representation of the file tree.
    func generateMarkdown(from directory: URL) -> String {
        var result = ""
        let fileManager = FileManager.default
        
        // Enumerate the directory contents recursively
        if let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil) {
            for case let fileURL as URL in enumerator {
                let relativePath = fileURL.path.replacingOccurrences(of: directory.path + "/", with: "")
                
                // Skip directories and files that match the exclusion patterns
                if shouldExclude(relativePath) {
                    enumerator.skipDescendants()
                    continue
                }
                
                // Calculate the indentation based on the directory depth
                let depth = relativePath.components(separatedBy: "/").count
                let indent = (1..<depth).map { _ in "│   " }.joined()
                
                // Add directory or file with the appropriate icon
                if isDirectory(fileURL) {
                    result += "\(indent)📁 \(fileURL.lastPathComponent)/\n"
                } else {
                    result += "\(indent)📄 \(fileURL.lastPathComponent)\n"
                }
            }
        }
        return result
    }
    
    /// Writes the generated Markdown content to the specified location.
    /// - Parameters:
    ///   - markdown: The Markdown content to write.
    ///   - location: The URL of the file where the content will be saved.
    /// - Returns: A Boolean value indicating whether the file was written successfully.
    func writeMarkdown(_ markdown: String, to location: URL) -> Bool {
        do {
            try markdown.write(to: location, atomically: true, encoding: .utf8)
            print("File saved successfully at: \(location.path)")
            return true
        } catch {
            print("Failed to write file: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Runs the file tree generation process.
    /// - Returns: A Boolean value indicating whether the process completed successfully.
    func run() -> Bool {
        let inputURL = URL(fileURLWithPath: inputDirectory)
        let outputURL = URL(fileURLWithPath: outputLocation)
        
        let markdown = generateMarkdown(from: inputURL)
        return writeMarkdown(markdown, to: outputURL)
    }
}
