//
//  AuthIDController.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/20.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

class AuthIDController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authTouchID()
    }
    
    func authTouchID() {
        let touchIDAuth = TouchID()
        touchIDAuth.touchIDReasonString = "轻触Home解锁RSS阅读"
        touchIDAuth.delegate = self
        touchIDAuth.touchIDAuthentication()
    }
}

extension AuthIDController: TouchIDDelegate {
    
    func touchIDAuthenticationWasSuccessful() {
        dismiss(animated: false) { }
    }
    
    func touchIDAuthenticationFailed(_ errorCode: TouchIDErrorCode) {
        
    }
}
