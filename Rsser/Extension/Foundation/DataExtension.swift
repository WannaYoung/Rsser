//
//  DataExtension.swift
//  SwiftExtension
//
//  Created by 王洋 on 2019/1/28.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

// MARK: - Properties
public extension Data {
    
    // 获取Data大小
    public var bytes: [UInt8] {
        return [UInt8](self)
    }
    
}

// MARK: - Methods
public extension Data {
    
    // Data转String
    public func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    // Data转json对象
    public func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    
}
