import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

let sections = content.split(separator: "\n")
                      .compactMap { substring in
                          let sectionAssignments = substring.split(separator: ",")
                          return sectionAssignments
                      }

var fullOverlappingPairsCount = 0
var partialOverlappingPairsCount = 0

sections.forEach { sections in
    let leftSections = sections[0].split(separator: "-")
                                  .compactMap({Int($0)})
    let rightSections = sections[1].split(separator: "-")
                                   .compactMap({Int($0)})

    let leftRange = (leftSections[0]..<leftSections[1] + 1).map({ String($0) })
    let rightRange = (rightSections[0]..<rightSections[1] + 1).map({ String($0) })
    
    // Find fully overlapping sections
    if leftRange.contains(rightRange) || rightRange.contains(leftRange) {
        fullOverlappingPairsCount += 1
    }
    
    // Find if the left sections have any match with the right section
    if leftRange.filter({ rightRange.contains($0) }).count > 0 {
        partialOverlappingPairsCount += 1
    }
    
}

// q1 - fully overlapping sections
print(fullOverlappingPairsCount)

// q2 - partial overlapping sections
print(partialOverlappingPairsCount)
