//
//  NetworkHelper.swift
//  ATF
//
//  Created by yang on 2018/6/22.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit

class NetworkHelper: NSObject {

    public class func networkPrint(host: String, request: [String: Any], response: Any) {
        print("🌎🌎HOST🌎🌎\n\(host)\n🔺🔺REQUEST🔺🔺\n\(request)\n🔻🔻RESPONSE🔻🔻\n\(response)")
    }
    
}
