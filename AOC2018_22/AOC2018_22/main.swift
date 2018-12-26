//
//  main.swift
//  AOC2018_22
//
//  Created by Lubomír Kaštovský on 22/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let depth = 6969
let targetX =  9
let targetY = 796

func riskLevel(mouthX: Int, mouthY: Int, targetX: Int, targetY: Int, depth: Int) -> Int {
    var riskSum = 0
    
    let multiX = 16807
    let multiY = 48271
    let modulo = 20183
  
    var map = Array<Array<Int>>()
    
    for y in mouthY..<targetY+1 {
        map.append([Int].init(repeating: 0, count: targetX+1))
        for x in mouthX..<targetX+1 {
            let geoIndex: Int
            if ((x == 0) && (y == 0)) || ((x == targetX) && (y == targetY)) {
                geoIndex = 0
            } else if y == 0 {
                geoIndex = x*multiX
            } else if x == 0 {
                geoIndex = y*multiY
            } else {
                geoIndex = map[y][x-1] * map[y-1][x]
            }
            let erosionLevel = (geoIndex + depth) % modulo
            map[y][x] = erosionLevel
            let type = erosionLevel % 3
            // risk of field == field type
            riskSum += type
        }
    }
    
    return riskSum
}

func erosionToType(erosionLevel: Int) -> FieldType {
    let level = erosionLevel % 3
    switch level {
    case 0: return .rocky
    case 1: return .wet
    default: return .narrow
    }
}

func gearToString(gear: Gear) -> String {
    switch gear {
    case .climb : return "climb"
    case .torch: return "torch"
    case .none: return "none"
    }
}

func constructMap(mouthX: Int, mouthY: Int, targetX: Int, targetY: Int, sizeX: Int, sizeY: Int, depth: Int) -> ErosionLevelMap {
    let multiX = 16807
    let multiY = 48271
    let modulo = 20183
    var map = ErosionLevelMap()
    for y in mouthY..<sizeY+1 {
        map.append([Int].init(repeating: 0, count: sizeX+1))
        for x in mouthX..<sizeX+1 {
            let geoIndex: Int
            if ((x == 0) && (y == 0)) || ((x == targetX) && (y == targetY)) {
                geoIndex = 0
            } else if y == 0 {
                geoIndex = x*multiX
            } else if x == 0 {
                geoIndex = y*multiY
            } else {
                geoIndex = map[y][x-1] * map[y-1][x]
            }
            let erosionLevel = (geoIndex + depth) % modulo
            map[y][x] = erosionLevel
        }
    }
    return map
}

print("1. result: ", riskLevel(mouthX: 0, mouthY: 0, targetX: targetX, targetY: targetY, depth: depth))

let start = DispatchTime.now() // <<<<<<<<<< Start time

//print(dijkstraFastestPath(targetX: 10, targetY: 10, depth: 510))
print("2.result: ", dijkstraFastestPath(targetX: targetX, targetY: targetY, depth: depth))

let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
print("\nTime to evaluate problem : \(timeInterval) seconds")
