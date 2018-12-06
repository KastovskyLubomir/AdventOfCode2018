
/*
 
 --- Day 6: Chronal Coordinates ---
 
 The device on your wrist beeps several times, and once again you feel like you're falling.
 
 "Situation critical," the device announces. "Destination indeterminate. Chronal interference detected. Please specify new target coordinates."
 
 The device then produces a list of coordinates (your puzzle input). Are they places it thinks are safe or dangerous? It recommends you check manual page 729. The Elves did not give you a manual.
 
 If they're dangerous, maybe you can minimize the danger by finding the coordinate that gives the largest distance from the other points.
 
 Using only the Manhattan distance, determine the area around each coordinate by counting the number of integer X,Y locations that are closest to that coordinate (and aren't tied in distance to any other coordinate).
 
 Your goal is to find the size of the largest area that isn't infinite. For example, consider the following list of coordinates:
 
 1, 1
 1, 6
 8, 3
 3, 4
 5, 5
 8, 9
 If we name these coordinates A through F, we can draw them on a grid, putting 0,0 at the top left:
 
 ..........
 .A........
 ..........
 ........C.
 ...D......
 .....E....
 .B........
 ..........
 ..........
 ........F.
 This view is partial - the actual grid extends infinitely in all directions. Using the Manhattan distance, each location's closest coordinate can be determined, shown here in lowercase:
 
 aaaaa.cccc
 aAaaa.cccc
 aaaddecccc
 aadddeccCc
 ..dDdeeccc
 bb.deEeecc
 bBb.eeee..
 bbb.eeefff
 bbb.eeffff
 bbb.ffffFf
 Locations shown as . are equally far from two or more coordinates, and so they don't count as being closest to any.
 
 In this example, the areas of coordinates A, B, C, and F are infinite - while not shown here, their areas extend forever outside the visible grid. However, the areas of coordinates D and E are finite: D is closest to 9 locations, and E is closest to 17 (both including the coordinate's location itself). Therefore, in this example, the size of the largest area is 17.
 
 What is the size of the largest area that isn't infinite?
 
 Your puzzle answer was 3420.
 
 --- Part Two ---
 
 On the other hand, if the coordinates are safe, maybe the best you can do is try to find a region near as many coordinates as possible.
 
 For example, suppose you want the sum of the Manhattan distance to all of the coordinates to be less than 32. For each location, add up the distances to all of the given coordinates; if the total of those distances is less than 32, that location is within the desired region. Using the same coordinates as above, the resulting region looks like this:
 
 ..........
 .A........
 ..........
 ...###..C.
 ..#D###...
 ..###E#...
 .B.###....
 ..........
 ..........
 ........F.
 In particular, consider the highlighted location 4,3 located at the top middle of the region. Its calculation is as follows, where abs() is the absolute value function:
 
 Distance to coordinate A: abs(4-1) + abs(3-1) =  5
 Distance to coordinate B: abs(4-1) + abs(3-6) =  6
 Distance to coordinate C: abs(4-8) + abs(3-3) =  4
 Distance to coordinate D: abs(4-3) + abs(3-4) =  2
 Distance to coordinate E: abs(4-5) + abs(3-5) =  3
 Distance to coordinate F: abs(4-8) + abs(3-9) = 10
 Total distance: 5 + 6 + 4 + 2 + 3 + 10 = 30
 Because the total distance to all coordinates (30) is less than 32, the location is within the region.
 
 This region, which also includes coordinates D and E, has a total size of 16.
 
 Your actual region will need to be much larger than this example, though, instead including all locations with a total distance of less than 10000.
 
 What is the size of the region containing all locations which have a total distance to all given coordinates of less than 10000?
 
 Your puzzle answer was 46667.
 
 */

let inputArray = readLinesRemoveEmpty(str: inputString).map { line -> (String, Int, Int) in
    let args = line.components(separatedBy: [",", " "]).compactMap { Int($0) }
    return (String(args[0]) + String(args[1]), args[0], args[1])
}

typealias Coordinate = (String, Int, Int)

let maxX = inputArray.reduce(0) { result, coords in
    return coords.1 > result ? coords.1 : result
}

let maxY = inputArray.reduce(0) { result, coords in
    return coords.2 > result ? coords.2 : result
}

typealias Grid = Array<Array<(Int, Set<String>)>>

var grid: Grid = Grid()

