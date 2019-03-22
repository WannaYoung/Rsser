//
//  FeedTool.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/19.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

class FeedTool: NSObject {
    public class func getFaviconLink(urlString: String) -> String {
        let scheme = URL(string: urlString)?.scheme
        let hostUrl = URL(string: urlString)?.host
        let iconUrl = URL(string: scheme!+"://"+hostUrl!+"/favicon.ico")
        return iconUrl?.absoluteString ?? ""
    }
}
