//
//  TableViewExtension.swift
//  SwiftExtension
//
//  Created by 王洋 on 2019/1/24.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func reloadedData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    public func removeTableFooterView() {
        tableFooterView = nil
    }
    
    public func removeTableHeaderView() {
        tableHeaderView = nil
    }
    
    public func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    public func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
}
