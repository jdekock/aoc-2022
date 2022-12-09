import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var headPosition: (X: Int, Y: Int) = (X: 0, Y: 0)
var tailPosition: (X: Int, Y: Int) = (X: 0, Y: 0)
var touchPoints: [[Int]] = [[0,0]]

var rope: [(X: Int, Y: Int)] = Array(repeating: (X: 0, Y: 0), count: 10)
var ropeTouchPoints: [[Int]] = [[0,0]]

enum Move: String {
    case U, D, L, R
}

// Split input into lines with a move and amount of steps
let moves: [(Move, Int)] = content.split(separator: "\n")
                                  .compactMap { string in
                                      let moveSeparated = string.split(separator:" ")
                                      return (Move(rawValue: String(moveSeparated[0])) ?? .U, Int(moveSeparated[1]) ?? 0)
                                  }

moves.forEach { move, steps in
    for _ in 1...steps {
        switch move {
        case .U:
            headPosition.Y += 1
            rope[0].Y += 1
        case .D:
            headPosition.Y -= 1
            rope[0].Y -= 1
        case .L:
            headPosition.X -= 1
            rope[0].X -= 1
        case .R:
            headPosition.X += 1
            rope[0].X += 1
        }
        
        moveKnot(previousKnot: headPosition, currentKnot: &tailPosition)
        moveRope()
        
        if !touchPoints.contains([tailPosition.X, tailPosition.Y]) {
            touchPoints.append([tailPosition.X, tailPosition.Y])
        }
        
        if !ropeTouchPoints.contains([rope[9].X, rope[9].Y]) {
            ropeTouchPoints.append([rope[9].X, rope[9].Y])
        }
    }
}

func moveRope() {
    for knot in 1..<rope.count {
        moveKnot(previousKnot: rope[knot - 1], currentKnot: &rope[knot])
    }
}

func moveKnot(previousKnot: (X: Int, Y: Int), currentKnot: inout (X: Int, Y: Int)) {
    let xDiff = previousKnot.X - currentKnot.X
    let yDiff = previousKnot.Y - currentKnot.Y
    
    if xDiff < -1 || xDiff > 1 {
        xDiff < -1 ? (currentKnot.X -= 1) : (currentKnot.X += 1)
        currentKnot.Y < previousKnot.Y ? (currentKnot.Y += 1) : (currentKnot.Y > previousKnot.Y) ? (currentKnot.Y -= 1) : nil
    } else if yDiff < -1 || yDiff > 1 {
        (yDiff < -1) ? (currentKnot.Y -= 1) : (currentKnot.Y += 1)
        (currentKnot.X < previousKnot.X) ? (currentKnot.X += 1) : (currentKnot.X > previousKnot.X) ? (currentKnot.X -= 1) : nil
    }
}

print("q1: ")
print(touchPoints.count)

print("q2: ")
print(ropeTouchPoints.count)
