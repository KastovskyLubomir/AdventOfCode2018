//
//  main.swift
//  AOC2018_20
//
//  Created by Lubomír Kaštovský on 20/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

/*
 
 --- Day 20: A Regular Map ---
 
 While you were learning about instruction pointers, the Elves made considerable progress. When you look up, you discover that the North Pole base construction project has completely surrounded you.
 
 The area you are in is made up entirely of rooms and doors. The rooms are arranged in a grid, and rooms only connect to adjacent rooms when a door is present between them.
 
 For example, drawing rooms as ., walls as #, doors as | or -, your current position as X, and where north is up, the area you're in might look like this:
 
 #####
 #.|.#
 #-###
 #.|X#
 #####
 You get the attention of a passing construction Elf and ask for a map. "I don't have time to draw out a map of this place - it's huge. Instead, I can give you directions to every room in the facility!" He writes down some directions on a piece of parchment and runs off. In the example above, the instructions might have been ^WNE$, a regular expression or "regex" (your puzzle input).
 
 The regex matches routes (like WNE for "west, north, east") that will take you from your current room through various doors in the facility. In aggregate, the routes will take you through every door in the facility at least once; mapping out all of these routes will let you build a proper map and find your way around.
 
 ^ and $ are at the beginning and end of your regex; these just mean that the regex doesn't match anything outside the routes it describes. (Specifically, ^ matches the start of the route, and $ matches the end of it.) These characters will not appear elsewhere in the regex.
 
 The rest of the regex matches various sequences of the characters N (north), S (south), E (east), and W (west). In the example above, ^WNE$ matches only one route, WNE, which means you can move west, then north, then east from your current position. Sequences of letters like this always match that exact route in the same order.
 
 Sometimes, the route can branch. A branch is given by a list of options separated by pipes (|) and wrapped in parentheses. So, ^N(E|W)N$ contains a branch: after going north, you must choose to go either east or west before finishing your route by going north again. By tracing out the possible routes after branching, you can determine where the doors are and, therefore, where the rooms are in the facility.
 
 For example, consider this regex: ^ENWWW(NEEE|SSE(EE|N))$
 
 This regex begins with ENWWW, which means that from your current position, all routes must begin by moving east, north, and then west three times, in that order. After this, there is a branch. Before you consider the branch, this is what you know about the map so far, with doors you aren't sure about marked with a ?:
 
 #?#?#?#?#
 ?.|.|.|.?
 #?#?#?#-#
 ?X|.?
 #?#?#
 After this point, there is (NEEE|SSE(EE|N)). This gives you exactly two options: NEEE and SSE(EE|N). By following NEEE, the map now looks like this:
 
 #?#?#?#?#
 ?.|.|.|.?
 #-#?#?#?#
 ?.|.|.|.?
 #?#?#?#-#
 ?X|.?
 #?#?#
 Now, only SSE(EE|N) remains. Because it is in the same parenthesized group as NEEE, it starts from the same room NEEE started in. It states that starting from that point, there exist doors which will allow you to move south twice, then east; this ends up at another branch. After that, you can either move east twice or north once. This information fills in the rest of the doors:
 
 #?#?#?#?#
 ?.|.|.|.?
 #-#?#?#?#
 ?.|.|.|.?
 #-#?#?#-#
 ?.?.?X|.?
 #-#-#?#?#
 ?.|.|.|.?
 #?#?#?#?#
 Once you've followed all possible routes, you know the remaining unknown parts are all walls, producing a finished map of the facility:
 
 #########
 #.|.|.|.#
 #-#######
 #.|.|.|.#
 #-#####-#
 #.#.#X|.#
 #-#-#####
 #.|.|.|.#
 #########
 Sometimes, a list of options can have an empty option, like (NEWS|WNSE|). This means that routes at this point could effectively skip the options in parentheses and move on immediately. For example, consider this regex and the corresponding map:
 
 ^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$
 
 ###########
 #.|.#.|.#.#
 #-###-#-#-#
 #.|.|.#.#.#
 #-#####-#-#
 #.#.#X|.#.#
 #-#-#####-#
 #.#.|.|.|.#
 #-###-###-#
 #.|.|.#.|.#
 ###########
 This regex has one main route which, at three locations, can optionally include additional detours and be valid: (NEWS|), (WNSE|), and (SWEN|). Regardless of which option is taken, the route continues from the position it is left at after taking those steps. So, for example, this regex matches all of the following routes (and more that aren't listed here):
 
 ENNWSWWSSSEENEENNN
 ENNWSWWNEWSSSSEENEENNN
 ENNWSWWNEWSSSSEENEESWENNNN
 ENNWSWWSSSEENWNSEEENNN
 By following the various routes the regex matches, a full map of all of the doors and rooms in the facility can be assembled.
 
 To get a sense for the size of this facility, you'd like to determine which room is furthest from you: specifically, you would like to find the room for which the shortest path to that room would require passing through the most doors.
 
 In the first example (^WNE$), this would be the north-east corner 3 doors away.
 In the second example (^ENWWW(NEEE|SSE(EE|N))$), this would be the south-east corner 10 doors away.
 In the third example (^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$), this would be the north-east corner 18 doors away.
 Here are a few more examples:
 
 Regex: ^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$
 Furthest room requires passing 23 doors
 
 #############
 #.|.|.|.|.|.#
 #-#####-###-#
 #.#.|.#.#.#.#
 #-#-###-#-#-#
 #.#.#.|.#.|.#
 #-#-#-#####-#
 #.#.#.#X|.#.#
 #-#-#-###-#-#
 #.|.#.|.#.#.#
 ###-#-###-#-#
 #.|.#.|.|.#.#
 #############
 Regex: ^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$
 Furthest room requires passing 31 doors
 
 ###############
 #.|.|.|.#.|.|.#
 #-###-###-#-#-#
 #.|.#.|.|.#.#.#
 #-#########-#-#
 #.#.|.|.|.|.#.#
 #-#-#########-#
 #.#.#.|X#.|.#.#
 ###-#-###-#-#-#
 #.|.#.#.|.#.|.#
 #-###-#####-###
 #.|.#.|.|.#.#.#
 #-#-#####-#-#-#
 #.#.|.|.|.#.|.#
 ###############
 What is the largest number of doors you would be required to pass through to reach a room? That is, find the room for which the shortest path from your starting location to that room would require passing through the most doors; what is the fewest doors you can pass through to reach it?
 
 Your puzzle answer was 4050.
 
 --- Part Two ---
 
 Okay, so the facility is big.
 
 How many rooms have a shortest path from your current location that pass through at least 1000 doors?
 
 Your puzzle answer was 8564.
 
 */

