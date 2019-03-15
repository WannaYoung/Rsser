//
//  UIDeviceExtension.swift
//  KLine
//
//  Created by yang on 2018/6/11.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit

extension UIDevice  {
    
    // 设备类型
    public static var deviceModel: String {
        return current.model
    }
    
    // 设备名字
    public static var deviceName: String {
        return current.name
    }
    
    // 剩余电量
    public static var battery: Float {
        return current.batteryLevel
    }
    
    // 系统版本
    public static var version: String {
        return current.systemVersion
    }
    
}

extension UIDevice {
    
    // 屏幕宽度
    public static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    // 屏幕高度
    public static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    // 状态栏高度
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    // 导航栏栏高度
    public static var naviBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height+44.0
    }
    
    // 当前屏幕方向
    public static var deviceOrientation: UIDeviceOrientation {
        return current.orientation
    }
    
}

extension UIDevice  {
    
    // 是否平板
    public static var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }
    
    // 是否手机
    public static var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }
    
    // 是否模拟器
    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    // 是否iPhone X
    static var isIphoneX: Bool {
        return height/width > 16.5/9
    }
    
}
