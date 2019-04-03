//
//  FoldListView.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/21.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import FeedKit
import RealmSwift
import SwiftMessages

class FoldListView: MessageView {
    
    var foldFeeds: Results<MyFeed>?
    var didSelectFold: ((_ foldID: String) -> Void)?
    @IBOutlet weak var foldListTable: UITableView!
    
    override func awakeFromNib() {
        initSubviews()
    }
    
    func initSubviews() {
        foldListTable.separatorStyle = .none
    }

}

extension FoldListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foldFeeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foldFeed = foldFeeds?[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "foldlist")
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage(named: "icon_fold")
        cell.textLabel?.font = UIFont.scMediumFont(size: 16)
        cell.textLabel?.textColor = UIColor.mainText
        cell.textLabel?.text = "  " + (foldFeed?.alias ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foldFeed = foldFeeds?[indexPath.row]
        didSelectFold?(foldFeed?.key ?? "")
        SwiftMessages.hideAll()
    }
    
}
