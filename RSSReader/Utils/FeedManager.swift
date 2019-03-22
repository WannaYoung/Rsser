//
//  FeedManager.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/19.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import FeedKit

class FeedManager: NSObject {
    //单例share
    static let share = FeedManager()
    private override init(){ }
    
    func parseWith(feedUrl: URL, successFeed: @escaping (String, Result) -> Swift.Void, failureFeed: ((NSError) -> Swift.Void)? = nil) {
        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            guard result.isSuccess else { return }
            switch result {
            case .atom(_):
                successFeed("atom", result)
                break
            case .rss(_):
                successFeed("rss", result)
                break
            case .json(_):
//                successFeed("json", result)
                break
            case let .failure(error):
                failureFeed!(error)
                break
            }
        }
    }
}
