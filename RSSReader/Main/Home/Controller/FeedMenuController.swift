//
//  AddFeedController.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/14.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import FeedKit

protocol AddFeedDelegate {
    func addFeedDidSelected(selectIndex: Int)
}

class FeedMenuController: UIViewController {
    
    var delegate: AddFeedDelegate?
    let titles = ["添加订阅", "新建文件夹", "导入OPML文件"]
    let itemNames = ["item_link", "item_fold", "item_opml"]
    let descs = ["类型的为URL的RSS订阅", "使用文件夹对RSS订阅分类", "其他来源的OPML订阅集合"]

    override func viewDidLoad() {
        super.viewDidLoad()

        initSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        backButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1800)
        }
        backButton.isHidden = false
    }
    
    func initSubviews() {
        view.addSubview(addFeedTable)
        view.backgroundColor = UIColor.clear
        view.insertSubview(backButton, belowSubview: addFeedTable)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.01) {
            self.openPanelAnimation()
        }
    }
    
    lazy var addFeedTable = UITableView(frame: CGRect(x: UIDevice.width-65, y: UIDevice.height-65, width: 50, height: 50)).then {
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 25
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = UIColor.background
    }
    
    lazy var backButton: UIButton = {
        let tempButton: UIButton = UIButton(type: .custom)
        tempButton.isHidden = true
        tempButton.backgroundColor = UIColor.hex("000000", alpha: 0.45)
        tempButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return tempButton
    }()
    
    @objc func tapBack(index: Int, tapTable: Bool = false) {
        UIView.animate(withDuration: 0.1, animations: {
            self.addFeedTable.layer.cornerRadius = 25
            self.addFeedTable.frame = CGRect(x: UIDevice.width-65, y: UIDevice.height-65, width: 50, height: 50)
        }) { (animation) in
            self.backButton.alpha = 0.0
            self.dismiss(animated: false, completion: {
                tapTable ? self.delegate?.addFeedDidSelected(selectIndex: index) : nil
            })
        }
    }
    
    func openPanelAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.addFeedTable.layer.cornerRadius = 15
            self.addFeedTable.frame = CGRect(x: UIDevice.width-265, y: UIDevice.height-225, width: 250, height: 210)
        }
    }
    
}

extension FeedMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifier = "addfeed"
        let cell = AddFeedCell(style: .default, reuseIdentifier: indentifier)
        cell.titleLabel.text = titles[indexPath.row]
        cell.logoImage.image = UIImage(named: itemNames[indexPath.row])
        cell.descLabel.text = descs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapBack(index: indexPath.row, tapTable: true)
    }
    
}
