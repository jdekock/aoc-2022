import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

// First, generate arrays for each stack of boxes
var stacks: [[String]] = [[]]

content.split(separator: "\n")
       .compactMap { line in
           if line.contains("[") {
               let lineParsed = line.replacingOccurrences(of: "[", with: "")
                   .replacingOccurrences(of: "]", with: "")
                   .replacingOccurrences(of: "    ", with: " . ")
                   .split(separator: " ")
               
               return lineParsed
           } else {
               return nil
           }
       }
       .reversed()
       .forEach { line in
           var index = 0
           line.forEach { character in
               if !stacks.indices.contains(index) {
                   stacks.append([])
               }
               
               if character != "." {
                   stacks[index].insert(String(character), at: 0)
               }
               
               index += 1
           }
       }

// secondly, parse the move lines
var usesModel9001 = true

content.split(separator: "\n")
       .compactMap { line in
           if line.contains("move") {
               let numbers = line.split(separator: " ")
                                 .compactMap { Int($0) }
               return numbers
           } else {
               return nil
           }
       }
       .forEach { move in
           let amount = move[0] - 1
           let fromStack = move[1] - 1
           let toStack = move[2] - 1

           if usesModel9001 {
               stacks[toStack].insert(contentsOf: stacks[fromStack][0...amount], at: 0)
           } else {
               stacks[toStack].insert(contentsOf: stacks[fromStack][0...amount].reversed(), at: 0)
           }
           stacks[fromStack].removeFirst(amount + 1)
       }

let topBoxes = stacks.map { boxes in
    return boxes.first ?? ""
}

print(topBoxes)


