//
//  UIColorExtension.swift
//  MyCenter
//
//  Created by yang on 16/1/26.
//  Copyright © 2016年 yang. All rights reserved.
//

import UIKit

extension UIColor {
    
    // 获取16进制颜色
    public class func hex(_ convertString:String, alpha: CGFloat = 1.0) -> UIColor {
        var cString:String = convertString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.count  < 6) {
            return UIColor.black
        }
        if (cString.hasPrefix("0X")) {
            cString = (cString as NSString).substring(from: 2)
        }
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        if (cString.count  != 6) {
            return UIColor.black
        }
        
        var range:NSRange = NSRange()
        range.location = 0
        range.length = 2
        let rString:String = (cString as NSString).substring(with: range)
        range.location = 2
        let gString:String = (cString as NSString).substring(with: range)
        range.location = 4
        let bString:String = (cString as NSString).substring(with: range)
        
        var r:UInt32 = 0, g:UInt32 = 0, b:UInt32 = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    // 获取随机颜色
    public class func randomColor() -> UIColor {
        let randomColor = UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1.0)
        return randomColor
    }
    
}

public extension UIColor {
    
    // 主色
    public static var main: UIColor {
        return UIColor.hex("#FED201")
    }
    // 背景
    public static var background: UIColor {
        return UIColor.hex("#FEFEFF")
    }
    // 分割线
    public static var line: UIColor {
        return UIColor.hex("#f7f7f7")
    }
    // Header
    public static var header: UIColor {
        return UIColor.hex("#E8EAED")
    }
    // 主文字
    public static var mainText: UIColor {
        return UIColor.hex("#24292D")
    }
    // 普通文字
    public static var commonText: UIColor {
        return UIColor.hex("#666666")
    }
    // 辅助文字
    public static var assistText: UIColor {
        return UIColor.hex("#9C9E9F")
    }
    // 绿色
    public static var green: UIColor {
        return UIColor.hex("#34BA95")
    }
    // 红色
    public static var red: UIColor {
        return UIColor.hex("#FD687D")
    }
    // 橙色
    public static var orange: UIColor {
        return UIColor.hex("#FA6D0A")
    }
    
}
