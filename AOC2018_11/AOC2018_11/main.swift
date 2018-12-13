//
//  main.swift
//  AOC2018_11
//
//  Created by Lubomír Kaštovský on 11/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

// input: 4172

import Foundation

typealias Grid = Array<Array<Int>>

func constructGrid(height: Int, width: Int, serialNumber: Int) -> Grid {
    var grid = Grid()
    for i in 0..<height {
        grid.append([Int].init(repeating: 0, count: width))
    }
    
    for y in 0..<height {
        for x in 0..<width {
            let aa = (((x + 1 + 10) * (y + 1)) + serialNumber) * (x + 1 + 10)
            grid[y][x] = ((aa % 1000) / 100) - 5
        }
    }
    
    return grid
}

// test
//print(constructGrid(height: 300, width: 300, serialNumber: 57)[78][121])
//print(constructGrid(height: 300, width: 300, serialNumber: 39)[195][216])
//print(constructGrid(height: 300, width: 300, serialNumber: 71)[152][100])

let grid = constructGrid(height: 300, width: 300, serialNumber: 4172)

func squareSum(x: Int, y: Int, squareSide: Int, grid: Grid) ->  Int {
    var sum = 0
    for i in y..<y+squareSide {
        for j in x..<x+squareSide {
            sum += grid[i][j]
        }
    }
    return sum
}

func highestSumSquare(grid: Grid, squareSide: Int) -> (Int, Int, Int) {
    var highestX = 0
    var highestY = 0
    var highestSum = 0
    for y in 0...grid.count-squareSide {
        for x in 0...grid[y].count-squareSide {
            let sum = squareSum(x: x, y: y, squareSide: squareSide, grid: grid)
            //print(sum)
            if sum > highestSum {
                highestX = x
                highestY = y
                highestSum = sum
            }
        }
    }
    return (highestX+1, highestY+1, highestSum)
}

let g2 = constructGrid(height: 300, width: 300, serialNumber: 18)
print(highestSumSquare(grid: g2, squareSide: 3))

print(highestSumSquare(grid: grid, squareSide: 3))

func highestSumSquareSize(grid: Grid) -> (Int, Int, Int) {
    var maxSize = 0
    var x = 0
    var y = 0
    var side = 0
    for squareSide in 1...grid.count {
        let size = highestSumSquare(grid: grid, squareSide: squareSide)
        if size.2 > maxSize {
            maxSize = size.2
            x = size.0
            y = size.1
            side = squareSide
        }
    }
    return (x,y,side)
}

//print(highestSumSquareSize(grid: g2))
//print(highestSumSquareSize(grid: grid))

/***************************************************/

func rectangleSum(x: Int, y: Int, sideX: Int, sideY: Int, grid: Grid) ->  Int {
    var sum = 0
    for i in y..<y+sideY {
        for j in x..<x+sideX {
            //print(x, y, j, i)
            sum += grid[i][j]
        }
    }
    return sum
}

func summedAreaTable(grid: Grid) -> Grid {
    var res = Grid()
    for y in 0..<grid.count {
        res.append([Int].init(repeating: 0, count: grid[y].count))
        for x in 0..<grid[y].count {
            let sum = rectangleSum(x: 0, y: 0, sideX: x+1, sideY: y+1, grid: grid)
            res[y][x] = sum
        }
    }
    return res
}

func squareSumAreaTable(x: Int, y: Int, side: Int, grid: Grid) -> Int {
    return grid[y][x] + grid[y+side-1][x+side-1] - grid[y+side-1][x] - grid[y][x+side-1]
}

func highestSumSquareAreaTable(grid: Grid, squareSide: Int) -> (Int, Int, Int) {
    var highestX = 0
    var highestY = 0
    var highestSum = 0
    for y in 0...grid.count-squareSide {
        for x in 0...grid[y].count-squareSide {
            //print(x,y,squareSide)
            let sum = squareSumAreaTable(x: x, y: y, side: squareSide, grid: grid)
            if sum > highestSum {
                highestX = x
                highestY = y
                highestSum = sum
            }
        }
    }
    return (highestX+1, highestY+1, highestSum)
}

func highestSumSquareSizeAreaTable(grid: Grid) -> (Int, Int, Int) {
    var maxSize = 0
    var x = 0
    var y = 0
    var side = 0
    for squareSide in 1...grid.count {
        let size = highestSumSquareAreaTable(grid: grid, squareSide: squareSide)
        if size.2 > maxSize {
            maxSize = size.2
            x = size.0
            y = size.1
            side = squareSide
        }
    }
    return (x,y,side)
}

let areaTable = summedAreaTable(grid: grid)

print(highestSumSquareSizeAreaTable(grid: areaTable))
