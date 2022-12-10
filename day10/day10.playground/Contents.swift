import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
let steps = content.split(separator: "\n")

var x = 1
var cycleCount = 1
var cycles: [Int] = []
var screen: [String] = [""]

steps.forEach { string in
    switch string.prefix(4) {
    case "noop":
        cycles.append(x)
        drawPixels(twice: false)
    case "addx":
        let cycleValue: Int = Int(string.split(separator: " ").last ?? "0") ?? 0
        cycles.append(contentsOf: Array(repeating: x, count: 2))

        drawPixels(twice: true)
        
        x += cycleValue
    default:
        break
    }
}

func drawPixels(twice: Bool) {
    cycleCount >= x && cycleCount < (x + 3) ? screen[screen.count - 1].append("#") : screen[screen.count - 1].append(".")
    
    if cycleCount % 40 == 0 {
        cycleCount = 1 // start new line at beginning
        screen.append("")
    } else {
        cycleCount += 1
    }
    
    // Run again for 2 cycles
    if twice {
        drawPixels(twice: false)
    }
}

// q1 - determina signal strenght
let signalStrenght = (20 * cycles[19]) + (60 * cycles[59]) + (100 * cycles[99]) + (140 * cycles[139]) + (180 * cycles[179]) + (220 * cycles[219])
print(signalStrenght)

// q2 - draw CRT
screen.forEach { line in
    print(line)
}
