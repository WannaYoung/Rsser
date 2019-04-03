//
//  NoticeTool.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/19.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import SwiftMessages

class NoticeTool: NSObject {
    class func noticeWith(theme: Theme = .warning, layout: MessageView.Layout = .cardView, style: SwiftMessages.PresentationStyle = .top, duration: TimeInterval = 0, title: String = "", content: String, buttonTitle: String = "") {
        let notice = MessageView.viewFromNib(layout: layout)
        notice.configureTheme(theme)
        notice.configureContent(title: title, body: content)
        notice.button?.isHidden = buttonTitle == ""
        notice.button?.setTitle(buttonTitle, for: .normal)
        var noticeConfig = SwiftMessages.defaultConfig
        noticeConfig.presentationStyle = style
        noticeConfig.duration = duration == 0 ? .forever : .seconds(seconds: duration)
        noticeConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: noticeConfig, view: notice)
    }
}
