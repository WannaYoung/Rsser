//
//  ArticleListController.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/19.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import FeedKit
import SwipeCellKit

class ArticleListController: UIViewController {
    
    @IBOutlet weak var articleListTable: UITableView!
    
    var feed: MyFeed = MyFeed()
    var rssFeed: RSSFeed = RSSFeed()
    var atomFeed: AtomFeed = AtomFeed()
    var hidingManager: HidingManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
        parserFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingManager?.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingManager?.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
//        hidingManager?.viewDidLayoutSubviews()
    }
    
    func initSubviews() {
        view.backgroundColor = UIColor.background
        articleListTable.estimatedRowHeight = 60
        articleListTable.rowHeight = UITableView.automaticDimension
        hidingManager = HidingManager(viewController: self, scrollView: articleListTable)
    }
    
    func parserFeed()  {
        UIWindow.current.pleaseWait()
        let parser = FeedParser(URL: URL(string: feed.url)!)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            UIWindow.current.clearAllNotice()
            guard result.isSuccess else { return }
            if let feed = result.rssFeed {
                self.rssFeed = feed
            }
            if let feed = result.atomFeed {
                self.atomFeed = feed
            }
            DispatchQueue.main.async {
                self.articleListTable.reloadData()
            }
        }
    }
    
    func addAnimation() {
        for (index, cell) in articleListTable.visibleCells.enumerated() {
            cell.frame.origin.y = articleListTable.bounds.size.height
            UIView.animate(withDuration: 0.8, delay: 0.02 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.frame.origin.y = 0
            }, completion: nil)
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingManager?.shouldScrollToTop()
        return true
    }
}

extension ArticleListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.type == "atom" ? atomFeed.entries?.count ?? 0 : rssFeed.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
        UIView.animate(withDuration: 0.3) {
            cell.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        let logoImage: UIImageView = cell.viewWithTag(20) as! UIImageView
        let sourceLabel: UILabel = cell.viewWithTag(21) as! UILabel
        let titleLabel: UILabel = cell.viewWithTag(22) as! UILabel
        let descLabel: UILabel = cell.viewWithTag(23) as! UILabel
        let dateLabel: UILabel = cell.viewWithTag(24) as! UILabel
        sourceLabel.text = feed.type == "atom" ? atomFeed.title ?? "" : rssFeed.title ?? ""
        titleLabel.text = feed.type == "atom" ? atomFeed.entries![indexPath.row].title?.trimmed : rssFeed.items![indexPath.row].title
        descLabel.text = feed.type == "atom" ? atomFeed.entries![indexPath.row].summary?.value?.trimmed : rssFeed.items![indexPath.row].description
        dateLabel.text = feed.type == "atom" ? atomFeed.entries![indexPath.row].published?.string(format: "MM-dd HH:mm", timeZone: .china) : rssFeed.items![indexPath.row].pubDate?.string(format: "MM-dd HH:mm", timeZone: .china)
        logoImage.kf.setImage(with: URL(string: feed.faviconLink), placeholder: UIImage(named: "logo") )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleReaderVC = ArticleReaderController()
        articleReaderVC.feedType = feed.type
        articleReaderVC.feedTitle = feed.type == "atom" ? atomFeed.title ?? ""  : rssFeed.title ?? ""
        if feed.type == "atom" {
            articleReaderVC.atomEntry = atomFeed.entries![indexPath.row]
        } else {
            articleReaderVC.rssItem = rssFeed.items![indexPath.row]
        }
        articleReaderVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(articleReaderVC, animated: true)
    }
    
}

extension ArticleListController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        return addFeedAction(index: indexPath.row)
    }
    
    func addFeedAction(index: Int) -> [SwipeAction] {
        let titleString = self.feed.type == "atom" ? self.atomFeed.entries?[index].title ?? "" : self.rssFeed.items?[index].title ?? ""
        let urlString = self.feed.type == "atom" ? self.atomFeed.entries?[index].links?.first?.attributes?.href ?? "" : self.rssFeed.items?[index].link ?? ""
        
        let browserAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            let webVC = WebController(url: URL(string: urlString.trimmed)!)
            webVC.title = titleString
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        let shareAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            ShareTool.shareWith(controller: self, title: titleString, urlString: urlString)
        }
        browserAction.image = UIImage(named: "edit_browser")
        shareAction.image = UIImage(named: "edit_share")
        [browserAction, shareAction].forEach { (swipeAction) in
            swipeAction.backgroundColor = UIColor.background
            swipeAction.hidesWhenSelected = true
        }
        return [shareAction, browserAction]
    }
}

