//
//  TouchID.swift
//
//  Created by Gabriel Theodoropoulos.
//  Copyright (c) 2014 Gabriel Theodoropoulos. All rights reserved.
//
//  E-mail:     gabrielth.devel@gmail.com
//  Website:    http://gtiapps.com
//  Google+:    http://plus.google.com/+GabrielTheodoropoulos
//

import UIKit
import LocalAuthentication


enum TouchIDErrorCode {
    case touchID_AuthenticationFailed   // When the authentication fails (e.g. wrong finger)
    case touchID_PasscodeNotSet         // No passcode was set in the device's Settings
    case touchID_CanceledByTheSystem    // The system cancels the authentication because another app became active
    case touchID_TouchIDNotAvailable    // The TouchID authentication mechanism is not supported by the device
    case touchID_TouchIDNotEnrolled     // The TouchID authentication is supported but no finger was enrolled
    case touchID_CanceledByTheUser      // The user cancels the authentication
    case touchID_UserFallback           // The user selects to fall back to a custom authentication method
}


protocol TouchIDDelegate{
    
    func touchIDAuthenticationWasSuccessful();
    
    func touchIDAuthenticationFailed(_ errorCode: TouchIDErrorCode);
}


class TouchID: NSObject {
   
    var delegate : TouchIDDelegate!
    
    var touchIDReasonString : String?
    
    
    func touchIDAuthentication(){
        // Get the local authentication context.
        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        var reasonString = "Authentication is needed to access this application."
        if let reason = touchIDReasonString {
            reasonString = reason
        }
        
        var customErrorCode : TouchIDErrorCode?
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, evalPolicyError) in
                if success {
                    // This is the case of a successful authentication.
                    OperationQueue.main.addOperation({ () -> Void in
                        self.delegate.touchIDAuthenticationWasSuccessful()
                    })
                }
                else{
                    // This is the case of a failed authentication.
                    switch (evalPolicyError as! LAError).errorCode {
                        
                    case LAError.Code.systemCancel.rawValue:
                        customErrorCode = .touchID_CanceledByTheSystem
                        
                    case LAError.Code.userCancel.rawValue:
                        customErrorCode = .touchID_CanceledByTheUser
                        
                    case LAError.Code.userFallback.rawValue:
                        customErrorCode = .touchID_UserFallback
                        
                    default:
                        customErrorCode = .touchID_AuthenticationFailed
                    }
                    OperationQueue.main.addOperation({ () -> Void in
                        self.delegate.touchIDAuthenticationFailed(customErrorCode!)
                    })
                }
            })
            
        }
        else{
            // The policy cannot be evaluated.
            switch error!.code{
            case LAError.Code.touchIDNotEnrolled.rawValue:
                customErrorCode = .touchID_TouchIDNotEnrolled
            case LAError.Code.passcodeNotSet.rawValue:
                customErrorCode = .touchID_PasscodeNotSet
            default:
                customErrorCode = .touchID_TouchIDNotAvailable
            }
            delegate.touchIDAuthenticationFailed(customErrorCode!)
        }
    }
    
}
