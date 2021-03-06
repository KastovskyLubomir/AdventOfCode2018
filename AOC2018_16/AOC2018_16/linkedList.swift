//
//  linkedList.swift
//  AOC2018_12
//
//  Created by Lubomír Kaštovský on 13/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//


import Foundation

class LinkedList<Element> {
    
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
        self.first = nil
        self.last = nil
        self.count = 0
    }
    
    /// Points to actual element.
    var actual: Node<Element>?
    var first: Node<Element>?
    var last: Node<Element>?
    /// Count of elements in list.
    var count: Int
    
    /**
     Append element after the last element in the list. New element becomes new last.
     - Parameter value: Appended element.
     */
    public func appendLast(value: Element) {
        if actual == nil {
            actual = Node()
            actual!.left = nil
            actual!.right = nil
            actual!.value = value
            first = actual
            last = actual
        } else {
            let x = Node(left: last, right: nil, value: value)
            last!.right = x
            last = x
        }
        count += 1
    }
    
    /**
     Insert element on the first place in the list. New element becomes new first.
     - Parameter value: Inserted element.
     */
    public func insertFirst(value: Element) {
        if actual == nil {
            actual = Node()
            actual!.left = nil
            actual!.right = nil
            actual!.value = value
            first = actual
            last = actual
        } else {
            let x = Node(left: nil, right: first, value: value)
            first!.left = x
            first = x
        }
        count += 1
    }
    
    /**
     Move actual to right shift-times. Shift is a parameter.
     - Parameter shift: Number of elements to move the actual pointer to the right.
     */
    public func moveToRight(shift: Int) {
        guard actual != nil else { return }
        for _ in 0..<shift {
            if actual!.right != nil {
                actual = actual!.right
            }
        }
    }
    
    /**
     Move actual to left shift-times. Shift is a parameter.
     - Parameter shift: Number of elements to move the actual pointer to the left.
     */
    public func moveToLeft(shift: Int) {
        guard actual != nil else { return }
        for _ in 0..<shift {
            if actual!.left != nil {
                actual = actual!.left
            }
        }
    }
    
    /**
     Remove actual, new actual becomes the element which was on right side of removed actual Element.
     */
    public func removeActual() {
        
    }
    
    public func removeLast() {
        guard last != nil else { return }
        let ll = last
        if actual === last {
            actual = last!.left
        }
        last = last!.left
        if last != nil {
            last!.right = nil
        }
        ll!.left = nil
        count -= 1
    }
    
    public func removeFirst() {
        guard first != nil else { return }
        let ff = first
        if actual === first {
            actual = first!.right
        }
        first = first!.right
        if first != nil {
            first!.left = nil
        }
        ff!.right = nil
        count -= 1
    }
    
    public func actualToFirst() {
        actual = first
    }
    
    public func actualToLast() {
        actual = last
    }
}


