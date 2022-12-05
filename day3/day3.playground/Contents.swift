import Foundation

//Extension to split an array in chunks of a given size
extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var alphabetScores = (0..<26).map({Character(UnicodeScalar("a".unicodeScalars.first!.value + $0) ?? Unicode.Scalar.init(0))})
alphabetScores.append(contentsOf: (0..<26).map({Character(UnicodeScalar("A".unicodeScalars.first!.value + $0) ?? Unicode.Scalar.init(0))}))

// Priority sum per elf
let prioritySum = content.split(separator: "\n")
                         .compactMap { string in
                             let left = string.prefix(string.count / 2)
                             let right = string.suffix(string.count / 2)
                                 
                             guard let matchingCharacter = Set(left).filter({ Set(right).contains($0) }).first else { return nil }
                             return (alphabetScores.firstIndex(of: matchingCharacter) ?? 0) + 1
                         }
                         .reduce(0, +)

//Answer to q1
print(prioritySum)

// Priority sum per three elves
let prioritySetSum = content.split(separator: "\n")
                            .chunks(3)
                            .compactMap { strings in
                                guard let matchingCharacter = Set(strings[0]).filter({ Set(strings[1]).contains($0) }) // Match first against second
                                                                             .filter({ Set(strings[2]).contains($0) }).first else { return nil } // Match result of previous with third
                                return (alphabetScores.firstIndex(of: matchingCharacter) ?? 0) + 1
                            }
                            .reduce(0, +)

//Answer to q2
print(prioritySetSum)




