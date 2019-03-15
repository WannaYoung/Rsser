//
//  AddFeedCell.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/14.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import SnapKit

class AddFeedCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        selectionStyle = .none
        backgroundColor = UIColor.background
        addSubview(logoImage)
        addSubview(titleLabel)
        addSubview(descLabel)
    }
    
    override func layoutSubviews() {
        logoImage.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.width.equalTo(25)
            make.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.top)
            make.left.equalTo(logoImage.snp.right).offset(10)
            make.right.equalTo(-15)
            make.height.equalTo(logoImage.snp.height)
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        }
    }
    
    lazy var logoImage: UIImageView = {
        let tempImage: UIImageView = UIImageView()
        tempImage.contentMode = .scaleAspectFit
        return tempImage
    }() //图标
    
    lazy var titleLabel: UILabel = {
        let tempLabel: UILabel = UILabel(textColor: UIColor.mainText, font: UIFont.scMediumFont(size: 18), aligment: .left)
        return tempLabel
    }() //标题
    
    lazy var descLabel: UILabel = {
        let tempLabel: UILabel = UILabel(textColor: UIColor.assistText, font: UIFont.scRegularFont(size: 13), aligment: .left)
        return tempLabel
    }() //描述
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
