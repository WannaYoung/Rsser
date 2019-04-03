//
//  ArrayExtension.swift
//  SwiftExtension
//
//  Created by 王洋 on 2019/1/28.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

extension Array {
    
    // 数组起始位置插入元素
    public mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    // 移动某index元素到新的index
    public mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
    
    // 筛选出满足条件的元素
    // [0, 2, 4, 7, 9].keep( where: {$0 % 2 == 0}) -> [0, 2, 4]
    @discardableResult
    public mutating func keep(while condition: (Element) throws -> Bool) rethrows -> [Element] {
        for (index, element) in lazy.enumerated() where try !condition(element) {
            self = Array(self[startIndex..<index])
            break
        }
        return self
    }
    
    // 根据某条件分割数组
    // [0, 1, 2, 3, 4, 5].divided { $0 % 2 == 0 } -> ( [0, 2, 4], [1, 3, 5] )
    public func divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        var matching = [Element]()
        var nonMatching = [Element]()
        for element in self {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }
    
    // 返回按条件排序的数组
    public func sorted<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        return sorted(by: { (lhs, rhs) -> Bool in
            guard let lhsValue = lhs[keyPath: path], let rhsValue = rhs[keyPath: path] else { return false }
            return ascending ? lhsValue < rhsValue : lhsValue > rhsValue
        })
    }
    
    // 返回按条件排序的数组
    public func sorted<T: Comparable>(by path: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        return sorted(by: { (lhs, rhs) -> Bool in
            return ascending ? lhs[keyPath: path] < rhs[keyPath: path] : lhs[keyPath: path] > rhs[keyPath: path]
        })
    }
    
    // 数组按条件排序
    @discardableResult
    public mutating func sort<T: Comparable>(by path: KeyPath<Element, T?>, ascending: Bool = true) -> [Element] {
        self = sorted(by: path, ascending: ascending)
        return self
    }
    
    // 数组按条件排序
    @discardableResult
    public mutating func sort<T: Comparable>(by path: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        self = sorted(by: path, ascending: ascending)
        return self
    }
    
}

public extension Array where Element: Equatable {
    
    // 移除所有某元素
    // [1, 2, 2, 3, 4, 5].removeAll(2) -> [1, 3, 4, 5]
    @discardableResult
    public mutating func removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }
    
    // 移除所有某些元素
    // [1, 2, 2, 3, 4, 5].removeAll([2,5]) -> [1, 3, 4]
    @discardableResult
    public mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }
    
    // 移除重复元素
    // [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
    public mutating func removeDuplicates() {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
    // 获取无重复元素数组
    // [1, 1, 2, 2, 3, 3, 3, 4, 5].withoutDuplicates() -> [1, 2, 3, 4, 5])
    public func withoutDuplicates() -> [Element] {
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
    
}
