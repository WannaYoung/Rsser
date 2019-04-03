//
//  AppDelegate.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/14.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configAppearance()
        return true
    }
    
    //MARK: - 设置界面Appearance
    func configAppearance() {
        window!.backgroundColor = UIColor.background
        //导航栏样式
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.main
        UINavigationBar.appearance().barTintColor = UIColor.background
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainText, NSAttributedString.Key.font: UIFont.scMediumFont(size: 16)]
        
        //导航栏返回按钮样式
        let goBackImage:UIImage = UIImage(named: "button_goback")!
        UINavigationBar.appearance().backIndicatorImage = goBackImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = goBackImage
        var offset:UIOffset = UIOffset.zero
        offset.horizontal = -500
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setBackButtonTitlePositionAdjustment(offset, for: .default)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.main, NSAttributedString.Key.font: UIFont.scRegularFont(size: 16)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.main, NSAttributedString.Key.font: UIFont.scRegularFont(size: 16)], for: .highlighted)
        
        //列表背景颜色
        UITableView.appearance().backgroundColor = UIColor.background
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if UserDefaults.standard.bool(forKey: "touchid") {
            let authVC = AuthIDController()
            UIViewController.current().present(authVC, animated: false) { }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

