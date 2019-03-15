//
//  ScrollViewExtension.swift
//  SwiftExtension
//
//  Created by 王洋 on 2019/1/24.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    // 获取ScrollView截图
    public var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = frame
        frame = CGRect(origin: frame.origin, size: contentSize)
        layer.render(in: context)
        frame = previousFrame
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
