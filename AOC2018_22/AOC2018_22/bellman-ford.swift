//
//  bellman-ford.swift
//  AOC2018_22
//
//  Created by Lubomír Kaštovský on 24/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

func evalNeighbors2(position: Position,
                    allPositions: inout Array<Array<Position>>,
                    sizeX: Int,
                    sizeY: Int,
                    map: inout ErosionLevelMap) {
    var newX = 0
    var newY = 0
    
    for i in 0..<4 {
        switch i {
        case 0:
            if position.x > 0 {
                newX = position.x - 1
                newY = position.y
            } else {
                continue
            }
        case 1:
            if position.y > 0 {
                newX = position.x
                newY = position.y - 1
            } else {
                continue
            }
        case 2:
            if (position.x + 1) < sizeX {
                newX = position.x + 1
                newY = position.y
            } else {
                continue
            }
        case 3:
            if (position.y + 1) < sizeY {
                newX = position.x
                newY = position.y + 1
            } else {
                continue
            }
        default: continue
        }
        /*
        let newPosition = evaluatePosition(actualPosition: position, x: newX, y: newY, map: &map)
        if newPosition.spentTime < allPositions[newY][newX].spentTime {
            allPositions[newY][newX] = newPosition
        }
 */
    }
}

func generateAllPositions2(sizeX: Int, sizeY: Int) -> Array<Array<Position>> {
    var result = Array<Array<Position>>()
    for y in 0..<sizeY {
        result.append([])
        for x in 0..<sizeX {
            result[y].append(Position(x: x, y: y, gear: .none, spentTime: Int.max))
        }
    }
    return result
}

func bellmanFordFastestPath(targetX: Int, targetY: Int, depth: Int) -> Int {
    let sizeX = targetX + 10
    let sizeY = targetY + 10
    var map = constructMap(mouthX: 0, mouthY: 0, targetX: targetX, targetY: targetY, sizeX: sizeX, sizeY: sizeY, depth: depth)
    
    var allPositions = generateAllPositions2(sizeX: sizeX, sizeY: sizeY)
    
    allPositions[0][0] = Position(x: 0, y: 0, gear: .torch, spentTime: 0)
    //allPositions[0][1] = evaluatePosition(actualPosition: allPositions[0][0], x: 1, y: 0, map: &map)
    //allPositions[1][0] = evaluatePosition(actualPosition: allPositions[0][0], x: 0, y: 1, map: &map)
    
    var counter = 0
    while counter < (allPositions.count*allPositions[0].count) {
        for y in 0..<sizeY {
            for x in 0..<sizeX {
                evalNeighbors2(position: allPositions[y][x], allPositions: &allPositions, sizeX: sizeX, sizeY: sizeY, map: &map)
            }
        }
        counter += 1
        //print(allPositions[targetY][targetX])
        var str = "     "
        for x in 0..<sizeX {
            str += String(format: "%4d ", x)
        }
        print(str)
        for y in 0..<sizeY {
            str = String(format: "%4d ", y)
            for x in 0..<sizeX {
                let gear = gearToString(gear: allPositions[y][x].gear)
                str += String(format: "%3d", allPositions[y][x].spentTime) + String(Array(gear)[0]) + " "
            }
            print(str)
        }
        print("----------------")
    }
    
    return allPositions[targetY][targetX].spentTime + (allPositions[targetY][targetX].gear == .climb ? 7 : 0)
}
