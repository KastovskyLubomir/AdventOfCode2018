//
//  main.swift
//  AOC2018_23
//
//  Created by Lubomír Kaštovský on 23/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation


struct NanoBot : Hashable {
    var x: Int
    var y: Int
    var z: Int
    var r: Int
}


func parseInput(lines: Array<String>) -> Array<NanoBot>{
    var result = Array<NanoBot>()
    for line in lines {
        let args = line.components(separatedBy: [" ", "=", "<", ",", ">"])
        result.append(NanoBot(x: Int(args[2])!, y: Int(args[3])!, z: Int(args[4])!, r: Int(args[8])!))
    }
    return result
}

func howManyInStrongestRadius(bots: Array<NanoBot>) -> Int {
    var strongest = NanoBot(x: 0, y: 0, z: 0, r: 0)
    for bot in bots {
        if bot.r > strongest.r {
            strongest = bot
        }
    }
    var count = 0
    for bot in bots {
        // distance from strongest
        let dist = abs(bot.x - strongest.x) + abs(bot.y - strongest.y) + abs(bot.z - strongest.z)
        if dist <= strongest.r {
            count += 1
        }
    }
    return count
}

func findIntersectionBots(bot: NanoBot, bots: Array<NanoBot>) -> Array<NanoBot> {
    var result = Array<NanoBot>()
    for bb in bots {
        let dist = abs(bb.x - bot.x) + abs(bb.y - bot.y) + abs(bb.z - bot.z)
        if ((bb.r + bot.r) >= dist) {
            result.append(bb)
        }
    }
    return result
}

func intersectionWithMost(bots: Array<NanoBot>) -> Array<Array<NanoBot>> {
    var biggest = 0
    var result = Array<Array<NanoBot>>()
    for bot in bots {
        let intersections = findIntersectionBots(bot: bot, bots: bots)
        if intersections.count > biggest {
            biggest = intersections.count
            result.removeAll()
            result.append(intersections)
        } else if intersections.count == biggest {
            result.append(intersections)
        }
    }
    return result
}



let lines = readLinesRemoveEmpty(str: inputString)

let bots = parseInput(lines: lines)


for b in bots {
    
}

//print(bots)

print(howManyInStrongestRadius(bots: bots))
//print(intersectionWithMost(bots: bots))
print(bots.count)
intersectionWithMost(bots: bots).forEach({ print($0.count)})