import Foundation

func generateRooms(start: Int, input: Array<Character>, skipEmptyOptions: Bool) -> Dictionary<String, Int> {
    let directions: Set = [Character("E"), Character("N"), Character("W"), Character("S")]
    var result = [String:Int]()
    let positionStack = LinkedList<String>()
    let lengthStack = LinkedList<Int>()
    var i = start
    let e = 1
    let n = -1
    let w = -1
    let s = 1
    var x = 0
    var y = 0
    var length = 0
    while (i < input.count) && (input[i] != Character("$")) {
        if input[i] == Character("(") {
            positionStack.insertFirst(value: String(x) + "," + String(y))
            lengthStack.insertFirst(value: length)
        } else if input[i] == Character("|") {
            let pos = positionStack.first!.value!.components(separatedBy: [","])
            x = Int(pos[0])!
            y = Int(pos[1])!
            length = lengthStack.first!.value!
        } else if input[i] == Character(")") {
            positionStack.removeFirst()
            lengthStack.removeFirst()
        } else if directions.contains(input[i]) {
            length += 1
            switch input[i] {
                case Character("E"): x += e
                case Character("W"): x += w
                case Character("N"): y += n
                case Character("S"): y += s
                default: break
            }
            let sss = String(x) + "," + String(y)
            if let pathLength = result[sss] {
                if length < pathLength {
                    result[sss] = length
                }
            } else {
                result[sss] = length
            }
        }
        i += 1
    }
    
    return result
}

func longestPath(paths: Dictionary<String, Int>) -> Int {
    var result = 0
    for key in paths.keys {
        if result < paths[key]! {
            result = paths[key]!
        }
    }
    return result
}
/*
 let test = "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$"
 let test2 = "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$"
 let test3 = "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$"
 */

let input = Array(inputString.filter { $0 != Character("\n") })
let result = generateRooms(start: 0, input: input, skipEmptyOptions: false)
print("1. result: ", longestPath(paths: result))

print("2. result: ", result.compactMap { key, value in return value }.filter { $0 >= 1000 }.count)
