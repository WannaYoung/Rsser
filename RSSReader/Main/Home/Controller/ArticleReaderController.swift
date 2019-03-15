//
//  ArticleReaderController.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/15.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import WebKit

class ArticleReaderController: UIViewController {
    var articleHtml: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func initSubviews() {
        view.addSubview(webView)
        webView.loadHTMLString(articleHtml, baseURL: nil)
    }
    
    lazy var webView: WKWebView = {
        let tempWeb: WKWebView = WKWebView(frame: view.bounds)
        tempWeb.backgroundColor = UIColor.white
        tempWeb.evaluateJavaScript("", completionHandler: { (result, error) in
            
        })
        return tempWeb
    }()
    
}
