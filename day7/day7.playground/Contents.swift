import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

let output = content.split(separator: "\n")
var currentDirectory: String = ""

// Prepare fileSystem and rootDirectory
var fileSystem = FileSystem()
let rootDirectory = Directory(name: "/",
                              directories: [],
                              files: [],
                              parent: nil,
                              size: 0)
fileSystem.add(directory: rootDirectory,
               parent: nil)

output.forEach { line in
    switch line.prefix(4) {
    case "$ cd":
        if line.contains("..") {
            currentDirectory = fileSystem.directories[currentDirectory]?.parent ?? "/" // move up to parent
        } else {
            let folder = line.dropFirst(5)
            currentDirectory = String("\(currentDirectory)/\(folder)").replacingOccurrences(of: "//", with: "/") // move to new folder
        }
    case "$ ls":
        break // ignore, not relevant
    case "dir ":
        let name = line.dropFirst(4)
        let directory = Directory(name: String("\(currentDirectory)/\(name)").replacingOccurrences(of: "//", with: "/"),
                                  directories: [],
                                  files: [],
                                  parent: currentDirectory,
                                  size: 0)
        fileSystem.add(directory: directory,
                       parent: currentDirectory) // create a new directory
    default:
        let fileData = line.split(separator: " ")
        let file = File(name: String(fileData[1]),
                        size: Int(fileData[0]) ?? 0)
        
        fileSystem.addFile(file: file,
                           directory: currentDirectory) // add a file to the current directory
    }
}

var totalSize = 0
var neededSize = 30000000 - (70000000 - (fileSystem.directories["/"]?.size ?? 0))
var possibleDirectories: [Directory] = []

fileSystem.directories.values.forEach { directory in
    if directory.size < 100000 {
        totalSize += directory.size
    }
    
    if directory.size > neededSize {
        possibleDirectories.append(directory)
    }
}

// q1
print("Sum of dirs below 10000:")
print(totalSize)

// q2
print("Size of smallest possible dir:")
print(possibleDirectories.sorted { $1.size > $0.size }.first?.size ?? 0)

struct FileSystem {
    var directories: [String: Directory] = [:]

    mutating func add(directory: Directory, parent: String?) {
        directories[directory.name] = directory

        if let parent = parent {
            directories[parent]?.directories.append(directory.name)
        }
    }
    
    mutating func addFile(file: File, directory: String) {
        directories[directory]?.files.append(file)
        addSize(size: file.size, directory: directory)
    }
    
    mutating func addSize(size: Int, directory: String) {
        directories[directory]?.size += size
        
        if let parent = directories[directory]?.parent {
            self.addSize(size: size, directory: parent)
        }
    }
}

struct Directory {
    var name: String
    var directories: [String]
    var files: [File]
    var parent: String?
    var size: Int
}

struct File {
    var name: String
    var size: Int
}
