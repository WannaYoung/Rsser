//
//  Constans.swift
//  KLine
//
//  Created by yang on 2018/6/4.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit

// MARK: - FUNC
func CONFIG(_ config :String) -> String {
    return Bundle.main.infoDictionary?[config] as! String
}

func JPrint<T>(_ message : T, file : String = #file, lineNumber : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):line:\(lineNumber)]\n\(message)")
    #endif
}