func shortestManhattanDistance(posX: Int, posY: Int, coordinates: Array<Coordinate>) -> (Int, Set<String>) {
    var shortest = Int.max
    var sameDistance: Set<String> = Set()
    for coord in coordinates {
        let distance = abs(posX - coord.1) + abs(posY - coord.2)
        if distance < shortest {
            shortest = distance
            sameDistance.removeAll()
            sameDistance.insert(coord.0)
        }
        if distance == shortest {
            sameDistance.insert(coord.0)
        }
    }
    return (shortest, sameDistance)
}

func fillGrid(grid: inout Grid, maxX: Int, maxY: Int, coordinates: Array<Coordinate>) {
    
    for y in 0...maxY {
        var row = [(Int, Set<String>)]()
        for x in 0...maxX {
            let shortest = shortestManhattanDistance(posX: x, posY: y, coordinates: coordinates)
            row.append(shortest)
        }
        grid.append(row)
    }
}

fillGrid(grid: &grid, maxX: maxX, maxY: maxY, coordinates: inputArray)

func isOnEdge(coordinate: Coordinate, grid: Grid) -> Bool {
    
    for x in 0...maxX {
        if grid[0][x].1.contains(coordinate.0) && (grid[0][x].1.count == 1) {
            return true
        }
        if grid[maxY][x].1.contains(coordinate.0) && (grid[maxY][x].1.count == 1){
            return true
        }
    }
    
    for y in 0...maxY {
        if grid[y][0].1.contains(coordinate.0) && (grid[y][0].1.count == 1) {
            return true
        }
        if grid[y][maxX].1.contains(coordinate.0) && (grid[y][maxX].1.count == 1) {
            return true
        }
    }
    
    return false
}

func findFiniteCoordinates(grid: Grid, coordinates: Array<Coordinate>) -> Array<Coordinate> {
    var result = [Coordinate]()
    for coord in coordinates {
        if !isOnEdge(coordinate: coord, grid: grid) {
            result.append(coord)
        }
    }
    return result
}

let finiteCoordinates = findFiniteCoordinates(grid: grid, coordinates: inputArray)

func finiteOccurence(grid: Grid, coordinate: Coordinate) -> Int {
    var result = 0
    for y in 0...maxY {
        for x in 0...maxX {
            if grid[y][x].1.contains(coordinate.0) && (grid[y][x].1.count == 1) {
                result += 1
            }
        }
    }
    return result
}

func biggestOccurence(grid: Grid, coordinates: Array<Coordinate>) -> Int {
    var result = 0
    for coord in coordinates {
        let occurence = finiteOccurence(grid: grid, coordinate: coord)
        if occurence > result {
            result = occurence
        }
    }
    return result
}

print("1. result: ", biggestOccurence(grid: grid, coordinates: finiteCoordinates))

func sumAllDistances(x: Int, y: Int, coordinates: Array<Coordinate>) -> Int {
    var sum = 0
    for cc in coordinates {
        sum += abs(x - cc.1) + abs(y - cc.2)
    }
    return sum
}

func safeAreaSize(centerX: Int, centerY: Int, maxDistance: Int, coordinates: Array<Coordinate>) -> Int {
    var area: Set<String> = []
    var addition = 0
    var hit = true
    while hit {
        hit = false
        let topY = centerY - addition
        let bottomY = centerY + addition
        for x in centerX-addition...centerX+addition {
            if sumAllDistances(x: x, y: topY, coordinates: coordinates) < maxDistance {
                area.insert(String(x)+String(topY))
                hit = true
            }
            if sumAllDistances(x: x, y: bottomY, coordinates: coordinates) < maxDistance {
                area.insert(String(x)+String(bottomY))
                hit = true
            }
        }
        let leftX = centerX - addition
        let rightX = centerX + addition
        for y in centerY-addition...centerY+addition {
            if sumAllDistances(x: leftX, y: y, coordinates: coordinates) < maxDistance {
                area.insert(String(leftX)+String(y))
                hit = true
            }
            if sumAllDistances(x: rightX, y: y, coordinates: coordinates) < maxDistance {
                area.insert(String(rightX)+String(y))
                hit = true
            }
        }
        addition += 1
    }
    return area.count
}

let maxDistance = 10000
let centerX: Int = maxX / 2
let centerY: Int = maxY / 2

print("2. result: ", safeAreaSize(centerX: centerX, centerY: centerY, maxDistance: maxDistance, coordinates: inputArray))
