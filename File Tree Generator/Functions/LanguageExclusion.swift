import Foundation

/// A struct representing a language exclusion pattern.
/// Each `LanguageExclusion` consists of a name and an array of file patterns to exclude.
struct LanguageExclusion {
    let name: String
    let patterns: [String]
}

/// A list of languages, tools, and corresponding exclusion patterns.
/// This list includes programming languages, frameworks, IDE-specific files, and certain configurations that are commonly excluded when generating file trees.
let languagesAndExclusions: [LanguageExclusion] = [
    LanguageExclusion(name: "ABC", patterns: ["*.abc"]),
    LanguageExclusion(name: "ABAP", patterns: ["*.abap"]),
    LanguageExclusion(name: "ActionScript", patterns: ["*.as"]),
    LanguageExclusion(name: "Ada", patterns: ["*.adb"]),
    LanguageExclusion(name: "Apex", patterns: ["*.cls"]),
    LanguageExclusion(name: "APL", patterns: ["*.apl"]),
    LanguageExclusion(name: "Apache Groovy", patterns: ["*.groovy"]),
    LanguageExclusion(name: "Assembly language", patterns: ["*.asm", "*.s"]),
    LanguageExclusion(name: "AutoLISP", patterns: ["*.lsp"]),
    LanguageExclusion(name: "AWK", patterns: ["*.awk"]),
    LanguageExclusion(name: "Bash", patterns: [".bashrc", ".bash_profile"]),
    LanguageExclusion(name: "bc", patterns: []),
    LanguageExclusion(name: "Bourne shell", patterns: []),
    LanguageExclusion(name: "C", patterns: ["*.o", "*.obj", "*.exe"]),
    LanguageExclusion(name: "C#", patterns: ["bin", "obj"]),
    LanguageExclusion(name: "C++", patterns: ["*.o", "*.obj", "*.dll", "*.exe"]),
    LanguageExclusion(name: "C shell", patterns: []),
    LanguageExclusion(name: "Classic Visual Basic", patterns: ["*.vbp", "*.frm"]),
    LanguageExclusion(name: "Clipper", patterns: ["*.prg"]),
    LanguageExclusion(name: "Clojure", patterns: ["*.clj"]),
    LanguageExclusion(name: "CoffeeScript", patterns: ["*.coffee"]),
    LanguageExclusion(name: "Common Lisp", patterns: ["*.lisp"]),
    LanguageExclusion(name: "Crystal", patterns: ["*.cr"]),
    LanguageExclusion(name: "cT", patterns: ["*.ct"]),
    LanguageExclusion(name: "D", patterns: ["*.d"]),
    LanguageExclusion(name: "Dart", patterns: ["*.dart_tool"]),
    LanguageExclusion(name: "Delphi", patterns: ["*.dcu", "*.dfm"]),
    LanguageExclusion(name: "Dot Files", patterns: [".*"]),
    LanguageExclusion(name: "Elixir", patterns: ["*.ex"]),
    LanguageExclusion(name: "Emacs Lisp", patterns: ["*.el"]),
    LanguageExclusion(name: "Erlang", patterns: ["*.erl"]),
    LanguageExclusion(name: "Euphoria", patterns: ["*.e"]),
    LanguageExclusion(name: "ESLint", patterns: [".eslintcache"]),
    LanguageExclusion(name: "F#", patterns: ["*.fs"]),
    LanguageExclusion(name: "Fortran", patterns: ["*.f", "*.for"]),
    LanguageExclusion(name: "Genie", patterns: ["*.gs"]),
    LanguageExclusion(name: "Go", patterns: ["vendor", "*.test"]),
    LanguageExclusion(name: "Hack", patterns: ["*.hack"]),
    LanguageExclusion(name: "Haskell", patterns: [".stack-work"]),
    LanguageExclusion(name: "Icon", patterns: ["*.icn"]),
    LanguageExclusion(name: "IDL", patterns: ["*.pro"]),
    LanguageExclusion(name: "Inform", patterns: ["*.inf"]),
    LanguageExclusion(name: "Io", patterns: ["*.io"]),
    LanguageExclusion(name: "Java", patterns: ["*.class", "*.jar"]),
    LanguageExclusion(name: "JavaScript", patterns: ["node_modules", "dist", "build"]),
    LanguageExclusion(name: "JetBrains", patterns: [".idea", "*.iml"]),
    LanguageExclusion(name: "Julia", patterns: ["*.jl"]),
    LanguageExclusion(name: "Kotlin", patterns: ["*.kt"]),
    LanguageExclusion(name: "Korn shell", patterns: [".kshrc"]),
    LanguageExclusion(name: "LabVIEW", patterns: ["*.vi"]),
    LanguageExclusion(name: "Ladder Logic", patterns: ["*.lad"]),
    LanguageExclusion(name: "Lisp", patterns: ["*.lisp"]),
    LanguageExclusion(name: "Lit", patterns: ["node_modules", "dist"]),
    LanguageExclusion(name: "LiveCode", patterns: ["*.livecode"]),
    LanguageExclusion(name: "Logo", patterns: []),
    LanguageExclusion(name: "Lua", patterns: ["*.lua"]),
    LanguageExclusion(name: "MATLAB", patterns: ["*.m"]),
    LanguageExclusion(name: "Mercury", patterns: ["*.m"]),
    LanguageExclusion(name: "ML", patterns: ["*.ml"]),
    LanguageExclusion(name: "MQL4", patterns: ["*.mq4"]),
    LanguageExclusion(name: "NATURAL", patterns: ["*.nat"]),
    LanguageExclusion(name: "Next.js", patterns: ["node_modules", ".next", "out"]),
    LanguageExclusion(name: "NXT-G", patterns: ["*.rbt"]),
    LanguageExclusion(name: "Objective-C", patterns: ["*.m", "*.h"]),
    LanguageExclusion(name: "OpenCL", patterns: ["*.cl"]),
    LanguageExclusion(name: "OpenEdge ABL", patterns: ["*.p"]),
    LanguageExclusion(name: "Oz", patterns: ["*.oz"]),
    LanguageExclusion(name: "Pascal", patterns: ["*.pas"]),
    LanguageExclusion(name: "Perl", patterns: ["*.pl", "*.pm"]),
    LanguageExclusion(name: "PHP", patterns: ["vendor"]),
    LanguageExclusion(name: "PL/I", patterns: ["*.pli"]),
    LanguageExclusion(name: "PL/SQL", patterns: ["*.pls"]),
    LanguageExclusion(name: "PostScript", patterns: ["*.ps"]),
    LanguageExclusion(name: "Preact", patterns: ["node_modules", "dist"]),
    LanguageExclusion(name: "Prettier", patterns: [".prettiercache"]),
    LanguageExclusion(name: "Prolog", patterns: ["*.pl"]),
    LanguageExclusion(name: "Python", patterns: ["__pycache__", "*.pyc"]),
    LanguageExclusion(name: "Q", patterns: ["*.q"]),
    LanguageExclusion(name: "R", patterns: ["*.RData", "*.rds"]),
    LanguageExclusion(name: "Racket", patterns: ["*.rkt"]),
    LanguageExclusion(name: "React", patterns: ["node_modules", ".next", "build"]),
    LanguageExclusion(name: "Red", patterns: ["*.red"]),
    LanguageExclusion(name: "Ring", patterns: ["*.ring"]),
    LanguageExclusion(name: "Ruby", patterns: ["Gemfile.lock"]),
    LanguageExclusion(name: "Rust", patterns: ["target"]),
    LanguageExclusion(name: "S", patterns: ["*.s"]),
    LanguageExclusion(name: "SAS", patterns: ["*.sas7bdat"]),
    LanguageExclusion(name: "Scala", patterns: ["*.scala"]),
    LanguageExclusion(name: "Scheme", patterns: ["*.scm"]),
    LanguageExclusion(name: "Scratch", patterns: []),
    LanguageExclusion(name: "Smalltalk", patterns: ["*.st"]),
    LanguageExclusion(name: "Solid.js", patterns: ["node_modules", "dist"]),
    LanguageExclusion(name: "SPARK", patterns: ["*.adb"]),
    LanguageExclusion(name: "SQL", patterns: ["*.sql"]),
    LanguageExclusion(name: "Stata", patterns: ["*.do"]),
    LanguageExclusion(name: "Stencil", patterns: ["node_modules", "dist"]),
    LanguageExclusion(name: "Swift", patterns: [".build", "DerivedData"]),
    LanguageExclusion(name: "Tcl", patterns: ["*.tcl"]),
    LanguageExclusion(name: "Transact-SQL", patterns: ["*.sql"]),
    LanguageExclusion(name: "TypeScript", patterns: ["node_modules", "dist", "*.ts"]),
    LanguageExclusion(name: "VB.NET", patterns: ["bin", "obj"]),
    LanguageExclusion(name: "VBScript", patterns: ["*.vbs"]),
    LanguageExclusion(name: "Vala", patterns: ["*.vala"]),
    LanguageExclusion(name: "Verilog", patterns: ["*.v"]),
    LanguageExclusion(name: "VHDL", patterns: ["*.vhd"]),
    LanguageExclusion(name: "Visual FoxPro", patterns: ["*.prg"]),
    LanguageExclusion(name: "VS Code", patterns: [".vscode", "*.code-workspace"]),
    LanguageExclusion(name: "Vue.js", patterns: ["node_modules", "dist"]),
    LanguageExclusion(name: "WebAssembly", patterns: ["*.wasm"]),
    LanguageExclusion(name: "XML", patterns: ["*.xml"]),
    LanguageExclusion(name: "YAML", patterns: ["*.yaml", "*.yml"]),
    LanguageExclusion(name: "Zsh", patterns: [".zshrc", ".zprofile"])
].sorted(by: { $0.name < $1.name })  // Sort the languages alphabetically by name
