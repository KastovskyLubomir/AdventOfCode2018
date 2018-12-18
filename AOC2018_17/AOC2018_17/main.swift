//
//  main.swift
//  AOC2018_17
//
//  Created by Lubomír Kaštovský on 17/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

enum FieldType {
    case clay
    case sand
    case waterStream
    case waterBottom
    case spring
}

typealias StreamIds = Set<String>

struct Field {
    var type: FieldType
    var streamIds: StreamIds
}

struct Position : Hashable {
    var x: Int
    var y: Int
    var hashValue: Int
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.hashValue = y*10000 + x
    }
}

typealias Matrix = Array<Array<Field>>
typealias Positions = Set<Position>

struct Grid {
    var maxX: Int
    var maxY: Int
    var minX: Int
    var minY: Int
    var matrix: Matrix
}

let lines = readLinesRemoveEmpty(str: inputString)

func printGrid(grid: Grid, leftTop: Position?, rightBottom: Position?) {
    let maxX: Int
    let minX: Int
    let maxY: Int
    let minY: Int
    if let lt = leftTop, let rb = rightBottom {
        minX = lt.x
        minY = lt.y
        maxX = rb.x
        maxY = rb.y
    } else {
        minX = grid.minX
        minY = grid.minY
        maxX = grid.maxX
        maxY = grid.maxY
    }
    
    print("minX:", minX, "maxX:", maxX, "minY:", minY, "maxY:", maxY)
    var sss = " "
    for i in 0..<maxX-minX {
        sss += String(i%10)
    }
    print(sss)
    for y in 0...maxY+1 {
        var str = String(y%10)
        for x in minX...maxX+1 {
            if grid.matrix[y][x].type == .clay {
                str += "#"
            }
            if grid.matrix[y][x].type == .sand {
                str += "."
            }
            if grid.matrix[y][x].type == .spring {
                str += "+"
            }
            if grid.matrix[y][x].type == .waterBottom {
                str += "="
            }
            if grid.matrix[y][x].type == .waterStream {
                str += "o"
            }
        }
        print(str)
    }
}

func loadGrid(lines: Array<String>) -> (Grid, Positions) {
    var grid = Grid(maxX: Int.min, maxY: Int.min, minX: Int.max, minY: Int.max, matrix: Matrix())
    var positions = Positions()
    for line in lines {
        let args = line.components(separatedBy: ["=", " ", ",", "."])
        if args[0] == "x" {
            let x = Int(args[1])!
            let y1 = Int(args[4])!
            let y2 = Int(args[6])!
            for y in y1...y2 {
                positions.insert(Position(x: x, y: y))
                if x < grid.minX {
                    grid.minX = x
                }
                if x > grid.maxX {
                    grid.maxX = x
                }
                if y < grid.minY {
                    grid.minY = y
                }
                if y > grid.maxY {
                    grid.maxY = y
                }
            }
        } else if args[0] == "y" {
            let y = Int(args[1])!
            let x1 = Int(args[4])!
            let x2 = Int(args[6])!
            for x in x1...x2 {
                positions.insert(Position(x: x, y: y))
                if x < grid.minX {
                    grid.minX = x
                }
                if x > grid.maxX {
                    grid.maxX = x
                }
                if y < grid.minY {
                    grid.minY = y
                }
                if y > grid.maxY {
                    grid.maxY = y
                }
            }
        }
    }
    
    for y in 0..<grid.maxY+5 {
        grid.matrix.append([Field].init(repeating: Field(type: .sand, streamIds: StreamIds()), count: grid.maxX+5))
        for x in 0..<grid.maxX+5 {
            if positions.contains(Position(x: x, y: y)) {
                grid.matrix[y][x] = Field(type: .clay, streamIds: StreamIds())
            }
        }
    }
    
    grid.matrix[0][500] = Field(type: .spring, streamIds: StreamIds())
    //grid.matrix[0][9] = Field(type: .spring, streamIds: StreamIds())
    
    return (grid, positions)
}

func canFlowDown(streamId: String, position: Position, grid: Grid) -> Bool {
    guard (position.y < grid.maxY) else { return false }
    let field = grid.matrix[position.y + 1][position.x]
    if field.type == .sand || field.type == .waterStream {
        return true
    }
    return false
}

func didHitWaterStream(position: Position, grid: Grid) -> Bool {
    return (grid.matrix[position.y+1][position.x].type == .waterStream)
}

func canFlowLeft(streamId: String, position: Position, grid: Grid) -> Bool {
    let field = grid.matrix[position.y][position.x - 1]
    if field.type == .sand || field.type == .waterStream {
        return true
    }
    return false
}

func canFlowRight(streamId: String, position: Position, grid: Grid) -> Bool {
    let field = grid.matrix[position.y][position.x + 1]
    if field.type == .sand || field.type == .waterStream {
        return true
    }
    return false
}

