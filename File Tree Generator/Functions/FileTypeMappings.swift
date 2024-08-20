import Foundation

// Mapping of file type categories to their respective extensions
let fileTypeCategories: [String: [String]] = [
    "Document": ["pdf", "doc", "docx", "txt", "rtf", "odt", "xls", "xlsx", "ppt", "pptx", "md"],
    "Audio": ["mp3", "wav", "flac", "aac", "ogg", "m4a", "wma", "aiff", "aac", "midi"],
    "Video": ["mp4", "mov", "avi", "mkv", "flv", "wmv", "webm", "m4v", "mpg", "mpeg"],
    "Image": ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "svg", "ico", "webp", "heic", "psd"],
    "Code": [
        "abc", "abap", "as", "adb", "cls", "apl", "groovy", "asm", "s", "lsp", "awk", "bashrc",
        "bash_profile", "c", "o", "obj", "exe", "cs", "vbp", "frm", "prg", "clj", "coffee", "lisp",
        "cr", "ct", "d", "dart_tool", "dcu", "dfm", "el", "ex", "erl", "e", "eslintcache", "fs",
        "f", "for", "gs", "go", "hack", "haskell", "icn", "pro", "inf", "io", "java", "class", "jar",
        "js", "iml", "jl", "kt", "kshrc", "vi", "lad", "lisp", "lua", "m", "mq4", "nat", "rbt", "m",
        "pas", "pl", "pm", "php", "pli", "pls", "ps", "red", "ring", "scala", "scm", "st", "vala",
        "v", "vhd", "prg", "code-workspace", "wasm", "xml", "yaml", "yml", "zshrc", "zprofile",
        "swift", "html", "css", "py", "rb", "sh", "go", "rs", "ts", "json", "yml", "yaml"
    ],
    "Compressed": ["zip", "rar", "tar", "gz", "7z", "bz2", "xz"],
    "Executable": ["exe", "app", "bat", "sh", "msi", "bin", "run", "dmg", "pkg", "elf"],
    "Database": ["db", "sql", "sqlite", "mdb", "accdb", "csv", "tsv"],
    "Font": ["ttf", "otf", "woff", "woff2", "eot"],
    "Presentation": ["ppt", "pptx", "key", "odp"],
    "Spreadsheet": ["xls", "xlsx", "csv", "ods"],
    "PDF": ["pdf"]
]

// Mapping of categories to their respective icons
let categoryIcons: [String: String] = [
    "Document": "📝",
    "Audio": "💿",
    "Video": "🎦",
    "Image": "🖼️",
    "Code": "🖥️",
    "Compressed": "📦",
    "Executable": "⚙️",
    "Database": "🗄️",
    "Font": "🔤",
    "Presentation": "📈",
    "Spreadsheet": "📊",
    "PDF": "📄",
    "Default": "📁",  // Default for directories
    "Unknown": "⬧"    // Default for unknown file types
]

// Function to get the appropriate icon for a given file extension
func getIcon(for fileExtension: String) -> String {
    for (category, extensions) in fileTypeCategories {
        if extensions.contains(fileExtension.lowercased()) {
            return categoryIcons[category] ?? categoryIcons["Default"]!
        }
    }
    return categoryIcons["Unknown"]!
}
