//
//  DictionaryExtension.swift
//  SwiftExtension
//
//  Created by 王洋 on 2019/1/28.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

extension Dictionary {
    
    // 是否包含某key
    public func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    // 移除某些key的key-value
    public mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }
    
    // 获取jsonData
    public func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    // 获取jsonString
    public func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    
}

public extension Dictionary where Value: Equatable {
    
    // 根据value获取key
    public func keys(forValue value: Value) -> [Key] {
        return keys.filter { self[$0] == value }
    }
    
}

public extension Dictionary where Key: StringProtocol {
    
    // 所有key转换为小写
    public mutating func lowercaseAllKeys() {
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
    
}

