//
//  UIFontExtension.swift
//  KLine
//
//  Created by yang on 2018/6/14.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit

extension UIFont {
    
    // 中文字体
    class func scThinFont(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Thin", size: size)!
    }
    class func scLightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: size)!
    }
    class func scRegularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size)!
    }
    class func scMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size)!
    }
    class func scSemiboldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size)!
    }
    
    // 数字字体
    class func dinAlternateFont(size: CGFloat) -> UIFont {
        return UIFont(name: "DINAlternate-Bold", size: size)!
    }
    
}
