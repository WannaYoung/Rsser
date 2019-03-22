//
//  MyFeed.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/19.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import FeedKit
import RealmSwift

class MyFeed: Object {
    @objc dynamic var key = ""
    @objc dynamic var name = ""
    @objc dynamic var alias = ""
    @objc dynamic var url = ""
    @objc dynamic var link = ""
    @objc dynamic var type = ""
    @objc dynamic var fold = ""
    @objc dynamic var subtitle = ""
    @objc dynamic var faviconLink = ""
    @objc dynamic var createTime = Date()
    @objc dynamic var updateTime = Date()

    func setupWith(feedUrl: String, feedType: String, result: Result) {
        if feedType == "atom" {
            let atomFeed = result.atomFeed!
            self.name = atomFeed.title ?? ""
            self.alias = atomFeed.title ?? ""
            self.link = atomFeed.links?.last?.attributes?.href ?? ""
            self.subtitle = atomFeed.subtitle?.value ?? ""
            self.faviconLink = FeedTool.getFaviconLink(urlString: feedUrl)
        }
        if feedType == "rss" {
            let rssFeed = result.rssFeed
            self.name = rssFeed?.title ?? ""
            self.alias = rssFeed?.title ?? ""
            self.link = rssFeed?.link ?? ""
            self.subtitle = rssFeed?.description ?? ""
            self.faviconLink = FeedTool.getFaviconLink(urlString: feedUrl)
        }
        if feedType == "json" {
            let jsonFeed = result.jsonFeed
            self.name = jsonFeed?.title ?? ""
            self.alias = jsonFeed?.title ?? ""
            self.link = jsonFeed?.nextUrl ?? ""
            self.subtitle = jsonFeed?.description ?? ""
            self.faviconLink = jsonFeed?.favicon ?? ""
        }
        self.key = UUID().uuidString
        self.url = feedUrl
        self.type = feedType
        self.createTime = Date()
        self.updateTime = Date()
        
        writeToFile()
    }
    
    func setupFold(name: String) {
        self.key = UUID().uuidString
        self.name = name
        self.alias = name
        self.type = "fold"
        self.createTime = Date()
        self.updateTime = Date()
        
        writeToFile()
    }
    
    func writeToFile() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    override class func primaryKey() -> String? {
        return "key"
    }
}