func streamFlow(streamId: String, start: Position, grid: inout Grid) -> Int {
    var waterCount = 0
    var position = start
    var finished = false
    var foundLeftDown = false
    var foundRightDown = false
    var leftDownPos = position
    var rightDownPos = position
    
    //print("position: ", start)
    //printGrid(grid: grid, leftTop: nil, rightBottom: nil)
    
    while !finished {
        
        while canFlowDown(streamId: streamId, position: position, grid: grid) {
            position = Position(x: position.x, y: position.y+1)
            grid.matrix[position.y][position.x].type = .waterStream
            waterCount += 1
            
            //print("position: ", start)
            //printGrid(grid: grid, leftTop: nil, rightBottom: nil)
        }
        
        if (position.y == grid.maxY) || didHitWaterStream(position: position, grid: grid) {
            return waterCount
        }
        
        let hitBottom = position
        foundLeftDown = false
        var mostLeftPos = position
        while canFlowLeft(streamId: streamId, position: position, grid: grid) && !foundLeftDown {
            position = Position(x: position.x-1, y: position.y)
            mostLeftPos = position
            grid.matrix[position.y][position.x].type = .waterStream
            waterCount += 1
            
            //print("position: ", start)
            //printGrid(grid: grid, leftTop: nil, rightBottom: nil)
            
            if canFlowDown(streamId: streamId, position: position, grid: grid) {
                foundLeftDown = true
                leftDownPos = position
                waterCount += streamFlow(streamId: streamId, start: leftDownPos, grid: &grid)
            }
        }
        
        position = hitBottom
        foundRightDown = false
        var mostRightPos = position
        while canFlowRight(streamId: streamId, position: position, grid: grid) && !foundRightDown {
            position = Position(x: position.x+1, y: position.y)
            mostRightPos = position
            grid.matrix[position.y][position.x].type = .waterStream
            waterCount += 1
            
            //print("position: ", start)
            //printGrid(grid: grid, leftTop: nil, rightBottom: nil)
            
            if canFlowDown(streamId: streamId, position: position, grid: grid) {
                foundRightDown = true
                rightDownPos = position
                waterCount += streamFlow(streamId: streamId, start: rightDownPos, grid: &grid)
            }
        }
        
        if foundLeftDown {
            //waterCount += streamFlow(streamId: streamId, start: leftDownPos, grid: &grid)
        }
        
        if foundRightDown {
            //waterCount += streamFlow(streamId: streamId, start: rightDownPos, grid: &grid)
        }
        
        // identify top layer and bottom layer
        if ((!foundLeftDown) && (!foundRightDown)) {
            position = Position(x: hitBottom.x, y: hitBottom.y - 1)
            for x in mostLeftPos.x...mostRightPos.x {
                grid.matrix[mostLeftPos.y][x].type = .waterBottom
                //printGrid(grid: grid, leftTop: nil, rightBottom: nil)
            }
        } else {
            for x in mostLeftPos.x...mostRightPos.x {
                grid.matrix[mostLeftPos.y][x].type = .waterStream
                //printGrid(grid: grid, leftTop: nil, rightBottom: nil)
            }
            finished = true
        }
    }
    return waterCount
}

let res = loadGrid(lines: lines)
var grid = res.0
var positions = res.1

print(streamFlow(streamId: "S", start: Position(x: 500, y: 0), grid: &grid))
printGrid(grid: grid, leftTop: nil, rightBottom: nil)

var count = 0
for y in grid.minY...grid.maxY {
    for x in 0..<grid.matrix[y].count {
        if grid.matrix[y][x].type == .waterStream || grid.matrix[y][x].type == .waterBottom {
            count += 1
        }
    }
}
print(count)

func retainedWater(grdi: Grid) -> Int {
    var sum = 0
    var y = grid.minY
    while y <= grid.maxY {
        var x = 0
        while x <= grid.maxX {
            if grid.matrix[y][x].type == .waterStream || grid.matrix[y][x].type == .waterBottom {
                // find left border
                var foundBottomWater = false
                var l = x
                while l >= 0 {
                    if grid.matrix[y][l].type == .waterStream || grid.matrix[y][l].type == .waterBottom {
                        if grid.matrix[y][l].type == .waterBottom {
                            foundBottomWater = true
                        }
                        l -= 1
                    } else {
                        break
                    }
                }
                var r = x
                while r <= grid.maxX {
                    if grid.matrix[y][r].type == .waterStream || grid.matrix[y][r].type == .waterBottom {
                        if grid.matrix[y][r].type == .waterBottom {
                            foundBottomWater = true
                        }
                        r += 1
                    } else {
                        break
                    }
                }
                
                if ((grid.matrix[y][l].type == .clay) && (grid.matrix[y][r].type == .clay)) && foundBottomWater {
                    sum += r - (l+1)
                }
                
                x = r
            } else {
                x += 1
            }
        }
        y += 1
    }
    return sum
}
//print(streamFlow(streamId: "S", start: Position(x: 9, y: 0), grid: &grid))

print(retainedWater(grdi: grid))


