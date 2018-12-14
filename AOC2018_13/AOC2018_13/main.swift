//
//  main.swift
//  AOC2018_13
//
//  Created by Lubomír Kaštovský on 13/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

let lines = readLinesRemoveEmpty(str: inputString)

typealias Map = Array<Array<Character>>

enum Turn {
    case left
    case straight
    case right
}

enum Direction {
    case up
    case down
    case left
    case right
}

struct Cart {
    var x: Int
    var y: Int
    var turn: Turn
    var direction: Direction
    var crashed: Bool
}

typealias Carts = Array<Cart>

func loadMap(lines: Array<String>) -> Map {
    var map = Map()
    for line in lines {
        let fields = Array(line)
        map.append(fields)
    }
    return map
}

func findCarts(map: inout Map) -> Carts {
    var carts = Carts()
    var x = 0
    var y = 0
    for row in map {
        x = 0
        for c in row {
            if c == Character("<") {
                let cart = Cart(x: x, y: y, turn: Turn.left, direction: Direction.left, crashed: false)
                carts.append(cart)
                map[y][x] = Character("-")
            }
            if c == Character(">") {
                let cart = Cart(x: x, y: y, turn: Turn.left, direction: Direction.right, crashed: false)
                carts.append(cart)
                map[y][x] = Character("-")
            }
            if c == Character("^") {
                let cart = Cart(x: x, y: y, turn: Turn.left, direction: Direction.up, crashed: false)
                carts.append(cart)
                map[y][x] = Character("|")
            }
            if c == Character("v") {
                let cart = Cart(x: x, y: y, turn: Turn.left, direction: Direction.down, crashed: false)
                carts.append(cart)
                map[y][x] = Character("|")
            }
            x += 1
        }
        print(String(map[y]))
        y += 1
    }
    return carts
}

func sortCarts(carts: Carts) -> Carts {
    return carts.sorted(by: { a,b in
        (a.y*1000 + a.x) < (b.y*1000 + b.x)
    })
}

func moveCart(cart: Cart, map: Map) -> Cart? {
    let c = map[cart.y][cart.x]
    if c == "-" {
        if cart.direction == Direction.left {
            return Cart(x: cart.x-1, y: cart.y, turn: cart.turn, direction: cart.direction, crashed: cart.crashed)
        }
        if cart.direction == Direction.right {
            return Cart(x: cart.x+1, y: cart.y, turn: cart.turn, direction: cart.direction, crashed: cart.crashed)
        }
    }
    if c == "|" {
        if cart.direction == Direction.up {
            return Cart(x: cart.x, y: cart.y-1, turn: cart.turn, direction: cart.direction, crashed: cart.crashed)
        }
        if cart.direction == Direction.down {
            return Cart(x: cart.x, y: cart.y+1, turn: cart.turn, direction: cart.direction, crashed: cart.crashed)
        }
    }
    if c == "\\" {
        if cart.direction == Direction.up {
            return Cart(x: cart.x-1, y: cart.y, turn: cart.turn, direction: Direction.left, crashed: cart.crashed)
        }
        if cart.direction == Direction.down {
            return Cart(x: cart.x+1, y: cart.y, turn: cart.turn, direction: Direction.right, crashed: cart.crashed)
        }
        if cart.direction == Direction.left {
            return Cart(x: cart.x, y: cart.y-1, turn: cart.turn, direction: Direction.up, crashed: cart.crashed)
        }
        if cart.direction == Direction.right {
            return Cart(x: cart.x, y: cart.y+1, turn: cart.turn, direction: Direction.down, crashed: cart.crashed)
        }
    }
    if c == "/" {
        if cart.direction == Direction.up {
            return Cart(x: cart.x+1, y: cart.y, turn: cart.turn, direction: Direction.right, crashed: cart.crashed)
        }
        if cart.direction == Direction.down {
            return Cart(x: cart.x-1, y: cart.y, turn: cart.turn, direction: Direction.left, crashed: cart.crashed)
        }
        if cart.direction == Direction.left {
            return Cart(x: cart.x, y: cart.y+1, turn: cart.turn, direction: Direction.down, crashed: cart.crashed)
        }
        if cart.direction == Direction.right {
            return Cart(x: cart.x, y: cart.y-1, turn: cart.turn, direction: Direction.up, crashed: cart.crashed)
        }
    }
    if c == "+" {
        if cart.turn == Turn.left {
            if cart.direction == Direction.left {
                return Cart(x: cart.x, y: cart.y+1, turn: Turn.straight, direction: Direction.down, crashed: cart.crashed)
            }
            if cart.direction == Direction.right {
                return Cart(x: cart.x, y: cart.y-1, turn: Turn.straight, direction: Direction.up, crashed: cart.crashed)
            }
            if cart.direction == Direction.up {
                return Cart(x: cart.x-1, y: cart.y, turn: Turn.straight, direction: Direction.left, crashed: cart.crashed)
            }
            if cart.direction == Direction.down {
                return Cart(x: cart.x+1, y: cart.y, turn: Turn.straight, direction: Direction.right, crashed: cart.crashed)
            }
        }
        if cart.turn == Turn.straight {
            if cart.direction == Direction.left {
                return Cart(x: cart.x-1, y: cart.y, turn: Turn.right, direction: cart.direction, crashed: cart.crashed)
            }
            if cart.direction == Direction.right {
                return Cart(x: cart.x+1, y: cart.y, turn: Turn.right, direction: cart.direction, crashed: cart.crashed)
            }
            if cart.direction == Direction.up {
                return Cart(x: cart.x, y: cart.y-1, turn: Turn.right, direction: cart.direction, crashed: cart.crashed)
            }
            if cart.direction == Direction.down {
                return Cart(x: cart.x, y: cart.y+1, turn: Turn.right, direction: cart.direction, crashed: cart.crashed)
            }
        }
        if cart.turn == Turn.right {
            if cart.direction == Direction.left {
                return Cart(x: cart.x, y: cart.y-1, turn: Turn.left, direction: Direction.up, crashed: cart.crashed)
            }
            if cart.direction == Direction.right {
                return Cart(x: cart.x, y: cart.y+1, turn: Turn.left, direction: Direction.down, crashed: cart.crashed)
            }
            if cart.direction == Direction.up {
                return Cart(x: cart.x+1, y: cart.y, turn: Turn.left, direction: Direction.right, crashed: cart.crashed)
            }
            if cart.direction == Direction.down {
                return Cart(x: cart.x-1, y: cart.y, turn: Turn.left, direction: Direction.left, crashed: cart.crashed)
            }
        }
    }
    return nil
}

