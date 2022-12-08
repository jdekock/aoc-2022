import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

let trees = content.split(separator: "\n")
                   .compactMap({
                       return Array($0).compactMap({ Int(String($0)) })
                   })

var visibleTreeCount = 0

//Add outer trees
visibleTreeCount += (trees.count) * 2 // Trees far left and far right
visibleTreeCount += (trees[0].count) * 2 // Trees on top and bottom
visibleTreeCount -= 4 // remove double counted edges

var scenicScore: [Int] = []

for (index, treeLine) in trees.enumerated() {
    for(treeIndex, tree) in treeLine.enumerated() {
        if index > 0 && treeIndex > 0 && index < (trees.count - 1) && treeIndex < (treeLine.count - 1) {
            let treeRow = trees.compactMap { $0[treeIndex] }
            let treesLeft = treeLine.prefix(treeIndex)
            let treesRight = treeLine.suffix((treeLine.count - 1) - treeIndex)
            let treesAbove = treeRow.prefix(index)
            let treesBelow = treeRow.suffix((trees.count - 1) - index)
            
            // q1 check if tree is visible from the edge
            var isVisible = false
            if treesLeft.filter({ $0 >= tree }).isEmpty { isVisible = true }
            if treesRight.filter({ $0 >= tree }).isEmpty { isVisible = true }
            if treesAbove.filter({ $0 >= tree }).isEmpty { isVisible = true }
            if treesBelow.filter({ $0 >= tree }).isEmpty { isVisible = true }
            
            if isVisible {
                visibleTreeCount += 1
            }
            
            // q2 check index of blocking tree
            var scenicScoreLeft = treesLeft.reversed()
                                           .enumerated()
                                           .filter{ $0.element >= tree }
                                           .map{ $0.offset + 1 }
                                           .first ?? treesLeft.count
            var scenicScoreRight = treesRight.enumerated()
                                             .filter{ $0.element >= tree }
                                             .map{ $0.offset + 1 }
                                             .first ?? treesRight.count
            var scenicScoreAbove = treesAbove.reversed()
                                             .enumerated()
                                             .filter{ $0.element >= tree }
                                             .map{ $0.offset + 1 }
                                             .first ?? treesAbove.count
            var scenicScoreBelow = treesBelow.enumerated()
                                             .filter{ $0.element >= tree }
                                             .map{ $0.offset + 1 }
                                             .first ?? treesBelow.count

            let totalScenicScore = scenicScoreLeft * scenicScoreRight * scenicScoreAbove * scenicScoreBelow
            scenicScore.append(totalScenicScore)
        }
    }
}

// q1  - visible trees
print(visibleTreeCount)

// q2 - scenic score
print(scenicScore.sorted(by: { $0 > $1 }).first ?? 0)
