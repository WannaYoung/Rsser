//
//  UITextFieldExtension.swift
//  JayPal
//
//  Created by yang on 2018/7/2.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit

// MARK: - Initialization
extension UITextField {
    
    /// UITextField初始化
    ///
    /// - Parameters:
    ///   - frame: 输入框frame
    ///   - placeholder: 输入框提示语
    ///   - textColor: 输入文本颜色
    ///   - holderColor: 提示文本颜色
    ///   - font: 文本字体
    public convenience init(_ frame: CGRect = CGRect.zero, placeholder: String, textColor: UIColor = UIColor.black, holderColor: UIColor = UIColor.lightGray, font: UIFont) {
        self.init(frame: frame)
        self.font = font
        self.tintColor = UIColor.black
        self.placeholder = placeholder
        self.textColor = textColor
        self.returnKeyType = .done
        self.setPlaceholderTextColor(holderColor)
    }
    
}

// MARK: - Properties
extension UITextField {
    
    // 是否为空
    public var isEmpty: Bool {
        return text?.isEmpty == true
    }
    
    // 纯文本内容
    public var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

// MARK: - Methods
extension UITextField {
    
    // 清除内容
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    // 设置Placeholder文字颜色
    public func setPlaceholderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    // 添加左边距
    public func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    // 添加左边icon
    public func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        leftView = imageView
        leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        leftViewMode = .always
    }
    
}
