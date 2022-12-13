import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var alphabetScores = (0..<26).map({Character(UnicodeScalar("a".unicodeScalars.first!.value + $0) ?? Unicode.Scalar.init(0))})
let data: [[Character]] = content.split(separator: "\n")
                                 .compactMap({
                                     return Array($0).compactMap({ Character(String($0)) })
                                 })

struct Position {
    var x: Int
    var y: Int
    var height: Int
    var letter: Character
    var path: [[Int]]
}

var points: [[Position]] = [[]]
var startPoint: Position?
var endPoint: Position?

for (verticalIndex, line) in data.enumerated() {
    points.append([])
    for (horizontalIndex, letter) in line.enumerated() {
        var position = Position(x: horizontalIndex, y: verticalIndex, height: 0, letter: Character("a"), path: [])
        if letter == Character("S") {
            position.letter = Character("S")
            startPoint = position
        } else if letter == Character("E") {
            position.height = 25
            position.letter = Character("E")
            endPoint = position
        } else {
            let heightScore = alphabetScores.firstIndex(of: letter) ?? 25
            position.letter = letter
            position.height = heightScore
        }

        points[verticalIndex].append(position)
    }
}

points.removeLast()

// part 1
breadthFirstSearch(from: endPoint!, to: startPoint, map: points)

// part 2
breadthFirstSearch(from: endPoint!, to: nil, map: points)

func breadthFirstSearch(from: Position, to: Position?, map: [[Position]]) {
    var map = map
    var queue: [Position] = []
    var visited: Set<[Int]> = Set()

    queue.append(from)
    visited.insert([from.x, from.y])

    while !queue.isEmpty {
        let position = queue.removeFirst()

        if let to = to, position.x == to.x && position.y == to.y {
            print("Found shortest path to top with stepcount:")
            print(position.path.count)
            break
        } else if to == nil, position.letter ==  Character("a") {
            print("Found shortest path to a with stepcount:")
            print(position.path.count)
            break
        }

        //find neighbours
        var neighbours: [Position] = []

        //position above
        if position.y > 0 {
            neighbours.append(map[position.y - 1][position.x])
        }

        //position below
        if position.y < map.count - 1 {
            neighbours.append(map[position.y + 1][position.x])
        }

        //position left
        if position.x > 0 {
            neighbours.append(map[position.y][position.x - 1])
        }

        //position right
        if position.x < map[0].count - 1 {
            neighbours.append(map[position.y][position.x + 1])
        }

        neighbours = neighbours.filter({ $0.height >= position.height - 1 })
        neighbours.forEach { neighbour in
            if visited.insert([neighbour.x, neighbour.y]).inserted {
                var neighbour = neighbour
                neighbour.path = position.path
                neighbour.path.append([position.x, position.y])
                queue.append(neighbour)
            }
        }
    }
}
