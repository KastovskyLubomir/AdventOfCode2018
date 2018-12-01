
import Foundation

let lines = readLinesRemoveEmpty(str: inputString)
//let lines = ["7", "7", "-2", "-7", "-4"]

var sum = 0
for strNum in lines {
    sum += Int(strNum)!
}

print("1. result: ",sum)

func strArrayToIntArray(str: Array<String>) -> Array<Int> {
    var result : Array<Int> = []
    for s in str {
        result.insert(Int(s)!, at: result.endIndex)
    }
    return result
}

let inputInt = strArrayToIntArray(str: lines)

var finished = false
var setX : Set<Int> = []
var freq = 0
while !finished {
    for x in inputInt {
        if setX.contains(freq) {
            print("2. result: ", freq)
            finished = true
            break
        }
        setX.insert(freq)
        freq += x
    }
}


