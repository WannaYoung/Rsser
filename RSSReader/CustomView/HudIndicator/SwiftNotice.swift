//
//  SwiftNotice.swift
//  SwiftNotice
//
//  Created by JohnLui on 15/4/15.
//  Copyright (c) 2015年 com.lvwenhan. All rights reserved.
//

import Foundation
import UIKit

private let sn_topBar: Int = 1001

extension UIResponder {
    // 普通Hud
    @discardableResult
    func pleaseWait() -> UIWindow{
        return SwiftNotice.wait()
    }
    // 图片序列Hud
    @discardableResult
    func pleaseWaitWithImages(_ imageNames: Array<UIImage>, timeInterval: Int) -> UIWindow{
        return SwiftNotice.wait(imageNames, timeInterval: timeInterval)
    }
    // 仅文字Hud
    @discardableResult
    func noticeOnlyText(_ text: String) -> UIWindow{
        return SwiftNotice.showText(text)
    }
    // 图文Hud
    @discardableResult
    func notice(_ text: String, type: NoticeType = .info, autoClear: Bool = true, autoClearTime: Float = 2.0) -> UIWindow{
        return SwiftNotice.showNoticeWithText(type, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    // 状态栏Hud
    @discardableResult
    func noticeTop(_ text: String, autoClear: Bool = true, autoClearTime: Float = 1.0) -> UIWindow{
        return SwiftNotice.noticeOnStatusBar(text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    // 清除所有Hud
    func clearAllNotice() {
        SwiftNotice.clear()
    }
}

enum NoticeType{
    case info
    case error
    case success
}

class SwiftNotice: NSObject {
    
    static var windows = Array<UIWindow?>()
    static var timer: DispatchSource!
    static var timerTimes = 0
    static let rv = UIApplication.shared.keyWindow?.subviews.first as UIView?
    
    static let hudBackColor = UIColor.hex("222222", alpha: 0.0)
    static let hudViewColor = UIColor.clear
    static let hudTintColor = UIColor.mainText
    static let statusBackColor = UIColor.main
    static let statusTintColor = UIColor.white
    static let textHudCorner: CGFloat = 8.0
    static let waitHudCorner: CGFloat = 8.0
    static let indicatorType: NVActivityIndicatorType = .ballSpinFadeLoader

    static func clear() {
        self.cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer {
            timer.cancel()
            timer = nil
            timerTimes = 0
        }
        windows.removeAll(keepingCapacity: false)
    }
    
    @discardableResult
    static func noticeOnStatusBar(_ text: String, autoClear: Bool, autoClearTime: Float) -> UIWindow{
        let frame = UIApplication.shared.statusBarFrame
        let window = UIWindow()
        window.backgroundColor = hudBackColor
        let view = UIView()
        view.backgroundColor = statusBackColor
        
        let label = UILabel(frame: frame.height > 20 ? CGRect(x: frame.origin.x, y: frame.origin.y + frame.height - 17, width: frame.width, height: 20) : frame)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = statusTintColor
        label.text = text
        view.addSubview(label)
        
        window.frame = frame
        view.frame = frame
        
        window.windowLevel = .statusBar
        window.isHidden = false
        window.addSubview(view)
        windows.append(window)
        
        var origPoint = view.frame.origin
        origPoint.y = -(view.frame.size.height)
        let destPoint = view.frame.origin
        view.tag = sn_topBar
        
        view.frame = CGRect(origin: origPoint, size: view.frame.size)
        UIView.animate(withDuration: 0.3, animations: {
            view.frame = CGRect(origin: destPoint, size: view.frame.size)
        }, completion: { b in
            if autoClear {
                self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
            }
        })
        return window
    }
    
    @discardableResult
    static func wait(_ imageNames: Array<UIImage> = Array<UIImage>(), timeInterval: Int = 0) -> UIWindow {
        let frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let window = UIWindow()
        window.backgroundColor = hudBackColor
        let mainView = UIView()
        mainView.layer.cornerRadius = waitHudCorner
        mainView.backgroundColor = hudViewColor
        
        if imageNames.count > 0 {
            if imageNames.count > timerTimes {
                let iv = UIImageView(frame: frame)
                iv.image = imageNames.first!
                iv.contentMode = .scaleAspectFit
                mainView.addSubview(iv)
                timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as? DispatchSource
                timer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(timeInterval))
                timer.setEventHandler(handler: { () -> Void in
                    let name = imageNames[timerTimes % imageNames.count]
                    iv.image = name
                    timerTimes += 1
                })
                timer.resume()
            }
        } else {
            let indicatorView = NVActivityIndicatorView(frame: frame, type: indicatorType)
            indicatorView.padding = 15.0
            indicatorView.color = UIColor.main
            indicatorView.startAnimating()
            mainView.addSubview(indicatorView)
        }
        
        window.frame = (rv?.bounds)!
        mainView.frame = frame
        window.center = rv!.center
        mainView.center = window.center
        
        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        return window
    }
    
    @discardableResult
    static func showText(_ text: String, autoClear: Bool=true, autoClearTime: Int=2) -> UIWindow {
        let window = UIWindow()
        window.backgroundColor = hudBackColor
        let mainView = UIView()
        mainView.layer.cornerRadius = textHudCorner
        mainView.backgroundColor = hudViewColor
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = hudTintColor
        let size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width-82, height: CGFloat.greatestFiniteMagnitude))
        label.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        mainView.addSubview(label)
        
        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50 , height: label.frame.height + 30)
        
        window.frame = (rv?.bounds)!
        mainView.frame = superFrame
        window.center = rv!.center
        mainView.center = window.center
        label.center = mainView.center

        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }
        return window
    }
    
    @discardableResult
    static func showNoticeWithText(_ type: NoticeType,text: String, autoClear: Bool, autoClearTime: Float) -> UIWindow {
        let frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        let window = UIWindow()
        window.backgroundColor = hudBackColor
        let mainView = UIView()
        mainView.layer.cornerRadius = waitHudCorner
        mainView.backgroundColor = hudViewColor
        
        var image = UIImage()
        switch type {
        case .success:
            image = SwiftNoticeSDK.imageOfCheckmark
        case .error:
            image = SwiftNoticeSDK.imageOfCross
        case .info:
            image = SwiftNoticeSDK.imageOfInfo
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = hudTintColor
        label.text = text
        label.textAlignment = NSTextAlignment.center
        mainView.addSubview(label)
        
        window.frame = (rv?.bounds)!
        mainView.frame = frame
        window.center = rv!.center
        mainView.center = window.center

        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }
        return window
    }
    
    
}

class SwiftNoticeSDK {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    class func draw(_ type: NoticeType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .error: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}

extension UIWindow{
    func hide(){
        SwiftNotice.hideNotice(self)
    }
}

fileprivate extension Selector {
    static let hideNotice = #selector(SwiftNotice.hideNotice(_:))
}

@objc extension SwiftNotice {
    
    // fix https://github.com/johnlui/SwiftNotice/issues/2
    static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            
            if let v = window.subviews.first {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    if v.tag == sn_topBar {
                        v.frame = CGRect(x: 0, y: -v.frame.height, width: v.frame.width, height: v.frame.height)
                    }
                    v.alpha = 0
                }, completion: { b in
                    
                    if let index = windows.index(where: { (item) -> Bool in
                        return item == window
                    }) {
                        windows.remove(at: index)
                    }
                })
            }
            
        }
    }
    
}
