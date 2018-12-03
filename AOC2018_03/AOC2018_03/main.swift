//
//  main.swift
//  AOC2018_03
//
//  Created by Lubomír Kaštovský on 03/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

// #1 @ 1,3: 4x4
func idWithCoordinates(square: String) -> (id: Int, coords: [Int]) {
    var id = 0
    var co = [Int]()
    let args = square.components(separatedBy: ["#", "@", ",", ":", "x", " "]).compactMap { Int($0)}
    id = args[0]
    for row in 0..<args[4] {
        for col in 0..<args[3] {
            co.insert(((row+args[2])*1000) + (col+args[1]), at:co.endIndex)
        }
    }
    return (id, co)
}


var idSet : Set<Int> = [] // for solution 2
var space : [Int: Set<Int>] = [:]
for line in readLinesRemoveEmpty(str: inputString) {
    let res = idWithCoordinates(square: line)
    idSet.insert(res.id)
    for x in res.coords {
        if space[x] == nil {
            space[x] = [res.id]
        } else {
            space[x]?.insert(res.id)
        }
    }
}

var count = 0
for key in space.keys {
    count += space[key]!.count > 1 ? 1 : 0
}

print("1. result: ", count)

// remove overlaping
for key in space.keys {
    if space[key]!.count > 1 {
        idSet = idSet.subtracting(space[key]!)
    }
}

print("2. result: ", idSet)
