//
//  UITextViewExtension.swift
//  SwiftExtension
//
//  Created by 王洋 on 2019/1/28.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

extension UITextView {
    
    // 清除内容
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    // 滚动到底部
    public func scrollToBottom() {
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
    }
    
    // 滚动到顶部
    public func scrollToTop() {
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }
    
    public func wrapToContent() {
        contentInset = UIEdgeInsets.zero
        scrollIndicatorInsets = UIEdgeInsets.zero
        contentOffset = CGPoint.zero
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
    }
    
}
