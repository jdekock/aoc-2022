import Foundation

struct Monkey {
    var items: [Int]
    var operation: (operation: String, amount: String)
    var test: Int
    var positiveThrow: Int
    var negativeThrow: Int
    var inspectedItems: Int
}

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var monkeys: [Monkey] = content.split(separator: "\n\n")
                               .compactMap({ strings in
                                   let lines = strings.split(separator: "\n")
                                   let newMonkey = Monkey(items: getNumbers(from: String(lines[1])),
                                                          operation: getOperation(from: String(lines[2])),
                                                          test: lines[3].split(separator: " ").compactMap({Int($0)}).first!,
                                                          positiveThrow: lines[4].split(separator: " ").compactMap({Int($0)}).first!,
                                                          negativeThrow: lines[5].split(separator: " ").compactMap({Int($0)}).first!,
                                                          inspectedItems: 0)
                                   
                                    return newMonkey
                                })

let modulus = monkeys.compactMap { $0.test }.reduce(1, *)
var monkeysPt1 = throwItems(monkeys: monkeys, rounds: 20, modulus: 0, divisible: true)
var monkeysPt2 = throwItems(monkeys: monkeys, rounds: 10000, modulus: modulus, divisible: false)

monkeysPt1 = monkeysPt1.sorted(by: { $0.inspectedItems > $1.inspectedItems })
monkeysPt2 = monkeysPt2.sorted(by: { $0.inspectedItems > $1.inspectedItems })

print("Monkey business part 1: \(monkeysPt1[0].inspectedItems * monkeysPt1[1].inspectedItems)")
print("Monkey business part 2: \(monkeysPt2[0].inspectedItems * monkeysPt2[1].inspectedItems)")

func getNumbers(from string: String) -> [Int] {
    let string = string.replacingOccurrences(of: "Starting items: ", with: "")
                       .replacingOccurrences(of: " ", with: "")
    let numbers = string.split(separator: ",").compactMap({Int($0)})
    return numbers
}

func getOperation(from string: String) -> (operation: String, amount: String) {
    let string = string.replacingOccurrences(of: "Operation: new = old ", with: "")
    let operation = string.split(separator: " ")
    return (operation: String(operation[0]), amount: String(operation[1]))
}

func throwItems(monkeys: [Monkey], rounds: Int, modulus: Int, divisible: Bool) -> [Monkey] {
    var monkeys = monkeys
    for _ in 1...rounds {
        for (index, _) in monkeys.enumerated() {
            var monkey = monkeys[index]
            
            monkey.items.forEach { item in
                var item = item
                switch monkey.operation.0 {
                case "*": item = item * (Int(monkey.operation.1) ?? item)
                case "+": item = item + (Int(monkey.operation.1) ?? item)
                default: break;
                }
                
                item = divisible ? item / 3 : item % modulus
                
                monkeys[(item % monkey.test == 0) ? monkey.positiveThrow : monkey.negativeThrow].items.append(item)
                monkeys[index].inspectedItems += 1
            }
            
            monkeys[index].items.removeAll()
        }
    }
    
    return monkeys
}
