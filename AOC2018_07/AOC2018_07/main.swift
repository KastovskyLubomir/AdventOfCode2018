
/*
 
 --- Day 7: The Sum of Its Parts ---
 
 You find yourself standing on a snow-covered coastline; apparently, you landed a little off course. The region is too hilly to see the North Pole from here, but you do spot some Elves that seem to be trying to unpack something that washed ashore. It's quite cold out, so you decide to risk creating a paradox by asking them for directions.
 
 "Oh, are you the search party?" Somehow, you can understand whatever Elves from the year 1018 speak; you assume it's Ancient Nordic Elvish. Could the device on your wrist also be a translator? "Those clothes don't look very warm; take this." They hand you a heavy coat.
 
 "We do need to find our way back to the North Pole, but we have higher priorities at the moment. You see, believe it or not, this box contains something that will solve all of Santa's transportation problems - at least, that's what it looks like from the pictures in the instructions." It doesn't seem like they can read whatever language it's in, but you can: "Sleigh kit. Some assembly required."
 
 "'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh' at once!" They start excitedly pulling more parts out of the box.
 
 The instructions specify a series of steps and requirements about which steps must be finished before others can begin (your puzzle input). Each step is designated by a single letter. For example, suppose you have the following instructions:
 
 Step C must be finished before step A can begin.
 Step C must be finished before step F can begin.
 Step A must be finished before step B can begin.
 Step A must be finished before step D can begin.
 Step B must be finished before step E can begin.
 Step D must be finished before step E can begin.
 Step F must be finished before step E can begin.
 Visually, these requirements look like this:
 
 
 -->A--->B--
 /    \      \
 C      -->D----->E
 \           /
 ---->F-----
 Your first goal is to determine the order in which the steps should be completed. If more than one step is ready, choose the step which is first alphabetically. In this example, the steps would be completed as follows:
 
 Only C is available, and so it is done first.
 Next, both A and F are available. A is first alphabetically, so it is done next.
 Then, even though F was available earlier, steps B and D are now also available, and B is the first alphabetically of the three.
 After that, only D and F are available. E is not available because only some of its prerequisites are complete. Therefore, D is completed next.
 F is the only choice, so it is done next.
 Finally, E is completed.
 So, in this example, the correct order is CABDFE.
 
 In what order should the steps in your instructions be completed?
 
 Your puzzle answer was BDHNEGOLQASVWYPXUMZJIKRTFC.
 
 --- Part Two ---
 
 As you're about to begin construction, four of the Elves offer to help. "The sun will set soon; it'll go faster if we work together." Now, you need to account for multiple people working on steps simultaneously. If multiple steps are available, workers should still begin them in alphabetical order.
 
 Each step takes 60 seconds plus an amount corresponding to its letter: A=1, B=2, C=3, and so on. So, step A takes 60+1=61 seconds, while step Z takes 60+26=86 seconds. No time is required between steps.
 
 To simplify things for the example, however, suppose you only have help from one Elf (a total of two workers) and that each step takes 60 fewer seconds (so that step A takes 1 second and step Z takes 26 seconds). Then, using the same instructions as above, this is how each second would be spent:
 
 Second   Worker 1   Worker 2   Done
 0        C          .
 1        C          .
 2        C          .
 3        A          F       C
 4        B          F       CA
 5        B          F       CA
 6        D          F       CAB
 7        D          F       CAB
 8        D          F       CAB
 9        D          .       CABF
 10        E          .       CABFD
 11        E          .       CABFD
 12        E          .       CABFD
 13        E          .       CABFD
 14        E          .       CABFD
 15        .          .       CABFDE
 Each row represents one second of time. The Second column identifies how many seconds have passed as of the beginning of that second. Each worker column shows the step that worker is currently doing (or . if they are idle). The Done column shows completed steps.
 
 Note that the order of the steps has changed; this is because steps now take time to finish and multiple workers can begin multiple steps simultaneously.
 
 In this example, it would take 15 seconds for two workers to complete these steps.
 
 With 5 workers and the 60+ second step durations described above, how long will it take to complete all of the steps?
 
 Your puzzle answer was 1107.
 
 */


let lines = readLinesRemoveEmpty(str: inputString)

typealias NodePair = (UInt8, UInt8)

func parseNodes(lines: Array<String>) -> Array<NodePair> {
    var result = [NodePair]()
    for ll in lines {
        let args = ll.components(separatedBy: [" "])
        let aa = (args[1].utf8).first!
        let bb = (args[7].utf8).first!
        result.append((aa, bb))
    }
    return result
}

let nodes = parseNodes(lines: lines)
typealias Graph = Array<(UInt8, Array<UInt8>)>
typealias Prereq = Dictionary<UInt8, Set<UInt8>>

