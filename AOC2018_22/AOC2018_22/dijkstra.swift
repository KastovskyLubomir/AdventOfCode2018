//
//  dijkstra.swift
//  AOC2018_22
//
//  Created by Lubomír Kaštovský on 24/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

func gearToInt(gear: Gear) -> Int {
    switch gear {
    case .climb: return 1
    case .torch: return 2
    case .none: return 3
    }
}

func createNodeId(x: Int, y: Int, gear: Gear) -> Int {
    return gearToInt(gear: gear)*1000000 + y*1000 + x
}

func edgesToNeighbors(x: Int, y: Int, gear: Gear, map: inout ErosionLevelMap) -> Dictionary<Int, Edge> {
    var edges = Dictionary<Int, Edge>()
    let sizeX = map[0].count
    let sizeY = map.count
    var newX = 0
    var newY = 0
    let type = erosionToType(erosionLevel: map[y][x])
    for i in 0..<4 {
        switch i {
        case 0:
            if x > 0 {
                newX = x - 1; newY = y
            } else {
                continue
            }
        case 1:
            if y > 0 {
                newX = x; newY = y - 1
            } else {
                continue
            }
        case 2:
            if (x + 1) < sizeX {
                newX = x + 1; newY = y
            } else {
                continue
            }
        case 3:
            if (y + 1) < sizeY {
                newX = x; newY = y + 1
            } else {
                continue
            }
        default: continue
        }
        
        let neighborType = erosionToType(erosionLevel: map[newY][newX])
        
        switch gear {
        case .climb:
            switch type {
            case .rocky, .wet:
                if neighborType == .rocky || neighborType == .wet {
                    edges[createNodeId(x: newX, y: newY, gear: .climb)] = Edge(destinationNodeId: createNodeId(x: newX, y: newY, gear: .climb), weight: 1)
                }
            case .narrow: break
            }
        case .torch:
            switch type {
            case .rocky, .narrow:
                if neighborType == .rocky || neighborType == .narrow {
                    edges[createNodeId(x: newX, y: newY, gear: .torch)] = Edge(destinationNodeId: createNodeId(x: newX, y: newY, gear: .torch), weight: 1)
                }
            case .wet: break
            }
        case .none:
            switch type {
            case .wet, .narrow:
                if neighborType == .wet || neighborType == .narrow {
                    edges[createNodeId(x: newX, y: newY, gear: .none)] = Edge(destinationNodeId: createNodeId(x: newX, y: newY, gear: .none), weight: 1)
                }
            case .rocky: break
            }
        }
    }
    
    return edges
}

func constructGraph(map: inout ErosionLevelMap) -> Graph {
    var graph = Graph()
    var nodeA = GraphNode(nodeId: 0, edges: [:], distance: 0, gear: .none)
    var nodeB = GraphNode(nodeId: 0, edges: [:], distance: 0, gear: .none)
    for y in 0..<map.count {
        for x in 0..<map[y].count {
            let type = erosionToType(erosionLevel: map[y][x])
            switch type {
            case .rocky:
                nodeA = GraphNode(nodeId: createNodeId(x: x, y: y, gear: .torch), edges: [:], distance: Int.max, gear: .torch)
                nodeB = GraphNode(nodeId: createNodeId(x: x, y: y, gear: .climb), edges: [:], distance: Int.max, gear: .climb)
            case .wet:
                nodeA = GraphNode(nodeId: createNodeId(x: x, y: y, gear: .none), edges: [:], distance: Int.max, gear: .none)
                nodeB = GraphNode(nodeId: createNodeId(x: x, y: y, gear: .climb), edges: [:], distance: Int.max, gear: .climb)
            case .narrow:
                nodeA = GraphNode(nodeId: createNodeId(x: x, y: y, gear: .torch), edges: [:], distance: Int.max, gear: .torch)
                nodeB = GraphNode(nodeId: createNodeId(x: x, y: y, gear: .none), edges: [:], distance: Int.max, gear: .none)
            }
            
            // add edge between
            nodeA.edges[nodeB.nodeId] = Edge(destinationNodeId: nodeB.nodeId, weight: 7)
            nodeB.edges[nodeA.nodeId] = Edge(destinationNodeId: nodeA.nodeId, weight: 7)
            
            // find edges to neigboring nodes
            nodeA.edges.merge(edgesToNeighbors(x: x, y: y, gear: nodeA.gear, map: &map)) { (current, _) in current }
            nodeB.edges.merge(edgesToNeighbors(x: x, y: y, gear: nodeB.gear, map: &map)) { (current, _) in current }
            
            // insert to graph
            graph[nodeA.nodeId] = nodeA
            graph[nodeB.nodeId] = nodeB
        }
    }
    return graph
}

func updateDistancesOfNodeNeighbors(nodeId: Int, graph: inout Graph, sortedNodes: inout Array<GraphNode>) {
    if let node = graph[nodeId] {
        for neigborId in node.edges.keys {
            if graph[neigborId]!.distance > (node.edges[neigborId]!.weight + node.distance) {
                graph[neigborId]!.distance = node.edges[neigborId]!.weight + node.distance
                if sortedNodes.filter({ $0.nodeId == neigborId }).isEmpty {
                    sortedNodes.append(graph[neigborId]!)
                }
            }
        }
    }
}

func dijkstraFastestPath(targetX: Int, targetY: Int, depth: Int) -> (torch: Int, climb: Int) {
    let sizeX = targetX + 60
    let sizeY = targetY + 40
    
    var map = constructMap(mouthX: 0, mouthY: 0, targetX: targetX, targetY: targetY, sizeX: sizeX, sizeY: sizeY, depth: depth)
    var graph = constructGraph(map: &map)
    
    var finishedNodes = Set<Int>()
    
    var sortedNodes = Array<GraphNode>()
    
    graph[createNodeId(x: 0, y: 0, gear: .torch)]!.distance = 0
    sortedNodes.append(graph[createNodeId(x: 0, y: 0, gear: .torch)]!)
    graph[createNodeId(x: 0, y: 1, gear: .torch)]!.distance = 1
    sortedNodes.append(graph[createNodeId(x: 0, y: 1, gear: .torch)]!)
    graph[createNodeId(x: 0, y: 0, gear: .climb)]!.distance = 7
    sortedNodes.append(graph[createNodeId(x: 0, y: 0, gear: .climb)]!)
    
    while finishedNodes.count < graph.count {
        
        if (finishedNodes.count % (graph.count / 10)) == 0 {
            print((finishedNodes.count / (graph.count / 10))*10, "%")
        }
        
        let minimumNodeId = sortedNodes.first!.nodeId
        sortedNodes.removeFirst()
        
        // relax distances of minimal distance node neigbors
        updateDistancesOfNodeNeighbors(nodeId: minimumNodeId, graph: &graph, sortedNodes: &sortedNodes)
        sortedNodes.sort(by: { (n0, n1) in n0.distance < n1.distance })
        
        // put the actual (minimum) node to finished group
        finishedNodes.insert(minimumNodeId)
    }
    
    let targetIdTorch = createNodeId(x: targetX, y: targetY, gear: .torch)
    let targetIdClimb = createNodeId(x: targetX, y: targetY, gear: .climb)
    return (graph[targetIdTorch]!.distance, graph[targetIdClimb]!.distance)
}
