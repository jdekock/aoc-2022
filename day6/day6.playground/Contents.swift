import Foundation

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

let chars = Array(content)

findMarker(chars, 4) // q1 - find marker at 4 unique chars
findMarker(chars, 14) // q2 - find marker at 14 unique chars

func findMarker(_ chars: [Character], _ length: Int) {
    for (index, _) in chars.enumerated() {
        // Create a set of the chars in the given window, if result is of expected lenght the marker is ofund
        if Set(chars[index...index + (length - 1)]).count == length {
            print(index + length) // found marker
            break
        }
    }
}