func construct(nodes: Array<NodePair>) -> (Graph, Prereq) {
    var tmp = Graph()
    var result = Graph()
    var prereq = Prereq()
    for node in nodes {
        if let index = tmp.firstIndex(where: { $0.0 == node.0 }) {
            var fol = tmp[index].1
            fol.append(node.1)
            tmp.remove(at: index)
            tmp.append((node.0, fol.sorted()))
        } else {
            tmp.append((node.0, [node.1]))
        }
        
        if prereq[node.1] != nil {
            prereq[node.1]!.insert(node.0)
        } else {
            prereq[node.1] = [node.0]
        }
    }
    result = tmp.sorted(by: { $0.0 < $1.0 })
    return (result, prereq)
}

let space = construct(nodes: nodes)

func findFirstNodes(graph: Graph) -> Array<UInt8> {
    var found = [UInt8]()
    for item in graph {
        var isInSecond = false
        for item2 in graph {
            if item.0 != item2.0 {
                if item2.1.contains(item.0) {
                    isInSecond = true
                    break
                }
            }
        }
        if !isInSecond {
            found.append(item.0)
        }
    }
    return found.sorted()
}

let firstNodes = findFirstNodes(graph: space.0)

func getFollowers(node: UInt8, graph: Graph) -> Array<UInt8> {
    if let followers = graph.first(where: { $0.0 == node }) {
        return followers.1
    }
    return []
}

func removeNodeFromGraph(node: UInt8, graph: Graph) -> Graph {
    return graph.filter { $0.0 != node }.sorted(by: { $0.0 < $1.0 })
}

func clearNodeFromGraphFollowers(node: UInt8, graph: Graph) -> Graph {
    var res = Graph()
    for x in graph {
        res.append((x.0, x.1.filter { $0 != node }))
    }
    return res
}

func removableNode(nodes: Array<UInt8>, prereq: Prereq) -> UInt8 {
    for x in nodes {
        if let pre = prereq[x] {
            if pre.count == 0 {
                return x
            }
        } else {
            return x
        }
    }
    return 0
}

func clearFromPrereq(node: UInt8, prereq: Prereq) -> Prereq {
    var res = Prereq()
    for x in prereq.keys {
        res[x] = prereq[x]!.filter { $0 != node }
    }
    return res
}

func goThroughGraph(firstNodes: Array<UInt8>, graph: Graph, prereq: Prereq) -> Array<UInt8> {
    var result = [UInt8]()
    var pre = prereq
    var gr = graph
    var actualNodes = firstNodes
    while !actualNodes.isEmpty {
        let actual = removableNode(nodes: actualNodes, prereq: pre)
        result.append(actual)
        actualNodes = actualNodes.filter { $0 != actual }
        gr = clearNodeFromGraphFollowers(node: actual, graph: gr)
        pre = clearFromPrereq(node: actual, prereq: pre)
        let followersSet = Set(getFollowers(node: actual, graph: gr))
        gr = removeNodeFromGraph(node: actual, graph: gr)
        let actualSet = Set(actualNodes)
        actualNodes = Array(actualSet.union(followersSet)).sorted()
    }
    return result
}

let sequence = goThroughGraph(firstNodes: firstNodes, graph: space.0, prereq: space.1)
print("1. result: ", String(bytes: sequence, encoding: .utf8)!)

func allWorkersEmpty(workers: Array<(UInt8, Int)>) -> Bool {
    return (workers.filter { $0.0 == 0 }.count == workers.count)
}

func goThroughGraphWithWorkers(firstNodes: Array<UInt8>, graph: Graph, prereq: Prereq, workers: Int) -> (Array<UInt8>, Int) {
    var workerPool = [(UInt8, Int)].init(repeating: (0, 0), count: workers)
    var result = [UInt8]()
    var pre = prereq
    var gr = graph
    var actualNodes = firstNodes
    var second = 0
    var actual: UInt8 = 0
    while !(actualNodes.isEmpty && allWorkersEmpty(workers: workerPool)) {
        // try to place nodes to workers
        for i in 0..<workerPool.count {
            if (workerPool[i].0 == 0) && (workerPool[i].1 == 0) {
                actual = removableNode(nodes: actualNodes, prereq: pre)
                if actual != 0 {
                    result.append(actual)
                    actualNodes = actualNodes.filter { $0 != actual }
                    workerPool[i] = (actual, Int(actual) - 5)
                }
            }
        }
        for i in 0..<workerPool.count {
            if (workerPool[i].0 != 0) {
                if (workerPool[i].1 == 0) {
                    actual = workerPool[i].0
                    gr = clearNodeFromGraphFollowers(node: actual, graph: gr)
                    pre = clearFromPrereq(node: actual, prereq: pre)
                    let followersSet = Set(getFollowers(node: actual, graph: gr))
                    gr = removeNodeFromGraph(node: actual, graph: gr)
                    let actualSet = Set(actualNodes)
                    actualNodes = Array(actualSet.union(followersSet)).sorted()
                    workerPool[i] = (0, 0)
                } else {
                    workerPool[i] = (workerPool[i].0, workerPool[i].1 - 1)
                }
            }
        }
        second += 1
    }
    return (result, second)
}

let product = goThroughGraphWithWorkers(firstNodes: firstNodes, graph: space.0, prereq: space.1, workers: 5)

print("2. result: ", product.1)
