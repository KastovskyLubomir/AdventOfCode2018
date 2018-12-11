
/*
 
 --- Day 10: The Stars Align ---
 
 It's no use; your navigation system simply isn't capable of providing walking directions in the arctic circle, and certainly not in 1018.
 
 The Elves suggest an alternative. In times like these, North Pole rescue operations will arrange points of light in the sky to guide missing Elves back to base. Unfortunately, the message is easy to miss: the points move slowly enough that it takes hours to align them, but have so much momentum that they only stay aligned for a second. If you blink at the wrong time, it might be hours before another message appears.
 
 You can see these points of light floating in the distance, and record their position in the sky and their velocity, the relative change in position per second (your puzzle input). The coordinates are all given from your perspective; given enough time, those positions and velocities will move the points into a cohesive message!
 
 Rather than wait, you decide to fast-forward the process and calculate what the points will eventually spell.
 
 For example, suppose you note the following points:
 
 position=< 9,  1> velocity=< 0,  2>
 position=< 7,  0> velocity=<-1,  0>
 position=< 3, -2> velocity=<-1,  1>
 position=< 6, 10> velocity=<-2, -1>
 position=< 2, -4> velocity=< 2,  2>
 position=<-6, 10> velocity=< 2, -2>
 position=< 1,  8> velocity=< 1, -1>
 position=< 1,  7> velocity=< 1,  0>
 position=<-3, 11> velocity=< 1, -2>
 position=< 7,  6> velocity=<-1, -1>
 position=<-2,  3> velocity=< 1,  0>
 position=<-4,  3> velocity=< 2,  0>
 position=<10, -3> velocity=<-1,  1>
 position=< 5, 11> velocity=< 1, -2>
 position=< 4,  7> velocity=< 0, -1>
 position=< 8, -2> velocity=< 0,  1>
 position=<15,  0> velocity=<-2,  0>
 position=< 1,  6> velocity=< 1,  0>
 position=< 8,  9> velocity=< 0, -1>
 position=< 3,  3> velocity=<-1,  1>
 position=< 0,  5> velocity=< 0, -1>
 position=<-2,  2> velocity=< 2,  0>
 position=< 5, -2> velocity=< 1,  2>
 position=< 1,  4> velocity=< 2,  1>
 position=<-2,  7> velocity=< 2, -2>
 position=< 3,  6> velocity=<-1, -1>
 position=< 5,  0> velocity=< 1,  0>
 position=<-6,  0> velocity=< 2,  0>
 position=< 5,  9> velocity=< 1, -2>
 position=<14,  7> velocity=<-2,  0>
 position=<-3,  6> velocity=< 2, -1>
 Each line represents one point. Positions are given as <X, Y> pairs: X represents how far left (negative) or right (positive) the point appears, while Y represents how far up (negative) or down (positive) the point appears.
 
 At 0 seconds, each point has the position given. Each second, each point's velocity is added to its position. So, a point with velocity <1, -2> is moving to the right, but is moving upward twice as quickly. If this point's initial position were <3, 9>, after 3 seconds, its position would become <6, 3>.
 
 Over time, the points listed above would move like this:
 
 Initially:
 ........#.............
 ................#.....
 .........#.#..#.......
 ......................
 #..........#.#.......#
 ...............#......
 ....#.................
 ..#.#....#............
 .......#..............
 ......#...............
 ...#...#.#...#........
 ....#..#..#.........#.
 .......#..............
 ...........#..#.......
 #...........#.........
 ...#.......#..........
 
 After 1 second:
 ......................
 ......................
 ..........#....#......
 ........#.....#.......
 ..#.........#......#..
 ......................
 ......#...............
 ....##.........#......
 ......#.#.............
 .....##.##..#.........
 ........#.#...........
 ........#...#.....#...
 ..#...........#.......
 ....#.....#.#.........
 ......................
 ......................
 
 After 2 seconds:
 ......................
 ......................
 ......................
 ..............#.......
 ....#..#...####..#....
 ......................
 ........#....#........
 ......#.#.............
 .......#...#..........
 .......#..#..#.#......
 ....#....#.#..........
 .....#...#...##.#.....
 ........#.............
 ......................
 ......................
 ......................
 
 After 3 seconds:
 ......................
 ......................
 ......................
 ......................
 ......#...#..###......
 ......#...#...#.......
 ......#...#...#.......
 ......#####...#.......
 ......#...#...#.......
 ......#...#...#.......
 ......#...#...#.......
 ......#...#..###......
 ......................
 ......................
 ......................
 ......................
 
 After 4 seconds:
 ......................
 ......................
 ......................
 ............#.........
 ........##...#.#......
 ......#.....#..#......
 .....#..##.##.#.......
 .......##.#....#......
 ...........#....#.....
 ..............#.......
 ....#......#...#......
 .....#.....##.........
 ...............#......
 ...............#......
 ......................
 ......................
 After 3 seconds, the message appeared briefly: HI. Of course, your message will be much longer and will take many more seconds to appear.
 
 What message will eventually appear in the sky?
 
 Your puzzle answer was CZKPNARN.
 
 --- Part Two ---
 
 Good thing you didn't have to wait, because that would have taken a long time - much longer than the 3 seconds in the example above.
 
 Impressed by your sub-hour communication capabilities, the Elves are curious: exactly how many seconds would they have needed to wait for that message to appear?
 
 Your puzzle answer was 10003.
 
 */

