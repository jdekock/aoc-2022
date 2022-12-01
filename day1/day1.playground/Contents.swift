import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var elves: [Int] = []

// Split content into sets for each elf
elves = content.split(separator: "\n\n")
               .map({ substring in
                    return substring.split(separator: "\n") //Split each set into seperate values
                                    .compactMap{ Int($0) } // Map to Int value
                                    .reduce(0, +) // Sum values
               })
               .sorted { $0 > $1 } // Sort desc.

// Most calories
print(elves.first)

// Top three elves
print(elves[...2].reduce(0, +))
