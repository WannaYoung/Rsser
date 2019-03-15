//
//  AppExtension.swift
//  SwiftExtension
//
//  Created by 王洋 on 2019/1/24.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

// MARK: - App
public struct App {
    
    // 应用名称
    public static var displayName: String? {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    // BundleID
    public static var bundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    
    // 版本号
    public static var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    // Build版本号
    public static var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

}

// MARK: - Properties
public extension App {
    
    // 小红点数量
    public static var badgeNumber: Int {
        get {
            return UIApplication.shared.applicationIconBadgeNumber
        }
        set {
            UIApplication.shared.applicationIconBadgeNumber = newValue
        }
    }
    
    // 是否调试模式
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    // 是否TestFlight
    public static var isTestFlight: Bool {
        return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
    }
    
    // 是否注册通知
    public static var isNotificationsRegistered: Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
}

// MARK: - Methods
public extension App {
    
    // 检测到用户截屏
    public static func didTakeScreenShot(_ action: @escaping (_ notification: Notification) -> Void) {
        _ = NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main) { notification in
                                                    action(notification)
        }
    }
    
}
