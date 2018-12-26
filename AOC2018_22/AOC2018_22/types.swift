//
//  types.swift
//  AOC2018_22
//
//  Created by Lubomír Kaštovský on 24/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

enum Gear {
    case torch
    case climb
    case none
}

enum FieldType {
    case rocky
    case wet
    case narrow
}


struct Position : Hashable, Equatable {
    var x: Int
    var y: Int
    var gear: Gear
    var spentTime: Int
    public var hashValue: Int
    
    init(x: Int, y: Int, gear: Gear, spentTime: Int) {
        self.x = x
        self.y = y
        self.gear = gear
        self.spentTime = spentTime
        self.hashValue = y*10000 + x
    }
    
    public static func == (lhs: Position, rhs: Position) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
}

typealias Path = LinkedList<Position>

typealias ErosionLevelMap = Array<Array<Int>>

struct Edge {
    var destinationNodeId: Int
    var weight: Int
    
    init(destinationNodeId: Int, weight: Int) {
        self.destinationNodeId = destinationNodeId
        self.weight = weight
    }
}

struct GraphNode {
    var nodeId: Int
    var edges: Dictionary<Int, Edge>
    var distance: Int
    var gear: Gear
    
    init(nodeId: Int, edges: Dictionary<Int, Edge>, distance: Int, gear: Gear) {
        self.nodeId = nodeId
        self.edges = edges
        self.distance = distance
        self.gear = gear
    }
}

typealias Graph = Dictionary<Int, GraphNode>
