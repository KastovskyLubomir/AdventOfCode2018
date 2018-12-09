
import Foundation

class CircleList<Element> {
    
    class Node<Element> {
        
        var left: Node?
        var right: Node?
        var value: Element?
        
        init(left: Node? = nil, right: Node? = nil, value: Element? = nil) {
            self.left = left
            self.right = right
            self.value = value
        }
    }
    
    init() {
        self.actual = nil
        self.count = 0
    }
    
    var actual: Node<Element>?
    var count: Int
    
    /**
     Insert element on the right side of actual.
     - Parameter value: Inserted element.
     */
    public func insertRight(value: Element) {
        if actual == nil {
            actual = Node()
            actual!.left = actual
            actual!.right = actual
            actual!.value = value
        } else {
            let x = Node(left: actual, right: actual!.right, value: value)
            actual!.right = x
            x.right!.left = x
        }
        count += 1
    }
    
    /**
     Insert element on the left side of actual.
     - Parameter value: Inserted element.
     */
    public func insertLeft(value: Element) {
        if actual == nil {
            actual = Node()
            actual!.left = actual
            actual!.right = actual
            actual!.value = value
        } else {
            let x = Node(left: actual!.left, right: actual, value: value)
            actual!.left = x
            x.left!.right = x
        }
        count += 1
    }
    
    /**
     Move actual to right n-times. n is a parameter.
     - Parameter shift: Number of elements to move the actual pointer to the right.
     */
    public func moveToRight(shift: Int) {
        guard actual != nil else { return }
        for _ in 0..<shift {
            actual = actual?.right
        }
    }
    
    /**
     Move actual to left n-times. n is a parameter.
     - Parameter shift: Number of elements to move the actual pointer to the left.
     */
    public func moveToLeft(shift: Int) {
        guard actual != nil else { return }
        for _ in 0..<shift {
            actual = actual!.left
        }
    }
    
    /**
     Remove actual, new actual becomes the element which was on right side of removed actual Element.
     */
    public func removeActual() {
        guard actual != nil else { return }
        if count > 1 {
            let newActual = actual!.right
            actual!.left!.right = actual!.right
            actual!.right!.left = actual!.left
            actual!.left = nil
            actual!.right = nil
            actual = newActual
        } else {
            actual!.left = nil
            actual!.right = nil
            actual = nil
        }
        count -= 1
    }
}


