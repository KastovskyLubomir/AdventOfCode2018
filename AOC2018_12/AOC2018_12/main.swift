//
//  main.swift
//  AOC2018_12
//
//  Created by Lubomír Kaštovský on 12/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 
 --- Day 12: Subterranean Sustainability ---
 
 The year 518 is significantly more underground than your history books implied. Either that, or you've arrived in a vast cavern network under the North Pole.
 
 After exploring a little, you discover a long tunnel that contains a row of small pots as far as you can see to your left and right. A few of them contain plants - someone is trying to grow things in these geothermally-heated caves.
 
 The pots are numbered, with 0 in front of you. To the left, the pots are numbered -1, -2, -3, and so on; to the right, 1, 2, 3.... Your puzzle input contains a list of pots from 0 to the right and whether they do (#) or do not (.) currently contain a plant, the initial state. (No other pots currently contain plants.) For example, an initial state of #..##.... indicates that pots 0, 3, and 4 currently contain plants.
 
 Your puzzle input also contains some notes you find on a nearby table: someone has been trying to figure out how these plants spread to nearby pots. Based on the notes, for each generation of plants, a given pot has or does not have a plant based on whether that pot (and the two pots on either side of it) had a plant in the last generation. These are written as LLCRR => N, where L are pots to the left, C is the current pot being considered, R are the pots to the right, and N is whether the current pot will have a plant in the next generation. For example:
 
 A note like ..#.. => . means that a pot that contains a plant but with no plants within two pots of it will not have a plant in it during the next generation.
 A note like ##.## => . means that an empty pot with two plants on each side of it will remain empty in the next generation.
 A note like .##.# => # means that a pot has a plant in a given generation if, in the previous generation, there were plants in that pot, the one immediately to the left, and the one two pots to the right, but not in the ones immediately to the right and two to the left.
 It's not clear what these plants are for, but you're sure it's important, so you'd like to make sure the current configuration of plants is sustainable by determining what will happen after 20 generations.
 
 For example, given the following input:
 
 initial state: #..#.#..##......###...###
 
 ...## => #
 ..#.. => #
 .#... => #
 .#.#. => #
 .#.## => #
 .##.. => #
 .#### => #
 #.#.# => #
 #.### => #
 ##.#. => #
 ##.## => #
 ###.. => #
 ###.# => #
 ####. => #
 For brevity, in this example, only the combinations which do produce a plant are listed. (Your input includes all possible combinations.) Then, the next 20 generations will look like this:
 
 1         2         3
 0         0         0         0
 0: ...#..#.#..##......###...###...........
 1: ...#...#....#.....#..#..#..#...........
 2: ...##..##...##....#..#..#..##..........
 3: ..#.#...#..#.#....#..#..#...#..........
 4: ...#.#..#...#.#...#..#..##..##.........
 5: ....#...##...#.#..#..#...#...#.........
 6: ....##.#.#....#...#..##..##..##........
 7: ...#..###.#...##..#...#...#...#........
 8: ...#....##.#.#.#..##..##..##..##.......
 9: ...##..#..#####....#...#...#...#.......
 10: ..#.#..#...#.##....##..##..##..##......
 11: ...#...##...#.#...#.#...#...#...#......
 12: ...##.#.#....#.#...#.#..##..##..##.....
 13: ..#..###.#....#.#...#....#...#...#.....
 14: ..#....##.#....#.#..##...##..##..##....
 15: ..##..#..#.#....#....#..#.#...#...#....
 16: .#.#..#...#.#...##...#...#.#..##..##...
 17: ..#...##...#.#.#.#...##...#....#...#...
 18: ..##.#.#....#####.#.#.#...##...##..##..
 19: .#..###.#..#.#.#######.#.#.#..#.#...#..
 20: .#....##....#####...#######....#.#..##.
 The generation is shown along the left, where 0 is the initial state. The pot numbers are shown along the top, where 0 labels the center pot, negative-numbered pots extend to the left, and positive pots extend toward the right. Remember, the initial state begins at pot 0, which is not the leftmost pot used in this example.
 
 After one generation, only seven plants remain. The one in pot 0 matched the rule looking for ..#.., the one in pot 4 matched the rule looking for .#.#., pot 9 matched .##.., and so on.
 
 In this example, after 20 generations, the pots shown as # contain plants, the furthest left of which is pot -2, and the furthest right of which is pot 34. Adding up all the numbers of plant-containing pots after the 20th generation produces 325.
 
 After 20 generations, what is the sum of the numbers of all pots which contain a plant?
 
 Your puzzle answer was 3337.
 
 --- Part Two ---
 
 You realize that 20 generations aren't enough. After all, these plants will need to last another 1500 years to even reach your timeline, not to mention your future.
 
 After fifty billion (50000000000) generations, what is the sum of the numbers of all pots which contain a plant?
 
 Your puzzle answer was 4300000000349.
 
 */

import Foundation

let tunnelOffset = 5

struct Pot {
    var plant: Int
    var value: Int
}

typealias Tunnel = LinkedList<Pot>
typealias Rules = Dictionary<Int, Int>

func tunnelToString(tunnel: Tunnel) -> String {
    var str = ""
    tunnel.actualToFirst()
    var i = 0
    while i < tunnel.count {
        str += tunnel.actual!.value!.plant == 1 ? "#" : "."
        tunnel.moveToRight(shift: 1)
        i += 1
    }
    return str
}

func printTunnel(tunnel: Tunnel) {
    print(tunnelToString(tunnel: tunnel))
}

func setupInitialStateToTunnel(initialState: String, tunnel: inout Tunnel) {
    let args = initialState.components(separatedBy: [" "])
    let pots = Array(args[2])
    var value = -tunnelOffset
    for _ in 0..<tunnelOffset {
        tunnel.appendLast(value: Pot(plant: 0, value: value))
        value += 1
    }
    for x in pots {
        if x == Character("#") {
            tunnel.appendLast(value: Pot(plant: 1, value: value))
        } else {
            tunnel.appendLast(value: Pot(plant: 0, value: value))
        }
        value += 1
    }
    for _ in 0..<tunnelOffset {
        tunnel.appendLast(value: Pot(plant: 0, value: value))
        value += 1
    }
}

func setupRules(rules: Array<String>) -> Rules {
    var result = [Int:Int]()
    for rule in rules {
        let args = rule.components(separatedBy: [" "])
        var multiplier = 10000
        var key = 0
        for aa in Array(args[0]) {
            if aa == Character("#") {
                key += multiplier
            }
            multiplier /= 10
        }
        if args[2] == "#" {
            result[key] = 1
        } else {
            result[key] = 0
        }
    }
    return result
}

func modifyLeft(tunnel: inout Tunnel) {
    tunnel.actualToFirst()
    var i = 0
    while tunnel.actual!.value!.plant != 1 {
        i += 1
        tunnel.moveToRight(shift: 1)
    }
    if i > tunnelOffset {
        for _ in 0..<i-tunnelOffset {
            tunnel.removeFirst()
        }
    } else if i < tunnelOffset {
        tunnel.actualToFirst()
        for _ in 0..<tunnelOffset-i {
            tunnel.insertFirst(value: Pot(plant: 0, value: tunnel.first!.value!.value-1))
        }
    }
}

func modifyRight(tunnel: inout Tunnel) {
    tunnel.actualToLast()
    var i = 0
    while tunnel.actual!.value!.plant != 1 {
        i += 1
        tunnel.moveToLeft(shift: 1)
    }
    if i > tunnelOffset {
        for _ in 0..<i-tunnelOffset {
            tunnel.removeLast()
        }
    } else if i < tunnelOffset {
        tunnel.actualToLast()
        for _ in 0..<tunnelOffset-i {
            tunnel.appendLast(value: Pot(plant: 0, value: tunnel.last!.value!.value+1))
        }
    }
}

func newGeneration(tunnel: Tunnel, rules: Rules) -> Tunnel {
    var resultTunnel = Tunnel()
    tunnel.actualToFirst()
    tunnel.moveToRight(shift: 2)
    var i = 2
    while i < tunnel.count-2 {
        let key = tunnel.actual!.left!.left!.value!.plant * 10000 +
                    tunnel.actual!.left!.value!.plant * 1000 +
                    tunnel.actual!.value!.plant * 100 +
                    tunnel.actual!.right!.value!.plant * 10 +
                    tunnel.actual!.right!.right!.value!.plant
        if let newPlant = rules[key] {
            if newPlant == 1 {
                resultTunnel.appendLast(value: Pot(plant: 1, value: tunnel.actual!.value!.value))
            } else {
                resultTunnel.appendLast(value: Pot(plant: 0, value: tunnel.actual!.value!.value))
            }
        } else {
            resultTunnel.appendLast(value: Pot(plant: 0, value: tunnel.actual!.value!.value))
        }
        i += 1
        tunnel.moveToRight(shift: 1)
    }
    modifyLeft(tunnel: &resultTunnel)
    modifyRight(tunnel: &resultTunnel)
    return resultTunnel
}

func generate(tunnel: Tunnel, rules: Rules) -> Tunnel {
    var tt = tunnel
    for _ in 0..<20 {
        tt = newGeneration(tunnel: tt, rules: rules)
    }
    return tt
}

func sumValues(tunnel: Tunnel) -> Int {
    tunnel.actualToFirst()
    var i = 0
    var sum = 0
    while i < tunnel.count {
        sum += tunnel.actual!.value!.plant == 1 ? tunnel.actual!.value!.value : 0
        tunnel.moveToRight(shift: 1)
        i += 1
    }
    return sum
}

// get 1. occurence, sum of 1. occurence, 2. occurence, sum of 2. occurence
func searchForCycle(tunnel: Tunnel, rules: Rules) -> (Int, Int, Int, Int) {
    var dict = [String:(Int, Int)]()
    var tt = tunnel
    var found = false
    var counter = 0
    while !found && counter < 1000000 {
        let key = tunnelToString(tunnel: tt)
        let sum = sumValues(tunnel: tt)
        if let foundTunnel = dict[key] {
            found = true
            return (foundTunnel.0, foundTunnel.1, counter, sum)
        } else {
            dict[key] = (counter, sum)
        }
        counter += 1
        tt = newGeneration(tunnel: tt, rules: rules)
    }
    return (0,0,0,0)
}

let input = readLinesRemoveEmpty(str: inputString)
let initialTunnel = input[0]
let inputRules = input.filter { !$0.contains("initial") }

var tunnel = Tunnel()
setupInitialStateToTunnel(initialState: initialTunnel, tunnel: &tunnel)
let rules = setupRules(rules: inputRules)
let resT = generate(tunnel: tunnel, rules: rules)
print("1. result: ", sumValues(tunnel: resT))

let searchResult = searchForCycle(tunnel: tunnel, rules: rules)
let result = (50000000000 - searchResult.2) * (searchResult.3 - searchResult.1) + searchResult.3
print("2. result: ", result)
