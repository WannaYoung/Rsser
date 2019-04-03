//
//  PreferenceController.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/20.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

class PreferenceController: UITableViewController {
   
    var enableTouchID = false
    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchIDSwitch.isOn = UserDefaults.standard.bool(forKey: "touchid")
        enableTouchID = UserDefaults.standard.bool(forKey: "touchid")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func setTouchID(_ sender: UISwitch) {
        let touchIDAuth = TouchID()
        touchIDAuth.touchIDReasonString = "轻触Home键验证指纹"
        touchIDAuth.delegate = self
        touchIDAuth.touchIDAuthentication()
    }
    
}

extension PreferenceController: TouchIDDelegate {
    
    func touchIDAuthenticationWasSuccessful() {
        enableTouchID = !enableTouchID
        UserDefaults.standard.set(enableTouchID, forKey: "touchid")
    }
    
    func touchIDAuthenticationFailed(_ errorCode: TouchIDErrorCode) {
        touchIDSwitch.isOn = !touchIDSwitch.isOn
    }
}
