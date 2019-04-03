//
//  ArticleReaderController.swift
//  Rsser
//
//  Created by 王洋 on 2019/3/15.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit
import AVKit
import WebKit
import FeedKit
import DTCoreText
import SKPhotoBrowser

class ArticleReaderController: UIViewController, UIGestureRecognizerDelegate {
    
    var feedType = ""
    var feedTitle = ""
    var rssItem: RSSFeedItem = RSSFeedItem()
    var atomEntry: AtomFeedEntry = AtomFeedEntry()
    var articleImages = [SKPhoto]()
    var urlForVideo = [URL: AVPlayerViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func initSubviews() {
        view.addSubview(readerView)
        let title = feedType == "atom" ? atomEntry.title ?? "" : rssItem.title ?? ""
        let auther = feedType == "atom" ? (atomEntry.authors?.first?.name ?? feedTitle)+(atomEntry.published?.string(format: "yyyyd年MM月dd日 HH:mm", timeZone: .china) ?? "") : (rssItem.author ?? feedTitle)+(rssItem.pubDate?.string(format: "yyyyd年MM月dd日 HH:mm", timeZone: .china) ?? "") 
        let titleHtml = String(format: "<p style=\"font-size:5px\">\n</p><h2>%@</h2><p>%@</p>", title, auther)
        readerView.attributedString = getAttributedStringWith(html: feedType == "atom" ? titleHtml + (atomEntry.content?.value ?? "") : titleHtml + (rssItem.description ?? ""))
    }
    
    override func viewDidLayoutSubviews() {
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
    
    @objc func openReaderLink(linkButton: DTLinkButton) {
        let webVC = WebController(url: linkButton.url)
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
}

extension ArticleReaderController: DTAttributedTextContentViewDelegate {
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor string: NSAttributedString!, frame: CGRect) -> UIView! {
        var attributes = string.attributes(at: 0, effectiveRange: nil)
        let URL = attributes[NSAttributedString.Key(DTLinkAttribute)] as? URL
        let identifier = attributes[NSAttributedString.Key(DTGUIDAttribute)] as? String

        let button = DTLinkButton(frame: frame)
        button.url = URL
        button.minimumHitSize = CGSize(width: 25, height: 25)
        button.guid = identifier
        button.addTarget(self, action: #selector(openReaderLink(linkButton:)), for: .touchUpInside)
        return button
    }
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment is DTImageTextAttachment {
            let imageView = DTLazyImageView(frame: frame)
            imageView.delegate = self
            imageView.isUserInteractionEnabled = true
            imageView.image = (attachment as! DTImageTextAttachment).image
            imageView.url = attachment.contentURL
            if imageView.url.absoluteString.hasSuffix("gif") {
                DispatchQueue.global(qos: .default).async(execute: {
                    var gifData: Data? = nil
                    if let contentURL = attachment.contentURL {
                        gifData = try? Data(contentsOf: contentURL)
                    }
                    DispatchQueue.main.async(execute: {
                        imageView.image = DTAnimatedGIFFromData(gifData)
                    })
                })
            }
            var needAdd = true
            for articleImage in articleImages {
                if articleImage.photoURL == attachment.contentURL.absoluteString {needAdd = false }
            }
            if needAdd {
                let photo = SKPhoto.photoWithImageURL(imageView.url.absoluteString)
                photo.shouldCachePhotoURLImage = true
                articleImages.append(photo)
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPhotoBrowser(gesture:)))
            imageView.addGestureRecognizer(tapGesture)
            return imageView
        }
        if attachment is DTVideoTextAttachment {
            for videoUrl in urlForVideo.keys {
                if videoUrl == attachment.contentURL {
                    return urlForVideo[videoUrl]?.view
                }
            }
            let player = AVPlayer(url: attachment.contentURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            playerViewController.view.frame = frame
            playerViewController.view.backgroundColor = UIColor.darkGray
            self.urlForVideo[attachment.contentURL] = playerViewController
            return playerViewController.view
        }
        return nil
    }
    
    @objc func openPhotoBrowser(gesture: UITapGestureRecognizer) {
        let browser = SKPhotoBrowser(photos: articleImages)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
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
