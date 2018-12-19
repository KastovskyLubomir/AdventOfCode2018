//
//  main.swift
//  AOC2018_18
//
//  Created by Lubomír Kaštovský on 18/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

enum Field {
    case trees      // "|"
    case open       // "."
    case lumber     // "#"
}

typealias Area = Array<Array<Field>>

typealias FieldTypeSum = (open: Int, trees: Int, lumber: Int)

func loadArea(lines: Array<String>) -> Area {
    var area = Area()
    var y = 0
    for line in lines {
        area.append([Field].init(repeating: .open, count: line.count))
        var x = 0
        for c in line {
            if c == Character("|") {
                area[y][x] = .trees
            }
            if c == Character("#") {
                area[y][x] = .lumber
            }
            x += 1
        }
        y += 1
    }
    return area
}

func areaToString(area: Area) -> String {
    var str = ""
    for row in area {
        for f in row {
            if f == .lumber {
                str += "#"
            }
            if f == .trees {
                str += "|"
            }
            if f == .open {
                str += "."
            }
        }
        str += "\n"
    }
    return str
}

func printArea(area: Area) {
    print(areaToString(area: area))
}

func fieldTypeCount(x: Int, y: Int, area: inout Area) -> FieldTypeSum {
    switch area[y][x] {
    case .open: return FieldTypeSum(1,0,0)
    case .trees: return FieldTypeSum(0,1,0)
    case .lumber: return FieldTypeSum(0,0,1)
    }
}

func neighbours(x: Int, y: Int, area: inout Area) -> FieldTypeSum {
    var open = 0
    var trees = 0
    var lumber = 0
    var xx = 0
    var yy = 0
    var res = FieldTypeSum(0,0,0)
    for i in 0..<8 {
        switch i {
        case 0: xx = x - 1; yy = y - 1
        if (xx >= 0) && (yy >= 0) {
            res = fieldTypeCount(x: xx, y: yy, area: &area)
            }
        case 1: xx = x; yy = y - 1
        if (yy >= 0) {
            res = fieldTypeCount(x: xx, y: yy, area: &area)
            }
        case 2: xx = x + 1; yy = y - 1
        if (xx < area[0].count) && (yy >= 0) {
            res = fieldTypeCount(x: xx, y: yy, area: &area)
            }
        case 3: xx = x - 1; yy = y
        if (xx >= 0) {
            res = fieldTypeCount(x: xx, y: yy, area: &area)
            }
        case 4: xx = x + 1; yy = y
        if (xx < area[0].count) {
            res = fieldTypeCount(x: xx, y: yy, area: &area)
            }
        case 5: xx = x - 1; yy = y + 1
        if (xx >= 0) && (yy < area.count) {
            res = fieldTypeCount(x: xx, y: yy, area: &area)
            }
        case 6: xx = x; yy = y + 1
        if (yy < area.count) {
            res = fieldTypeCount(x: xx, y: yy, area: &area)
            }
        case 7: xx = x + 1; yy = y + 1
        if (xx < area[0].count) && (yy < area.count) {
            res = fieldTypeCount(x: xx, y: yy, area: &area)
            }
        default: break
        }
        open += res.open
        lumber += res.lumber
        trees += res.trees
        res = (0,0,0)
    }
    return FieldTypeSum(open, trees, lumber)
}


func newGeneration(oldArea: inout Area, newArea: inout Area) {
    for y in 0..<oldArea.count {
        for x in 0..<oldArea[y].count {
            let res = neighbours(x: x, y: y, area: &oldArea)
            let field = oldArea[y][x]
            if (field == .open) && (res.trees >= 3){
                newArea[y][x] = .trees
            }
            if (field == .trees) && (res.lumber >= 3){
                newArea[y][x] = .lumber
            }
            if (field == .lumber) {
                if (res.trees >= 1) && (res.lumber >= 1) {
                    newArea[y][x] = .lumber
                } else {
                    newArea[y][x] = .open
                }
            }
        }
    }
}

func simulate(area: Area, minutes: Int) -> Int {
    var area0 = area
    var areaResult = area
    for i in 0..<minutes {
        newGeneration(oldArea: &area0, newArea: &areaResult)
        //print("----------")
        //printArea(area: areaResult)
        area0 = areaResult
    }
    //print("----------")
    //printArea(area: areaResult)
    let trees = areaResult.flatMap { $0 }.filter { $0 == .trees }.count
    let lumber = areaResult.flatMap { $0 }.filter { $0 == .lumber }.count
    
    return lumber * trees
}

func simulateAges(area: Area, minutes: Int) -> Int {
    var area0 = area
    var areaResult = area
    var stored = [String:Int]()
    for i in 0..<minutes {
        newGeneration(oldArea: &area0, newArea: &areaResult)
        area0 = areaResult
        let key = areaToString(area: areaResult)
        if let firstOccurence = stored[key] {
            let cyclesStart = minutes - firstOccurence
            let index = cyclesStart % ((i+1) - firstOccurence)
            if let result = stored.first(where: { key, value in value == (index + firstOccurence) }) {
                let trees = result.key.compactMap { $0 }.filter { $0 == Character("|") }.count
                let lumber = result.key.compactMap { $0 }.filter { $0 == Character("#") }.count
                return trees*lumber
            }
            return 0
        } else {
            stored[key] = i+1
        }
    }
    return -1
}

let lines = readLinesRemoveEmpty(str: inputString)
let area = loadArea(lines: lines)
printArea(area: area)

print(simulate(area: area, minutes: 10))

let agesResult = simulateAges(area: area, minutes: 1000000000)
print(agesResult)

