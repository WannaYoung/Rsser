//
//  UILabelExtension.swift
//  KLine
//
//  Created by yang on 2018/6/14.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(_ frame: CGRect = CGRect.zero, text: String = "", textColor: UIColor = UIColor.white, font: UIFont, aligment: NSTextAlignment = .left) {
        self.init(frame: frame)
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = aligment
    }
    
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
}
