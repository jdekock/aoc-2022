import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

let shapeScore: [String: Int] = [
    "X": 1,
    "Y": 2,
    "Z": 3
]

let gameScore: [String: Int] = [
    "AX": 3,
    "AY": 6,
    "AZ": 0,
    "BX": 0,
    "BY": 3,
    "BZ": 6,
    "CX": 6,
    "CY": 0,
    "CZ": 3,
]

let strategies: [String: [String: Int]] = [
    "X": ["A": 3, "B": 1, "C": 2],
    "Y": ["A": 4, "B": 5, "C": 6],
    "Z": ["A": 8, "B": 9, "C": 7]
]

var scoreStrategyOne = 0
var scoreStrategyTwo = 0

let _ = content.split(separator: "\n") // Split into lines for each play
               .map({ substring in
                   let plays = substring.split(separator: " ").compactMap{ String($0) } // Split play in 2 hands for the opponent and player

                   let opponentHand = plays[0]
                   let playerHand = plays[1]
                   
                   guard let shapeScore = shapeScore[playerHand] else { return } // Get score for the played hand
                   guard let gameScore = gameScore[opponentHand + playerHand] else { return } // Get score for the result of the game
                   
                   guard let strategy = strategies[playerHand] else  { return } // Get strategy based on player hand
                   
                   let strategyScore = strategy[opponentHand] // Get score based on the opponent play
                   
                   scoreStrategyOne += shapeScore
                   scoreStrategyOne += gameScore
                   
                   scoreStrategyTwo += strategyScore ?? 0
               })

// Score strategy 1
print(scoreStrategyOne)
print(scoreStrategyTwo)


