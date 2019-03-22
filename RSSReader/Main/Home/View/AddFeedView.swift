//
//  AddFeedView.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/19.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import FeedKit
import SwiftMessages

class AddFeedView: MessageView {
    
    var addFeedSuccess: (() -> Void)?
    @IBOutlet weak var rssLinkTF: UITextField!
    
    override func awakeFromNib() {
        initSubviews()
    }
    
    func initSubviews() {
        rssLinkTF.addPaddingLeft(15.0)
        rssLinkTF.becomeFirstResponder()
    }
    
    func parseFeed() {
        FeedManager.share.parseWith(feedUrl: URL(string: rssLinkTF.text!)!, successFeed:  { (feedType, result) in
            DispatchQueue.main.async {
                let newFeed = MyFeed()
                newFeed.setupWith(feedUrl: self.rssLinkTF.text!, feedType: feedType, result: result)
                SwiftMessages.hideAll()
                self.addFeedSuccess?()
            }
        })
    }
    
    @IBAction func addFeed(_ sender: UIButton) {
        guard rssLinkTF.text != "" else {
            return
        }
        guard (rssLinkTF.text?.isValidUrl)! else {
            return
        }
        parseFeed()
    }
    
    @IBAction func closeAddFeed(_ sender: UIButton) {
        SwiftMessages.hideAll()
    }
    
}
