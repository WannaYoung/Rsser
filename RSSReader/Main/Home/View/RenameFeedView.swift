//
//  RenameFeedView.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/21.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import FeedKit
import SwiftMessages

class RenameFeedView: MessageView {
    
    var renameFeedSuccess: ((_ newName: String) -> Void)?

    @IBOutlet weak var newNameTF: UITextField!
    
    override func awakeFromNib() {
        initSubviews()
    }
    
    func initSubviews() {
        newNameTF.addPaddingLeft(15.0)
        newNameTF.becomeFirstResponder()
    }
    
    @IBAction func renameFeed(_ sender: UIButton) {
        guard newNameTF.text != "" else {
            return
        }
        SwiftMessages.hideAll()
        renameFeedSuccess?(newNameTF.text!)
    }
    
    @IBAction func closeRenameFeed(_ sender: UIButton) {
        SwiftMessages.hideAll()
    }
    
}
