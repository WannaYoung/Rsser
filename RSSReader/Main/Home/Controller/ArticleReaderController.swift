//
//  ArticleReaderController.swift
//  RSSReader
//
//  Created by 王洋 on 2019/3/15.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import WebKit
import FeedKit
import DTCoreText

class ArticleReaderController: UIViewController {
    
    var feedType = ""
    var rssItem: RSSFeedItem = RSSFeedItem()
    var atomEntry: AtomFeedEntry = AtomFeedEntry()

    var hidingManager: HidingManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
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
    
    func initSubviews() {
        view.addSubview(readerView)
        
        readerView.attributedString = getAttributedStringWith(html: feedType == "atom" ? atomEntry.content?.value ?? "" : rssItem.description ?? "")
        hidingManager = HidingManager(viewController: self, scrollView: readerView)
    }
    
    override func viewDidLayoutSubviews() {
        hidingManager?.viewDidLayoutSubviews()
        readerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(0)
            }
        }
    }
    
    lazy var readerView: DTAttributedTextView = DTAttributedTextView().then {
        $0.textDelegate = self
        $0.backgroundColor = UIColor.background
        $0.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func getAttributedStringWith(html: String) -> NSAttributedString {
        let htmlData = html.data(using: .utf8)
        let options = [
            NSTextSizeMultiplierDocumentOption : NSNumber(value: 1.0),
            DTDefaultFontFamily : "Times New Roman",
            DTDefaultLinkColor : "purple",
            DTDefaultLinkHighlightColor : "red",
            DTDefaultFontSize: "18",
            DTDefaultTextAlignment: "left",
            DTDefaultLineHeightMultiplier: "1.6"
            ] as [String : Any]
        let attributedString = NSAttributedString(htmlData: htmlData, options: options , documentAttributes: nil)
        return attributedString!
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingManager?.shouldScrollToTop()
        return true
    }
    
}

extension ArticleReaderController: DTAttributedTextContentViewDelegate {
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if (attachment is DTImageTextAttachment) {
            let imageView = DTLazyImageView(frame: frame)
            imageView.delegate = self
            imageView.image = (attachment as! DTImageTextAttachment).image
            imageView.url = attachment.contentURL
            if let attachmentUrl = attachment!.hyperLinkURL {
                imageView.isUserInteractionEnabled = true
                let button = DTLinkButton(frame: imageView.bounds)
                button.url = attachmentUrl
                button.minimumHitSize = CGSize(width: 25, height: 25)
                button.guid = attachment.hyperLinkGUID
                imageView.addSubview(button)
            }
            
            return imageView
        }
        return nil
    }
}

extension ArticleReaderController: DTLazyImageViewDelegate {
    func lazyImageView(_ lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        let url: URL? = lazyImageView.url
        let imageSize: CGSize = size
        var pred: NSPredicate? = nil
        if let url = url {
            pred = NSPredicate(format: "contentURL == %@", url as CVarArg)
        }
        var didUpdate = false
        
        for oneAttachment in readerView.attributedTextContentView.layoutFrame.textAttachments(with: pred) {
            if (oneAttachment as! DTTextAttachment).originalSize.equalTo(CGSize.zero) {
                let sizeWidth: CGFloat = UIScreen.main.bounds.size.width
                (oneAttachment as! DTTextAttachment).originalSize = CGSize(width: sizeWidth - 30, height: (sizeWidth - 30) * imageSize.height / imageSize.width)
                didUpdate = true
            }
        }
        
        if didUpdate {
            DispatchQueue.main.async(execute: {
                self.readerView.relayoutText()
            })
        }
        
    }
}
