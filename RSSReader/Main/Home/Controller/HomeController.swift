//
//  HomeController.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/14.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftMessages
import RealmSwift
import SwipeCellKit

class HomeController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var foldTitle: UILabel!
    
    var currentFoldID = ""
    let realm = try! Realm()
    var feedList: Results<MyFeed>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
        realmUpdate()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func initSubviews() {
        if UserDefaults.standard.bool(forKey: "touchid") {
            let authVC = AuthIDController()
            UIViewController.current().present(authVC, animated: false) { }
        }
        
        view.backgroundColor = UIColor.background
        feedTable.estimatedRowHeight = 50
        tableHeader.frame = CGRect(x: 0, y: 0, width: UIDevice.width, height: 0.0)
        addButton.addShadow(color: UIColor.mainText, radius: 15, opacity: 0.3, rect: CGRect(x: 15, y: 15, width: 30, height: 30))
    }
    
    @IBAction func addFeed(_ sender: UIButton) {
        UIDevice.impactWith(style: .light)
        let addFeedVC = FeedMenuController()
        navigationController?.definesPresentationContext = true
        addFeedVC.modalPresentationStyle = .overCurrentContext
        addFeedVC.delegate = self
        navigationController?.present(addFeedVC, animated: false, completion: { })
    }
    
    @IBAction func foldGoBack(_ sender: UIButton) {
        currentFoldID = ""
        realmUpdate()
        tableHeader.frame = CGRect(x: 0, y: 0, width: UIDevice.width, height: 0.0)
    }
    
    
}

