//
//  RealmConfig.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/19.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import RealmSwift

let myFeedConfig = Realm.Configuration(fileURL: Bundle.main.url(forResource: "MyFeed", withExtension: "realm"))
