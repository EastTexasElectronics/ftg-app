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
        var fileCount = 0
        var directoryCount = 0

        let startTime = Date()

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
                
                if isDirectory(fileURL) {
                    directoryCount += 1
                } else {
                    fileCount += 1
                }
            }
            if selectedFileFormat == "HTML" {
                result += String(repeating: "</ul>", count: currentDepth)
                liveUpdate(String(repeating: "</ul>", count: currentDepth))
            }
        }

        // Calculate stats including the number of files and directories
        let directorySize = calculateDirectorySize(atPath: inputDirectory)
        let elapsedTime = Date().timeIntervalSince(startTime)

        // Append stats to result
        result += "\n---\n"
        result += "Directory Size: \(formatSize(bytes: directorySize))\n"
        result += "Elapsed Time: \(String(format: "%.2f", elapsedTime)) seconds\n"
        result += "Total Files: \(fileCount)\n"
        result += "Total Directories: \(directoryCount)\n"
        result += "Output Location: \(outputLocation)\n"

        return writeContent(result, to: URL(fileURLWithPath: outputLocation))
    }

    private func generateTextLine(fileURL: URL, depth: Int) -> String {
        let indent = String(repeating: "  ", count: depth - 1)
        let fileExtension = fileURL.pathExtension.lowercased()
        let icon = getIcon(for: fileExtension)
        
        if isDirectory(fileURL) {
            return "\(indent)- \(icon) \(fileURL.lastPathComponent)/\n"
        } else {
            return "\(indent)- \(icon) \(fileURL.lastPathComponent)\n"
        }
    }

    private func generateHTMLLine(fileURL: URL, depth: Int, currentDepth: inout Int) -> String {
        var result = ""
        let fileExtension = fileURL.pathExtension.lowercased()
        let icon = getIcon(for: fileExtension)

        if depth > currentDepth {
            result += "<ul>"
        } else if depth < currentDepth {
            result += String(repeating: "</ul>", count: currentDepth - depth)
        }
        currentDepth = depth

        let itemClass = isDirectory(fileURL) ? "folder" : "file"
        result += "<li class=\"\(itemClass)\">\(icon) \(fileURL.lastPathComponent)</li>"
        return result
    }

    func writeContent(_ content: String, to location: URL) -> Bool {
        do {
            try content.write(to: location, atomically: true, encoding: .utf8)
            
            // Ensure all data is written and the file is closed
            if let fileHandle = FileHandle(forWritingAtPath: location.path) {
                fileHandle.synchronizeFile()
                fileHandle.closeFile()
            }

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

    private func calculateDirectorySize(atPath path: String) -> Int64 {
        let fileManager = FileManager.default
        var totalSize: Int64 = 0

        if let enumerator = fileManager.enumerator(atPath: path) {
            for file in enumerator {
                let filePath = (path as NSString).appendingPathComponent(file as! String)
                do {
                    let attributes = try fileManager.attributesOfItem(atPath: filePath)
                    if let fileSize = attributes[.size] as? Int64 {
                        totalSize += fileSize
                    }
                } catch {
                    print("Error calculating size for file: \(filePath)")
                }
            }
        }
        return totalSize
    }

    private func formatSize(bytes: Int64) -> String {
        let kb: Int64 = 1_000
        let mb: Int64 = kb * 1_000
        let gb: Int64 = mb * 1_000
        let tb: Int64 = gb * 1_000

        if bytes >= tb {
            return String(format: "%.2f TB", Double(bytes) / Double(tb))
        } else if bytes >= gb {
            return String(format: "%.2f GB", Double(bytes) / Double(gb))
        } else if bytes >= mb {
            return String(format: "%.2f MB", Double(bytes) / Double(mb))
        } else if bytes >= kb {
            return String(format: "%.2f KB", Double(bytes) / Double(kb))
        } else {
            return "\(bytes) bytes"
        }
    }
}
