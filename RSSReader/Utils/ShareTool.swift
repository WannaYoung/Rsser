//
//  ShareTool.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/21.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

class ShareTool: NSObject {
    public class func shareWith(controller: UIViewController, title: String, urlString: String) {
        let feedName = title
        let feedUrl = URL(string: urlString)
        let items = [feedName, feedUrl!] as [Any]
        let shareVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        shareVC.completionWithItemsHandler =  { activity, success, items, error in
            
        }
        controller.present(shareVC, animated: true, completion: { })
    }
}
