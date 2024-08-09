import Foundation

/// A data structure representing a user's settings profile for the File Tree Generator application.
/// This profile includes an exclusion list and the selected file format, allowing users to save and
/// reload their preferences easily.
struct SettingsProfile: Codable {
    
    /// The set of exclusion patterns that the user wants to apply when generating a file tree.
    /// These patterns are file extensions or directory names that should be ignored.
    var exclusionList: Set<String>
    
    /// The file format selected by the user for the output file.
    /// This is a string representing formats like ".md" for Markdown or ".txt" for plain text.
    var selectedFileFormat: String
}
