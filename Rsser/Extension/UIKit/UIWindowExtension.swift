//
//  UIWindowExtension.swift
//  JayPal
//
//  Created by yang on 2018/7/5.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit

extension UIWindow {
    public class var current: UIWindow {
        if let window:UIWindow = UIApplication.shared.keyWindow {
            return window
        } else {
            return UIApplication.shared.windows[0]
        }
    }
}
