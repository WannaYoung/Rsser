//
//  AddFoldView.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/21.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import FeedKit
import SwiftMessages

class AddFoldView: MessageView {
    
    var addFoldSuccess: ((_ foldName: String) -> Void)?
    
    @IBOutlet weak var foldNameTF: UITextField!
    
    override func awakeFromNib() {
        initSubviews()
    }
    
    func initSubviews() {
        foldNameTF.addPaddingLeft(15.0)
        foldNameTF.becomeFirstResponder()
    }
    
    @IBAction func addFold(_ sender: UIButton) {
        guard foldNameTF.text != "" else {
            return
        }
        SwiftMessages.hideAll()
        addFoldSuccess?(foldNameTF.text!)
    }
    
    @IBAction func closeAddFold(_ sender: UIButton) {
        SwiftMessages.hideAll()
    }
    
}
