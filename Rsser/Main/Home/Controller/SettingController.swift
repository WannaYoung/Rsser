//
//  SettingController.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/15.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import SwiftMessages

class SettingController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
}
