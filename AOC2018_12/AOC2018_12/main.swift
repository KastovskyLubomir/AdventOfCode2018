//
//  main.swift
//  AOC2018_12
//
//  Created by Lubomír Kaštovský on 12/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let input = readLinesRemoveEmpty(str: inputString)

let initialTunnel = input[0]
let inputRules = input.filter { !$0.contains("initial") }

//print(initialTunnel)
//print(inputRules)

struct Pot {
    var plant: Int
    var value: Int
}

let tunnelOffset = 5

typealias Tunnel = LinkedList<Pot>

var tunnel = Tunnel()

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

setupInitialStateToTunnel(initialState: initialTunnel, tunnel: &tunnel)

//printTunnel(tunnel: tunnel)

typealias Rules = Dictionary<Int, Int>

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

let rules = setupRules(rules: inputRules)

//print(rules)

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

let resT = generate(tunnel: tunnel, rules: rules)
print("1. result: ", sumValues(tunnel: resT))

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
        //printTunnel(tunnel: tt)
    }
    return (0,0,0,0)
}

let searchResult = searchForCycle(tunnel: tunnel, rules: rules)

let result = (50000000000 - searchResult.2) * (searchResult.3 - searchResult.1) + searchResult.3
print("2. result: ", result)
