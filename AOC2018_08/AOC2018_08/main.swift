
let licenseFile = stringNumArrayToArrayOfInt(input: inputString, separators: [" ", "\n"])

struct Node {
    let id: Int
    var childNodesCount: Int
    var metadataCount: Int
    var childNodes: Array<Node>
    var metadata: Array<Int>
    var nodeValue: Int
    
    init(id: Int,
         childNodesCount: Int,
         metadataCount: Int,
         childNodes: Array<Node>,
         metadata: Array<Int>,
         nodeValue: Int) {
        self.id = id
        self.childNodesCount = childNodesCount
        self.metadataCount = metadataCount
        self.childNodes = childNodes
        self.metadata = metadata
        self.nodeValue = nodeValue
    }
}

typealias Tree = Dictionary<Int, Node>

func constructTree(license: Array<Int>, id: Int, startPos: Int) -> (Node, Int, Int) {
    var nodeId = id
    var i = startPos
    var metadataSum = 0
    var root = Node(id: nodeId, childNodesCount: 0, metadataCount: 0,
                    childNodes: [Node](), metadata: [Int](), nodeValue: 0)
    nodeId += 1
    root.childNodesCount = license[i]; i+=1
    root.metadataCount = license[i]; i+=1
    for _ in 0..<root.childNodesCount {
        let node = constructTree(license: license, id: nodeId, startPos: i)
        root.childNodes.append(node.0)
        i = node.1
        metadataSum += node.2
    }
    for _ in 0..<root.metadataCount {
        root.metadata.append(license[i])
        metadataSum += license[i]
        i+=1
    }
    if root.childNodesCount == 0 {
        for j in 0..<root.metadataCount {
            root.nodeValue += root.metadata[j]
        }
    }
    else {
        for j in 0..<root.metadataCount {
            let index = root.metadata[j] - 1
            if (index < root.childNodes.count) && (index >= 0) {
                root.nodeValue += root.childNodes[index].nodeValue
            }
        }
    }
    return (root, i, metadataSum)
}

let tree = constructTree(license: licenseFile, id: 0, startPos: 0)

print("1. result: ", tree.2)
print("2. result: ", tree.0.nodeValue)
