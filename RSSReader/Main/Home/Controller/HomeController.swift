//
//  HomeController.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/14.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import SwiftMessages
import FeedKit

class HomeController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var feedTable: UITableView!
    
    var feedItems: [RSSFeedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
        parserFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func initSubviews() {
        view.backgroundColor = UIColor.background
        addButton.addShadow(color: UIColor.mainText, radius: 15, opacity: 0.3, rect: CGRect(x: 15, y: 15, width: 30, height: 30))
    }
    
    @IBAction func addFeed(_ sender: UIButton) {
        let impactFeedBack = UIImpactFeedbackGenerator(style: .light)
        impactFeedBack.prepare()
        impactFeedBack.impactOccurred()
        
        let addFeedVC = AddFeedController()
        navigationController?.definesPresentationContext = true
        addFeedVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(addFeedVC, animated: false, completion: { })
    }
    
    func parserFeed()  {
        let feedURL = URL(string: "https://sspai.com/feed")
        let parser = FeedParser(URL: feedURL!)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            guard result.isSuccess else { return }
            if let feed = result.rssFeed {
                self.feedItems = feed.items!
                DispatchQueue.main.async {
                    self.feedTable.reloadData()
                }
            }
        }
    }
}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feed", for: indexPath)
        let logoImage: UIImageView = cell.viewWithTag(10) as! UIImageView
        let sourceLabel: UILabel = cell.viewWithTag(11) as! UILabel
        let titleLabel: UILabel = cell.viewWithTag(12) as! UILabel
        let descLabel: UILabel = cell.viewWithTag(13) as! UILabel
        sourceLabel.text = feedItems[indexPath.row].pubDate?.string(format: "MM-dd HH:mm", timeZone: .china)
        titleLabel.text = feedItems[indexPath.row].title
        descLabel.text = feedItems[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleReaderVC = ArticleReaderController()
        articleReaderVC.articleHtml = feedItems[indexPath.row].description!
        articleReaderVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(articleReaderVC, animated: true)
    }
    
}

class SettingSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomTab)
        messageView.configureNoDropShadow()
        messageView.backgroundHeight = 310.0
        dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
    }
}