func isInCarts(cart: Cart, carts: Carts) -> Bool {
    for cc in carts {
        if (cc.x == cart.x) && (cc.y == cart.y) && !cc.crashed && !cart.crashed {
            return true
        }
    }
    return false
}

func markCollisions(carts: inout Carts) {
    for i in 0..<carts.count {
        for j in 0..<carts.count {
            if i != j {
                if (carts[i].x == carts[j].x) && (carts[i].y == carts[j].y) && !carts[i].crashed && !carts[j].crashed {
                    carts[i].crashed = true
                    carts[j].crashed = true
                }
            }
        }
    }
}

func removeColiding(carts: Carts) -> Carts {
    return carts.filter { !$0.crashed }
}

func oneTick(carts: Carts, map: Map) -> Carts {
    var actual = carts
    var newCarts = Carts()
    var i = 0
    while i < actual.count {
        if !actual[i].crashed {
            actual[i] = moveCart(cart: actual[i], map: map)!
        }
        markCollisions(carts: &actual)
        i += 1
    }
    newCarts = removeColiding(carts: actual)
    return sortCarts(carts: newCarts)
}

/*
func findFirstCollision(map: Map, carts: Carts) -> Cart? {
    var cc = carts
    var i = 0
    while i < 100000 {
        if let colision = firstCollision(carts: cc) {
            return colision
        }
        cc = oneTick(carts: cc, map: map)
        i += 1
    }
    return nil
}
*/

//var map = loadMap(lines: lines)
//var carts = findCarts(map: &map)

//print(map)
//print(carts)

//print(findFirstCollision(map: map, carts: carts))

func eliminate(map: Map, carts: Carts) -> Cart? {
    var cc = carts
    var i = 0
    while i < 100000 && cc.count > 1 {
        cc = oneTick(carts: cc, map: map)
        i += 1
    }
    return cc.first
}

var map2 = loadMap(lines: lines)
var carts2 = findCarts(map: &map2)
print("last cart: ", eliminate(map: map2, carts: carts2))
