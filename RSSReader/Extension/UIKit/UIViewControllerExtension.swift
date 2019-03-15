//
//  UIViewControllerExtension.swift
//  Everest
//
//  Created by yang on 2017/5/10.
//  Copyright © 2017年 yang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertWith(style: UIAlertController.Style, title: String, message: String, actionTitles: [String],destructIndex: Int = 100, hasCancel: Bool, selectAction:@escaping (_ buttonIndex:Int) -> Void, cancelAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title == "" ? nil : title, message:  message == "" ? nil : message, preferredStyle: style)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler:{
            (UIAlertAction) -> Void in
            cancelAction?()
        })
        if hasCancel {
            alertController.addAction(cancelAction)
        }
        for i in 0..<actionTitles.count {
            let action = UIAlertAction(title: actionTitles[i], style: i == destructIndex ? .destructive : .default, handler: {
                (UIAlertAction) -> Void in
                selectAction(i)
            })
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    class func current() -> UIViewController {
        var result = UIViewController()
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for temp in windows {
                if temp.windowLevel == UIWindow.Level.normal {
                    window = temp
                    break
                }
            }
        }
        if let appRootVC = window?.rootViewController {
            if let frontView = window?.subviews.first {
                if var nextResponder = frontView.next  {
                    if let _ = appRootVC.presentedViewController {
                        nextResponder = appRootVC.presentedViewController!
                    }
                    if nextResponder is UITabBarController {
                        let tabbar = nextResponder as! UITabBarController
                        let nav = tabbar.viewControllers![tabbar.selectedIndex] as! UINavigationController
                        result = nav.children.last!
                    } else if nextResponder is UINavigationController {
                        let nav = nextResponder as! UINavigationController
                        result = nav.children.last!
                    } else {
                        result = nextResponder as! UIViewController
                    }
                }
            }
        }
        return result
    }
    
}