import Foundation

let lines = readLinesRemoveEmpty(str: inputString)

struct Star {
    var posX: Int
    var posY: Int
    let velX: Int
    let velY: Int
}

typealias Sky = Array<Star>

func parseInput(lines: Array<String>) -> Sky {
    var result = [Star]()
    for line in lines {
        let args = line.components(separatedBy: ["<", ",", ">", " "]).compactMap { Int($0) }
        result.append(Star(posX: args[0], posY: args[1], velX: args[2], velY: args[3]))
    }
    return result
}

let sky = parseInput(lines: lines)

func moveStars(sky: inout Sky) {
    for i in 0..<sky.count {
        sky[i].posX += sky[i].velX
        sky[i].posY += sky[i].velY
    }
}

func isInSky(posX: Int, posY: Int, sky: Sky) -> Bool {
    return !sky.filter { ($0.posX == posX) && ($0.posY == posY)}.isEmpty
}

typealias MessageRectangle = (leftTopX: Int, leftTopY: Int, rightBottomX: Int, rightBottomY: Int)

func rectangle(sky: Sky) -> MessageRectangle {
    var leftTopX = Int.max
    var rightBottomX = Int.min
    var leftTopY = Int.max
    var rightBottomY = Int.min
    for star in sky {
        if (star.posX < leftTopX) {
            leftTopX = star.posX
        }
        if (star.posX > rightBottomX) {
            rightBottomX = star.posX
        }
        if (star.posY < leftTopY) {
            leftTopY = star.posY
        }
        if (star.posY > rightBottomY) {
            rightBottomY = star.posY
        }
    }
    return MessageRectangle(leftTopX, leftTopY, rightBottomX, rightBottomY)
}

let repeating = 100000
let noChangeCycles = 1000

func findMessage(sky: Sky) -> (Sky, Int) {
    var resultingSky = Sky()
    var newSky = sky
    var rectSize = Int.max
    var noChangeCount = 0
    var seconds = 0
    var timeFound = 0
    for i in 0...repeating {
        let rect = rectangle(sky: newSky)
        let size = abs(rect.leftTopX - rect.rightBottomX) * abs(rect.leftTopY - rect.rightBottomY)
        if size < rectSize {
            rectSize = size
            resultingSky = newSky
            noChangeCount = 0
            timeFound = seconds
        } else {
            noChangeCount += 1
        }
        moveStars(sky: &newSky)
        /*
        if (i % (repeating/10)) == 0 {
            print(i/(repeating/100),"%")
        }
        */
        if noChangeCount > noChangeCycles {
            break
        }
        seconds += 1
    }
    return (resultingSky, timeFound)
}

func printMessage(sky: Sky) {
    var leftTopX = Int.max
    var rightBottomX = Int.min
    var leftTopY = Int.max
    var rightBottomY = Int.min
    for star in sky {
        if (star.posX < leftTopX) {
            leftTopX = star.posX
        }
        if (star.posX > rightBottomX) {
            rightBottomX = star.posX
        }
        if (star.posY < leftTopY) {
            leftTopY = star.posY
        }
        if (star.posY > rightBottomY) {
            rightBottomY = star.posY
        }
    }
    for y in leftTopY...rightBottomY {
        var row = ""
        for x in leftTopX...rightBottomX {
            if isInSky(posX: x, posY: y, sky: sky) {
                row += "#"
            } else {
                row += "."
            }
        }
        print(row)
    }
}

let messageSky = findMessage(sky: sky)
var backSky = messageSky.0

print("1. result: ")
printMessage(sky: backSky)
print("2. result: ", messageSky.1)