extension HomeController: UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedList?[indexPath.row].type == "fold" ? 50 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myFeed = feedList?[indexPath.row]
        if myFeed?.type == "fold" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fold", for: indexPath) as! SwipeTableViewCell
            cell.delegate = self
            let titleLabel: UILabel = cell.viewWithTag(20) as! UILabel
            titleLabel.text = myFeed?.alias
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "feed", for: indexPath) as! SwipeTableViewCell
            cell.delegate = self
            let logoImage: UIImageView = cell.viewWithTag(10) as! UIImageView
            let titleLabel: UILabel = cell.viewWithTag(11) as! UILabel
            let descLabel: UILabel = cell.viewWithTag(12) as! UILabel
            titleLabel.text = myFeed?.alias
            descLabel.text = myFeed?.subtitle
            logoImage.kf.setImage(with: URL(string: (myFeed?.faviconLink)!), placeholder: UIImage(named: "logo") )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myFeed = feedList?[indexPath.row]
        if myFeed?.type == "fold" {
            currentFoldID = myFeed?.key ?? ""
            foldTitle.text = myFeed?.alias ?? ""
            tableHeader.frame = CGRect(x: 0, y: 0, width: UIDevice.width, height: 40.0)
            self.realmUpdate()
        } else {
            let articleListVC: ArticleListController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "articlelist") as! ArticleListController
            articleListVC.hidesBottomBarWhenPushed = true
            articleListVC.feed = feedList![indexPath.row]
            self.navigationController?.pushViewController(articleListVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let myFeed = feedList?[indexPath.row]
        if orientation == .left && myFeed?.type == "fold" { return [] }
        return addFeedAction(index: indexPath.row, orientation: orientation)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        let myFeed = feedList?[indexPath.row]
        var options = SwipeOptions()
        options.minimumButtonWidth = myFeed?.type == "fold" ? 50 : UIDevice.width/5
        return options
    }
    
    func addFeedAction(index: Int, orientation: SwipeActionsOrientation) -> [SwipeAction] {
        let myFeed = feedList?[index]
        let renameAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.renameFeed(index: indexPath.row)
        }
        let foldAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.moveToFold(index: indexPath.row)
        }
        let copyAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            UIPasteboard.general.string = myFeed?.url
        }
        let shareAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            ShareTool.shareWith(controller: self, title: myFeed?.name ?? "", urlString: myFeed?.url ?? "")
        }
        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.showAlertWith(style: .alert, title: "退订", message: "\n确认退订 “\(myFeed?.name ?? "")”", actionTitles: ["退订"], destructIndex: 0, hasCancel: true, selectAction: { (index) in
                try! self.realm.write {
                    self.realm.delete(myFeed!)
                }
                self.realmUpdate()
            })
        }
        let deleteFoldAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            self.showAlertWith(style: .alert, title: "删除文件夹", message: "\n确认删除 “\(myFeed?.alias ?? "")” 文件夹", actionTitles: ["删除"], destructIndex: 0, hasCancel: true, selectAction: { (index) in
                try! self.realm.write {
                    self.realm.delete(myFeed!)
                }
                self.realmUpdate()
            })
        }
        renameAction.image = UIImage(named: "edit_edit")
        foldAction.image = UIImage(named: "edit_fold")
        copyAction.image = UIImage(named: "edit_copy")
        shareAction.image = UIImage(named: "edit_share")
        deleteAction.image = UIImage(named: "edit_delete")
        deleteFoldAction.image = UIImage(named: "edit_delete")
        [renameAction, foldAction, copyAction, shareAction, deleteAction, deleteFoldAction].forEach { (swipeAction) in
            swipeAction.backgroundColor = UIColor.background
            swipeAction.hidesWhenSelected = true
        }
        if myFeed?.type == "fold" {
            return orientation == .right ? [renameAction, deleteFoldAction].reversed() : [renameAction, deleteFoldAction]
        } else {
            return orientation == .right ? [renameAction, foldAction, copyAction, shareAction, deleteAction].reversed() : [renameAction, foldAction, copyAction, shareAction, deleteAction]
        }
        
    }
    
    func renameFeed(index: Int) {
        let myFeed = feedList?[index]
        let view: RenameFeedView = try! SwiftMessages.viewFromNib()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
        view.backgroundHeight = 260
        view.newNameTF.text = myFeed?.alias
        view.renameFeedSuccess = { newName in
            try! self.realm.write {
                self.realm.create(MyFeed.self, value: ["key": myFeed?.key, "alias": newName], update: true)
            }
            self.realmUpdate()
        }
        SwiftMessages.show(config: config, view: view)
    }
    
    func addFold() {
        let view: AddFoldView = try! SwiftMessages.viewFromNib()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
        view.backgroundHeight = 260
        view.addFoldSuccess = { foldName in
            let foldFeed = MyFeed()
            foldFeed.setupFold(name: foldName)
            self.realmUpdate()
        }
        SwiftMessages.show(config: config, view: view)
    }
    
    func moveToFold(index: Int) {
        let myFeed = feedList?[index]
        let foldFeeds = self.realm.objects(MyFeed.self).filter("type = 'fold'")
        let view: FoldListView = try! SwiftMessages.viewFromNib()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
        view.backgroundHeight = foldFeeds.count > 8 ? 490 : CGFloat(foldFeeds.count)*50+90
        view.foldFeeds = foldFeeds
        view.didSelectFold = { foldID in
            try! self.realm.write {
                self.realm.create(MyFeed.self, value: ["key": myFeed?.key, "fold": foldID], update: true)
            }
            self.realmUpdate()
        }
        SwiftMessages.show(config: config, view: view)
    }
}

extension HomeController: AddFeedDelegate {
    func addFeedDidSelected(selectIndex: Int) {
        switch selectIndex {
        case 0:
            addNewFeed()
        case 1:
            addFold()
        default:
            break
        }
    }
    
    func addNewFeed() {
        let view: AddFeedView = try! SwiftMessages.viewFromNib()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
        view.backgroundHeight = 260
        view.addFeedSuccess = {
            self.realmUpdate()
        }
        SwiftMessages.show(config: config, view: view)
    }
    
    func realmUpdate() {
        let predicate = NSPredicate(format: "fold = %@", currentFoldID)
        feedList = realm.objects(MyFeed.self).filter(predicate)
        feedTable.reloadData()
    }
    
}

class SettingSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomTab)
        messageView.configureNoDropShadow()
        messageView.backgroundHeight = 320.0 + UIDevice.actionBarHeight
        dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
    }
}
