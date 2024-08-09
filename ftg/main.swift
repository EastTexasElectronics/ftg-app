import Foundation

/// A utility that generates a file tree from a given directory, formats it in Markdown, and saves it to a specified location.
/// The file tree generation respects user-defined exclusion patterns and supports different output formats.
struct ftg {

    static func main() {
        let arguments = CommandLine.arguments

        if arguments.contains("-h") || arguments.contains("--help") {
            printHelp()
            return
        }

        let inputDirectory = extractArgument(named: "-d", "--directory", default: ".")
        let outputFile = extractArgument(named: "-o", "--output", default: "file_tree.md")
        let excludePatterns = extractArgument(named: "-e", "--exclude", default: "").components(separatedBy: ",")
        let format = extractArgument(named: "-f", "--format", default: "md")
        let previewMode = arguments.contains("-p") || arguments.contains("--preview")

        let generator = FileTreeGenerator(inputDirectory: inputDirectory, outputLocation: outputFile, excludePatterns: excludePatterns, selectedFileFormat: format)

        if previewMode {
            let markdown = generator.generateMarkdown(from: URL(fileURLWithPath: inputDirectory))
            print(markdown)
        } else {
            if generator.run() {
                print("File tree generated successfully at \(outputFile)")
            } else {
                print("Failed to generate file tree.")
            }
        }
    }

    private static func extractArgument(named shortName: String, _ longName: String, default defaultValue: String) -> String {
        let arguments = CommandLine.arguments

        if let index = arguments.firstIndex(of: shortName) ?? arguments.firstIndex(of: longName), index + 1 < arguments.count {
            return arguments[index + 1]
        }

        return defaultValue
    }

    private static func printHelp() {
        print("""
        Usage: ftg [options]

        Options:
          -d, --directory <path>      Specify the input directory (default is current directory)
          -o, --output <file>         Specify the output file (default is file_tree.md)
          -e, --exclude <patterns>    Specify comma-separated patterns to exclude
          -f, --format <md|txt>       Specify the output format (Markdown or plain text, default is md)
          -p, --preview               Preview the file tree in the console instead of saving it
          -h, --help                  Show this help message

        Example:
          ftg -d ~/projects -o tree.md -e node_modules,.git,build -f md
        """)
    }
}

ftg.main()
