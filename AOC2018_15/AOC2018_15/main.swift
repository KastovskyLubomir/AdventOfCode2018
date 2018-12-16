//
//  main.swift
//  AOC2018_15
//
//  Created by Lubomír Kaštovský on 15/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 
 --- Day 15: Beverage Bandits ---
 
 Having perfected their hot chocolate, the Elves have a new problem: the Goblins that live in these caves will do anything to steal it. Looks like they're here for a fight.
 
 You scan the area, generating a map of the walls (#), open cavern (.), and starting position of every Goblin (G) and Elf (E) (your puzzle input).
 
 Combat proceeds in rounds; in each round, each unit that is still alive takes a turn, resolving all of its actions before the next unit's turn begins. On each unit's turn, it tries to move into range of an enemy (if it isn't already) and then attack (if it is in range).
 
 All units are very disciplined and always follow very strict combat rules. Units never move or attack diagonally, as doing so would be dishonorable. When multiple choices are equally valid, ties are broken in reading order: top-to-bottom, then left-to-right. For instance, the order in which units take their turns within a round is the reading order of their starting positions in that round, regardless of the type of unit or whether other units have moved after the round started. For example:
 
 would take their
 These units:   turns in this order:
 #######           #######
 #.G.E.#           #.1.2.#
 #E.G.E#           #3.4.5#
 #.G.E.#           #.6.7.#
 #######           #######
 Each unit begins its turn by identifying all possible targets (enemy units). If no targets remain, combat ends.
 
 Then, the unit identifies all of the open squares (.) that are in range of each target; these are the squares which are adjacent (immediately up, down, left, or right) to any target and which aren't already occupied by a wall or another unit. Alternatively, the unit might already be in range of a target. If the unit is not already in range of a target, and there are no open squares which are in range of a target, the unit ends its turn.
 
 If the unit is already in range of a target, it does not move, but continues its turn with an attack. Otherwise, since it is not in range of a target, it moves.
 
 To move, the unit first considers the squares that are in range and determines which of those squares it could reach in the fewest steps. A step is a single movement to any adjacent (immediately up, down, left, or right) open (.) square. Units cannot move into walls or other units. The unit does this while considering the current positions of units and does not do any prediction about where units will be later. If the unit cannot reach (find an open path to) any of the squares that are in range, it ends its turn. If multiple squares are in range and tied for being reachable in the fewest steps, the square which is first in reading order is chosen. For example:
 
 Targets:      In range:     Reachable:    Nearest:      Chosen:
 #######       #######       #######       #######       #######
 #E..G.#       #E.?G?#       #E.@G.#       #E.!G.#       #E.+G.#
 #...#.#  -->  #.?.#?#  -->  #.@.#.#  -->  #.!.#.#  -->  #...#.#
 #.G.#G#       #?G?#G#       #@G@#G#       #!G.#G#       #.G.#G#
 #######       #######       #######       #######       #######
 In the above scenario, the Elf has three targets (the three Goblins):
 
 Each of the Goblins has open, adjacent squares which are in range (marked with a ? on the map).
 Of those squares, four are reachable (marked @); the other two (on the right) would require moving through a wall or unit to reach.
 Three of these reachable squares are nearest, requiring the fewest steps (only 2) to reach (marked !).
 Of those, the square which is first in reading order is chosen (+).
 The unit then takes a single step toward the chosen square along the shortest path to that square. If multiple steps would put the unit equally closer to its destination, the unit chooses the step which is first in reading order. (This requires knowing when there is more than one shortest path so that you can consider the first step of each such path.) For example:
 
 In range:     Nearest:      Chosen:       Distance:     Step:
 #######       #######       #######       #######       #######
 #.E...#       #.E...#       #.E...#       #4E212#       #..E..#
 #...?.#  -->  #...!.#  -->  #...+.#  -->  #32101#  -->  #.....#
 #..?G?#       #..!G.#       #...G.#       #432G2#       #...G.#
 #######       #######       #######       #######       #######
 The Elf sees three squares in range of a target (?), two of which are nearest (!), and so the first in reading order is chosen (+). Under "Distance", each open square is marked with its distance from the destination square; the two squares to which the Elf could move on this turn (down and to the right) are both equally good moves and would leave the Elf 2 steps from being in range of the Goblin. Because the step which is first in reading order is chosen, the Elf moves right one square.
 
 Here's a larger example of movement:
 
 Initially:
 #########
 #G..G..G#
 #.......#
 #.......#
 #G..E..G#
 #.......#
 #.......#
 #G..G..G#
 #########
 
 After 1 round:
 #########
 #.G...G.#
 #...G...#
 #...E..G#
 #.G.....#
 #.......#
 #G..G..G#
 #.......#
 #########
 
 After 2 rounds:
 #########
 #..G.G..#
 #...G...#
 #.G.E.G.#
 #.......#
 #G..G..G#
 #.......#
 #.......#
 #########
 
 After 3 rounds:
 #########
 #.......#
 #..GGG..#
 #..GEG..#
 #G..G...#
 #......G#
 #.......#
 #.......#
 #########
 Once the Goblins and Elf reach the positions above, they all are either in range of a target or cannot find any square in range of a target, and so none of the units can move until a unit dies.
 
 After moving (or if the unit began its turn in range of a target), the unit attacks.
 
 To attack, the unit first determines all of the targets that are in range of it by being immediately adjacent to it. If there are no such targets, the unit ends its turn. Otherwise, the adjacent target with the fewest hit points is selected; in a tie, the adjacent target with the fewest hit points which is first in reading order is selected.
 
 The unit deals damage equal to its attack power to the selected target, reducing its hit points by that amount. If this reduces its hit points to 0 or fewer, the selected target dies: its square becomes . and it takes no further turns.
 
 Each unit, either Goblin or Elf, has 3 attack power and starts with 200 hit points.
 
 For example, suppose the only Elf is about to attack:
 
 HP:            HP:
 G....  9       G....  9
 ..G..  4       ..G..  4
 ..EG.  2  -->  ..E..
 ..G..  2       ..G..  2
 ...G.  1       ...G.  1
 The "HP" column shows the hit points of the Goblin to the left in the corresponding row. The Elf is in range of three targets: the Goblin above it (with 4 hit points), the Goblin to its right (with 2 hit points), and the Goblin below it (also with 2 hit points). Because three targets are in range, the ones with the lowest hit points are selected: the two Goblins with 2 hit points each (one to the right of the Elf and one below the Elf). Of those, the Goblin first in reading order (the one to the right of the Elf) is selected. The selected Goblin's hit points (2) are reduced by the Elf's attack power (3), reducing its hit points to -1, killing it.
 
 After attacking, the unit's turn ends. Regardless of how the unit's turn ends, the next unit in the round takes its turn. If all units have taken turns in this round, the round ends, and a new round begins.
 
 The Elves look quite outnumbered. You need to determine the outcome of the battle: the number of full rounds that were completed (not counting the round in which combat ends) multiplied by the sum of the hit points of all remaining units at the moment combat ends. (Combat only ends when a unit finds no targets during its turn.)
 
 Below is an entire sample combat. Next to each map, each row's units' hit points are listed from left to right.
 
 Initially:
 #######
 #.G...#   G(200)
 #...EG#   E(200), G(200)
 #.#.#G#   G(200)
 #..G#E#   G(200), E(200)
 #.....#
 #######
 
 After 1 round:
 #######
 #..G..#   G(200)
 #...EG#   E(197), G(197)
 #.#G#G#   G(200), G(197)
 #...#E#   E(197)
 #.....#
 #######
 
 After 2 rounds:
 #######
 #...G.#   G(200)
 #..GEG#   G(200), E(188), G(194)
 #.#.#G#   G(194)
 #...#E#   E(194)
 #.....#
 #######
 
 Combat ensues; eventually, the top Elf dies:
 
 After 23 rounds:
 #######
 #...G.#   G(200)
 #..G.G#   G(200), G(131)
 #.#.#G#   G(131)
 #...#E#   E(131)
 #.....#
 #######
 
 After 24 rounds:
 #######
 #..G..#   G(200)
 #...G.#   G(131)
 #.#G#G#   G(200), G(128)
 #...#E#   E(128)
 #.....#
 #######
 
 After 25 rounds:
 #######
 #.G...#   G(200)
 #..G..#   G(131)
 #.#.#G#   G(125)
 #..G#E#   G(200), E(125)
 #.....#
 #######
 
 After 26 rounds:
 #######
 #G....#   G(200)
 #.G...#   G(131)
 #.#.#G#   G(122)
 #...#E#   E(122)
 #..G..#   G(200)
 #######
 
 After 27 rounds:
 #######
 #G....#   G(200)
 #.G...#   G(131)
 #.#.#G#   G(119)
 #...#E#   E(119)
 #...G.#   G(200)
 #######
 
 After 28 rounds:
 #######
 #G....#   G(200)
 #.G...#   G(131)
 #.#.#G#   G(116)
 #...#E#   E(113)
 #....G#   G(200)
 #######
 
 More combat ensues; eventually, the bottom Elf dies:
 
 After 47 rounds:
 #######
 #G....#   G(200)
 #.G...#   G(131)
 #.#.#G#   G(59)
 #...#.#
 #....G#   G(200)
 #######
 Before the 48th round can finish, the top-left Goblin finds that there are no targets remaining, and so combat ends. So, the number of full rounds that were completed is 47, and the sum of the hit points of all remaining units is 200+131+59+200 = 590. From these, the outcome of the battle is 47 * 590 = 27730.
 
 Here are a few example summarized combats:
 
 #######       #######
 #G..#E#       #...#E#   E(200)
 #E#E.E#       #E#...#   E(197)
 #G.##.#  -->  #.E##.#   E(185)
 #...#E#       #E..#E#   E(200), E(200)
 #...E.#       #.....#
 #######       #######
 
 Combat ends after 37 full rounds
 Elves win with 982 total hit points left
 Outcome: 37 * 982 = 36334
 #######       #######
 #E..EG#       #.E.E.#   E(164), E(197)
 #.#G.E#       #.#E..#   E(200)
 #E.##E#  -->  #E.##.#   E(98)
 #G..#.#       #.E.#.#   E(200)
 #..E#.#       #...#.#
 #######       #######
 
 Combat ends after 46 full rounds
 Elves win with 859 total hit points left
 Outcome: 46 * 859 = 39514
 #######       #######
 #E.G#.#       #G.G#.#   G(200), G(98)
 #.#G..#       #.#G..#   G(200)
 #G.#.G#  -->  #..#..#
 #G..#.#       #...#G#   G(95)
 #...E.#       #...G.#   G(200)
 #######       #######
 
 Combat ends after 35 full rounds
 Goblins win with 793 total hit points left
 Outcome: 35 * 793 = 27755
 #######       #######
 #.E...#       #.....#
 #.#..G#       #.#G..#   G(200)
 #.###.#  -->  #.###.#
 #E#G#G#       #.#.#.#
 #...#G#       #G.G#G#   G(98), G(38), G(200)
 #######       #######
 
 Combat ends after 54 full rounds
 Goblins win with 536 total hit points left
 Outcome: 54 * 536 = 28944
 #########       #########
 #G......#       #.G.....#   G(137)
 #.E.#...#       #G.G#...#   G(200), G(200)
 #..##..G#       #.G##...#   G(200)
 #...##..#  -->  #...##..#
 #...#...#       #.G.#...#   G(200)
 #.G...G.#       #.......#
 #.....G.#       #.......#
 #########       #########
 
 Combat ends after 20 full rounds
 Goblins win with 937 total hit points left
 Outcome: 20 * 937 = 18740
 What is the outcome of the combat described in your puzzle input?
 
 Your puzzle answer was 264384.
 
 --- Part Two ---
 
 According to your calculations, the Elves are going to lose badly. Surely, you won't mess up the timeline too much if you give them just a little advanced technology, right?
 
 You need to make sure the Elves not only win, but also suffer no losses: even the death of a single Elf is unacceptable.
 
 However, you can't go too far: larger changes will be more likely to permanently alter spacetime.
 
 So, you need to find the outcome of the battle in which the Elves have the lowest integer attack power (at least 4) that allows them to win without a single death. The Goblins always have an attack power of 3.
 
 In the first summarized example above, the lowest attack power the Elves need to win without losses is 15:
 
 #######       #######
 #.G...#       #..E..#   E(158)
 #...EG#       #...E.#   E(14)
 #.#.#G#  -->  #.#.#.#
 #..G#E#       #...#.#
 #.....#       #.....#
 #######       #######
 
 Combat ends after 29 full rounds
 Elves win with 172 total hit points left
 Outcome: 29 * 172 = 4988
 In the second example above, the Elves need only 4 attack power:
 
 #######       #######
 #E..EG#       #.E.E.#   E(200), E(23)
 #.#G.E#       #.#E..#   E(200)
 #E.##E#  -->  #E.##E#   E(125), E(200)
 #G..#.#       #.E.#.#   E(200)
 #..E#.#       #...#.#
 #######       #######
 
 Combat ends after 33 full rounds
 Elves win with 948 total hit points left
 Outcome: 33 * 948 = 31284
 In the third example above, the Elves need 15 attack power:
 
 #######       #######
 #E.G#.#       #.E.#.#   E(8)
 #.#G..#       #.#E..#   E(86)
 #G.#.G#  -->  #..#..#
 #G..#.#       #...#.#
 #...E.#       #.....#
 #######       #######
 
 Combat ends after 37 full rounds
 Elves win with 94 total hit points left
 Outcome: 37 * 94 = 3478
 In the fourth example above, the Elves need 12 attack power:
 
 #######       #######
 #.E...#       #...E.#   E(14)
 #.#..G#       #.#..E#   E(152)
 #.###.#  -->  #.###.#
 #E#G#G#       #.#.#.#
 #...#G#       #...#.#
 #######       #######
 
 Combat ends after 39 full rounds
 Elves win with 166 total hit points left
 Outcome: 39 * 166 = 6474
 In the last example above, the lone Elf needs 34 attack power:
 
 #########       #########
 #G......#       #.......#
 #.E.#...#       #.E.#...#   E(38)
 #..##..G#       #..##...#
 #...##..#  -->  #...##..#
 #...#...#       #...#...#
 #.G...G.#       #.......#
 #.....G.#       #.......#
 #########       #########
 
 Combat ends after 30 full rounds
 Elves win with 38 total hit points left
 Outcome: 30 * 38 = 1140
 After increasing the Elves' attack power until it is just barely enough for them to win without any Elves dying, what is the outcome of the combat described in your puzzle input?
 
 Your puzzle answer was 67022.
 
 */




import Foundation

enum FieldType {
    case Goblin
    case Elf
    case Wall
    case Empty
}

struct Position : Equatable, Hashable {
    var x: Int
    var y: Int
    public var hashValue: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.hashValue = x+(y*1000)
    }
    
    public static func == (lhs: Position, rhs: Position) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
}

struct Field {
    var type: FieldType
    var hitPoints: Int
    var attack: Int
    let id: Int
}

typealias Grid = Array<Array<Field>>

typealias Path = LinkedList<Position>

let elfHitPoints = 200
let goblinHitPoints = 200

func loadGrid(lines: Array<String>) -> Grid {
    var grid = Grid()
    var x = 0
    var y = 0
    var id = 0
    for line in lines {
        let args = Array(line)
        grid.append([Field].init(repeating: Field(type: FieldType.Empty, hitPoints: 0, attack: 0, id: 0), count: args.count))
        x = 0
        for c in args {
            if c == Character("#") {
                grid[y][x] = Field(type: FieldType.Wall, hitPoints: 0, attack: 0, id: 0)
            } else if c == Character("E") {
                grid[y][x] = Field(type: FieldType.Elf, hitPoints: elfHitPoints, attack: 3, id: id)
                id += 1
            } else if c == Character("G") {
                grid[y][x] = Field(type: FieldType.Goblin, hitPoints: goblinHitPoints, attack: 3, id: id)
                id += 1
            }
            x += 1
        }
        y += 1
    }
    return grid
}

func printGrid(_ grid: Grid) {
    for row in grid {
        var line = ""
        var units = ""
        for c in row {
            if c.type == FieldType.Wall {
                line += "#"
            } else if c.type == FieldType.Empty {
                line += "."
            } else if c.type == FieldType.Elf {
                line += "E"
                units += "E[" + String(c.id) + "](" + String(c.hitPoints) + "),"
            } else if c.type == FieldType.Goblin {
                line += "G"
                units += "G[" + String(c.id) + "](" + String(c.hitPoints) + "),"
            }
        }
        print(line+"    "+units)
    }
}

func fieldReachable(possition: Position, dest: Position, grid: Grid) -> Bool {
    var set = Set<Position>()
    var newPossitions: Set<Position> = Set<Position>()
    newPossitions.insert(possition)
    var newPos: Position = Position(x: 0, y: 0)
    while !newPossitions.isEmpty {
        let pos = newPossitions.first!
        if pos == dest {
            return true
        }
        newPossitions.remove(pos)
        for i in 0..<4 {
            switch i {
            case 0:
                newPos = Position(x: pos.x, y: pos.y - 1)
            case 1:
                newPos = Position(x: pos.x - 1, y: pos.y)
            case 2:
                newPos = Position(x: pos.x + 1, y: pos.y)
            case 3:
                newPos = Position(x: pos.x, y: pos.y + 1)
            default: break
            }
            
            if (grid[newPos.y][newPos.x].type == FieldType.Empty) && (!set.contains(newPos)) {
                newPossitions.insert(newPos)
            }
        }
        
        if !set.contains(pos) {
            set.insert(pos)
        }
    }
    return false
}

func inRangeFields(grid: Grid, forType: FieldType) -> Array<Position> {
    var inRange: Set<Int> = []
    var y = 0
    var x = 0
    for row in grid {
        x = 0
        for f in row {
            if f.type == forType {
                if (grid[y-1][x].type == FieldType.Empty) {
                    inRange.insert(x + (y-1)*1000)
                }
                if (grid[y+1][x].type == FieldType.Empty) {
                    inRange.insert(x + (y+1)*1000)
                }
                if (grid[y][x-1].type == FieldType.Empty) {
                    inRange.insert((x - 1) + (y*1000))
                }
                if (grid[y][x+1].type == FieldType.Empty) {
                    inRange.insert((x + 1) + y*1000)
                }
            }
            x += 1
        }
        y += 1
    }
    return inRange.sorted().map { Position(x: $0%1000, y: $0/1000) }
}

func hasOneLongerWithEnding(pos: Position, length: Int, list: LinkedList<Path>) -> Bool {
    var i = 0
    list.actualToFirst()
    while i < list.count {
        if list.actual!.value!.count == (length+1) {
            if pos == list.actual!.value!.last!.value! {
                return true
            }
        }
        list.moveToRight(shift: 1)
        i += 1
    }
    return false
}

func findShortestPathToField(start: Position, dest: Position, grid: Grid, inRange: Array<Position>) -> Path? {
    let p: Path = Path()
    let paths: LinkedList<Path> = LinkedList<Path>()
    p.appendLast(value: Position(x: start.x, y: start.y))
    paths.appendLast(value: p)
    let newPaths: LinkedList<Path> = LinkedList<Path>()
    let result: LinkedList<Path> = LinkedList<Path>()
    var lastInsertedLength = Int.max
    var newPos: Position = Position(x: start.x, y: start.y)
    var usedPositions: Dictionary<Int, Int> = [:]
    while !(paths.count == 0) {
        let path = paths.first!.value!
        paths.removeFirst()
        let pos = path.last!.value!
        
        for i in 0..<4 {
            switch i {
            case 0:
                newPos = Position(x: pos.x, y: pos.y - 1)
            case 1:
                newPos = Position(x: pos.x - 1, y: pos.y)
            case 2:
                newPos = Position(x: pos.x + 1, y: pos.y)
            case 3:
                newPos = Position(x: pos.x, y: pos.y + 1)
            default: break
            }
            
            if grid[newPos.y][newPos.x].type == FieldType.Empty {
                if (newPos.x == dest.x) && (newPos.y == dest.y) {
                    if (path.count+1) < lastInsertedLength {
                        let pp = Path(path)
                        pp.appendLast(value: newPos)
                        result.removeAll()
                        result.appendLast(value: pp)
                        lastInsertedLength = pp.count
                    } else if (path.count+1) == lastInsertedLength {
                        let pp = Path(path)
                        pp.appendLast(value: newPos)
                        result.appendLast(value: pp)
                    }
                } else {
                    // don't use already used positions in one path
                    if !(path.contains(value: newPos) || inRange.contains(newPos)) {
                        if ((path.count+2) < lastInsertedLength) &&
                            (!hasOneLongerWithEnding(pos: newPos, length: path.count, list: paths)) {
                            // don't use positions used already in other path earlier (shorter distance from start position)
                            // this will drop the amount of tested paths drastically
                            if let len = usedPositions[newPos.hashValue] {
                                if (path.count + 1) < len {
                                    let pp = Path(path)
                                    pp.appendLast(value: newPos)
                                    paths.appendLast(value: pp)
                                }
                            } else {
                                usedPositions[newPos.hashValue] = path.count + 1
                                let pp = Path(path)
                                pp.appendLast(value: newPos)
                                paths.appendLast(value: pp)
                            }
                        }
                    }
                }
            }
        }
        paths.actualToFirst()
    }
    
    if result.count == 0 {
        return nil
    }
    if result.count == 1 {
        return result.first!.value!
    }
    
    // keep the shortest
    var len = Int.max
    var i = 0
    result.actualToFirst()
    while i < result.count {
        let path = result.actual!.value!
        if path.count < len {
            newPaths.removeAll()
            newPaths.appendLast(value: path)
            len = path.count
        } else if len == path.count {
            newPaths.appendLast(value: path)
        }
        result.moveToRight(shift: 1)
        i += 1
    }
    
    // take the one with the read order first second step of the path
    newPaths.actualToFirst()
    var resultPath: Path? = newPaths.actual!.value!
    for i in 0..<newPaths.count {
        newPaths.actualToFirst()
        newPaths.moveToRight(shift: i)
        let path1 = newPaths.actual!.value!
        path1.actualToFirst()
        path1.moveToRight(shift: 1)
        let pos1 = path1.actual!.value!
        
        resultPath!.actualToFirst()
        resultPath!.moveToRight(shift: 1)
        let pos2 = resultPath!.actual!.value!
        
        if (pos1.x + pos1.y*1000) < (pos2.x + pos2.y*1000) {
            resultPath = path1
        }
    }
    
    return resultPath
}

func stepToClosestInRange(start: Position, inRange: Array<Position>, grid: Grid) -> Position? {
    // find shortest paths to fields in range, keep only shortest
    var paths: Array<Path> = []
    var length = Int.max
    for x in inRange {
        if fieldReachable(possition: start, dest: x, grid: grid) {
            if let shortest = findShortestPathToField(start: start, dest: x, grid: grid, inRange: inRange) {
                if length > shortest.count {
                    paths.removeAll()
                    paths.append(shortest)
                    length = shortest.count
                } else if length == shortest.count {
                    paths.append(shortest)
                }
            }
        }
    }
    if paths.isEmpty {
        return nil
    }
    if paths.count == 1 {
        let path = paths.first!
        path.actualToFirst()
        path.moveToRight(shift: 1)
        return path.actual!.value!
    }
    
    // pick the path to first field (read order)
    var index = 0
    for i in 0..<paths.count {
        let path1 = paths[i]
        path1.actualToLast()
        let pos1 = path1.actual!.value!
        
        let path2 = paths[index]
        path2.actualToLast()
        let pos2 = path2.actual!.value!
        
        if (pos1.x + pos1.y*1000) < (pos2.x + pos2.y*1000) {
            index = i
        }
    }
    let path = paths[index]
    path.actualToFirst()
    path.moveToRight(shift: 1)
    return path.actual!.value!
}

func findTarget(ofType: FieldType, position: Position, grid: Grid) -> Position? {
    var targets: Array<Position> = []
    // find possible targets
    if grid[position.y - 1][position.x].type == ofType {
        targets.append(Position(x: position.x, y: position.y - 1))
    }
    if grid[position.y + 1][position.x].type == ofType {
        targets.append(Position(x: position.x, y: position.y + 1))
    }
    if grid[position.y][position.x - 1].type == ofType {
        targets.append(Position(x: position.x - 1, y: position.y))
    }
    if grid[position.y][position.x + 1].type == ofType {
        targets.append(Position(x: position.x + 1, y: position.y))
    }
    if targets.isEmpty {
        return nil
    }
    // sort in read order
    targets = targets.sorted(by: { ($0.x + $0.y*1000) < ($1.x + $1.y*1000)})
    // find index of target with lowest hp
    var lowestHP = Int.max
    var index = 0
    for i in 0..<targets.count {
        if grid[targets[i].y][targets[i].x].hitPoints < lowestHP {
            index = i
            lowestHP = grid[targets[i].y][targets[i].x].hitPoints
        }
    }
    return targets[index]
}

func hasUnit(ofType: FieldType, grid: Grid) -> Bool {
    for row in grid {
        for f in row {
            if f.type == ofType {
                return true
            }
        }
    }
    return false
}

func unitMove(position: Position, grid: inout Grid, moved: inout Set<Int>, elfAttack: Int, goblinAttack: Int) {
    let field = grid[position.y][position.x]
    if (field.type == FieldType.Elf) || (field.type == FieldType.Goblin) {
        let enemy = ((field.type == FieldType.Elf) ? FieldType.Goblin : FieldType.Elf)
        // can attack
        if let target = findTarget(ofType: enemy, position: position, grid: grid) {
            grid[target.y][target.x].hitPoints -= (field.type == FieldType.Elf) ? elfAttack : goblinAttack
            if grid[target.y][target.x].hitPoints <= 0 {
                grid[target.y][target.x] = Field(type: FieldType.Empty, hitPoints: 0, attack: 0, id: 0)
            }
        } else {
            let inRange = inRangeFields(grid: grid, forType: enemy)
            // can move
            if let step = stepToClosestInRange(start: position, inRange: inRange, grid: grid) {
                grid[position.y][position.x] = Field(type: FieldType.Empty, hitPoints: 0, attack: 0, id: 0)
                grid[step.y][step.x] = field
                if let target = findTarget(ofType: enemy, position: step, grid: grid) {
                    grid[target.y][target.x].hitPoints -= (field.type == FieldType.Elf) ? elfAttack : goblinAttack
                    if grid[target.y][target.x].hitPoints <= 0 {
                        grid[target.y][target.x] = Field(type: FieldType.Empty, hitPoints: 0, attack: 0, id: 0)
                    }
                }
            }
        }
        moved.insert(field.id)
    }
}

func combat(grid: Grid, elfAttack: Int, goblinAttack: Int) -> Int {
    var aGrid = grid
    var rounds = 0
    var moved: Set<Int> = []
    while rounds < 1000 {
        for y in 0..<aGrid.count {
            for x in 0..<aGrid[y].count {
                if (aGrid[y][x].type == FieldType.Elf) || (aGrid[y][x].type == FieldType.Goblin) {
                    let enemy = ((aGrid[y][x].type == FieldType.Elf) ? FieldType.Goblin : FieldType.Elf)
                    if !moved.contains(aGrid[y][x].id) {
                        if !hasUnit(ofType: enemy, grid: aGrid) {
                            let sum = aGrid.flatMap { $0 }.reduce(0, { result, item in
                                result + (((item.type == FieldType.Elf) || (item.type == FieldType.Goblin)) ? item.hitPoints : 0)
                            })
                            print(rounds)
                            print(sum)
                            printGrid(aGrid)
                            return rounds * sum
                        }
                        unitMove(position: Position(x: x, y: y), grid: &aGrid, moved: &moved, elfAttack: elfAttack, goblinAttack: goblinAttack)
                    }
                }
            }
        }
        moved.removeAll()
        rounds += 1
    }
    return -1
}

let inputLines = readLinesRemoveEmpty(str: inputString)
var grid = loadGrid(lines: inputLines)
printGrid(grid)

print(combat(grid: grid, elfAttack: 3, goblinAttack: 3))

func countElves(grid: Grid) -> Int {
    var count = 0
    for row in grid {
        for x in row {
            if x.type == FieldType.Elf {
                count += 1
            }
        }
    }
    return count
}

func combatSuperElves(grid: Grid, elfAttack: Int, goblinAttack: Int) -> (Int, Int) {
    var aGrid = grid
    let elvesCount = countElves(grid: aGrid)
    var betterAttack = elfAttack
    var rounds = 0
    var moved: Set<Int> = []
    print("attack: ", betterAttack)
    while rounds < 100000 {
        for y in 0..<aGrid.count {
            for x in 0..<aGrid[y].count {
                if (aGrid[y][x].type == FieldType.Elf) || (aGrid[y][x].type == FieldType.Goblin) {
                    let enemy = ((aGrid[y][x].type == FieldType.Elf) ? FieldType.Goblin : FieldType.Elf)
                    if !moved.contains(aGrid[y][x].id) {
                        if !hasUnit(ofType: enemy, grid: aGrid) {
                            let sum = aGrid.flatMap { $0 }.reduce(0, { result, item in
                                result + (((item.type == FieldType.Elf) || (item.type == FieldType.Goblin)) ? item.hitPoints : 0)
                            })
                            print(rounds)
                            print(sum)
                            print(betterAttack)
                            printGrid(aGrid)
                            return (rounds * sum, betterAttack)
                        }
                        unitMove(position: Position(x: x, y: y), grid: &aGrid, moved: &moved, elfAttack: betterAttack, goblinAttack: goblinAttack)
                    }
                }
            }
        }
        moved.removeAll()
        rounds += 1
        if countElves(grid: aGrid) != elvesCount {
            aGrid = grid
            betterAttack += 1
            rounds = 0
            print("attack: ", betterAttack)
        }
    }
    return (-1, -1)
}

print(combatSuperElves(grid: grid, elfAttack: 4, goblinAttack: 3))
