// FileTreeGenerator.swift
import Foundation

struct FileTreeGenerator {
    var inputDirectory: String
    var outputLocation: String
    var excludePatterns: [String]
    var selectedFileFormat: String

    func shouldExclude(_ path: String) -> Bool {
        return excludePatterns.contains(where: { path.contains($0) })
    }

    func isDirectory(_ url: URL) -> Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        return isDir.boolValue
    }

    func generateContent(from directory: URL, liveUpdate: @escaping (String) -> Void) -> Bool {
        let fileManager = FileManager.default
        var result = ""

        if let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil) {
            var currentDepth = 0
            for case let fileURL as URL in enumerator {
                let relativePath = fileURL.path.replacingOccurrences(of: directory.path + "/", with: "")
                
                if shouldExclude(relativePath) {
                    enumerator.skipDescendants()
                    continue
                }

                let depth = relativePath.components(separatedBy: "/").count
                let newLine: String

                if selectedFileFormat == "HTML" {
                    newLine = generateHTMLLine(fileURL: fileURL, depth: depth, currentDepth: &currentDepth)
                } else {
                    newLine = generateTextLine(fileURL: fileURL, depth: depth)
                }

                result += newLine
                liveUpdate(newLine)
            }
            if selectedFileFormat == "HTML" {
                result += String(repeating: "</ul>", count: currentDepth)
                liveUpdate(String(repeating: "</ul>", count: currentDepth))
            }
        }
        return writeContent(result, to: URL(fileURLWithPath: outputLocation))
    }

    private func generateTextLine(fileURL: URL, depth: Int) -> String {
        let indent = String(repeating: "  ", count: depth - 1)
        if isDirectory(fileURL) {
            return "\(indent)- 📁 \(fileURL.lastPathComponent)/\n"
        } else {
            return "\(indent)- 📄 \(fileURL.lastPathComponent)\n"
        }
    }

    private func generateHTMLLine(fileURL: URL, depth: Int, currentDepth: inout Int) -> String {
        var result = ""
        if depth > currentDepth {
            result += "<ul>"
        } else if depth < currentDepth {
            result += String(repeating: "</ul>", count: currentDepth - depth)
        }
        currentDepth = depth

        let itemClass = isDirectory(fileURL) ? "folder" : "file"
        result += "<li class=\"\(itemClass)\">\(fileURL.lastPathComponent)</li>"
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

    func run(liveUpdate: @escaping (String) -> Void) -> Bool {
        let inputURL = URL(fileURLWithPath: inputDirectory)
        return generateContent(from: inputURL, liveUpdate: liveUpdate)
    }
}
