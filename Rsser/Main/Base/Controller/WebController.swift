//
//  WebController.swift
//  ATF
//
//  Created by 王洋 on 2018/8/1.
//  Copyright © 2018年 yang. All rights reserved.
//

import UIKit
import WebKit

private let estimatedProgressKeyPath = "estimatedProgress"


/// An instance of `WebController` displays interactive web content.
open class WebController: UIViewController {
    // MARK: Properties
    var webIsPresent: Bool = false
    /// Returns the web view for the controller.
    public final var webView: WKWebView {
        get {
            return _webView
        }
    }
    
    /// Returns the progress view for the controller.
    public final var progressBar: UIProgressView {
        get {
            return _progressBar
        }
    }
    
    /// The URL request for the web view. Upon setting this property, the web view immediately begins loading the request.
    public final var urlRequest: URLRequest {
        didSet {
            webView.load(urlRequest)
        }
    }
    
    
    
    // MARK: Private properties
    
    private final let configuration: WKWebViewConfiguration
    private final let activities: [UIActivity]?
    
    private lazy final var _webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        webView.allowsBackForwardNavigationGestures = true
        if #available(iOS 9.0, *) {
            webView.allowsLinkPreview = true
        }
        return webView
    }()
    
    private lazy final var _progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.backgroundColor = .clear
        progressBar.progressTintColor = UIColor.main
        progressBar.trackTintColor = UIColor.clear
        return progressBar
    }()
    
    // MARK: Initialization
    
    /**
     Constructs a new `WebController`.
     
     - parameter urlRequest:    The URL request for the web view to load.
     - parameter configuration: The configuration for the web view.
     - parameter activities:    The custom activities to display in the `UIActivityViewController` that is presented when the action button is tapped.
     
     - returns: A new `WebController` instance.
     */
    public init(urlRequest: URLRequest, configuration: WKWebViewConfiguration = WKWebViewConfiguration(), activities: [UIActivity]? = nil) {
        self.configuration = configuration
        self.urlRequest = urlRequest
        self.activities = activities
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     Constructs a new `WebController`.
     
     - parameter url: The URL to display in the web view.
     
     - returns: A new `WebController` instance.
     */
    public convenience init(url: URL, _ isPresent: Bool = false) {
        self.init(urlRequest: URLRequest(url: url))
        self.webIsPresent = isPresent
    }
    
    /// :nodoc:
    public required init?(coder aDecoder: NSCoder) {
        self.configuration = WKWebViewConfiguration()
        self.urlRequest = URLRequest(url: URL(string: "http://")!)
        self.activities = nil
        super.init(coder: aDecoder)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: estimatedProgressKeyPath, context: nil)
    }
    
    
    // MARK: View lifecycle
    
    /// :nodoc:
    open override func viewDidLoad() {
        super.viewDidLoad()
        if title == "" || title == nil {
            title = urlRequest.url?.host
        }
        view.addSubview(_webView)
        view.addSubview(_progressBar)
        
        if webIsPresent {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                               target: self,
                                                               action: #selector(didTapDoneButton(_:)))
        }
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "item_share"), style: .plain, target: self, action: #selector(didTapActionButton(_:)))
        
        webView.load(urlRequest)
    }
    
    /// :nodoc:
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        assert(navigationController != nil, "\(WebController.self) must be presented in a \(UINavigationController.self)")
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /// :nodoc:
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
    }
    
    /// :nodoc:
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        
        let isIOS11 = ProcessInfo.processInfo.isOperatingSystemAtLeast(
            OperatingSystemVersion(majorVersion: 11, minorVersion: 0, patchVersion: 0))
        let top = isIOS11 ? CGFloat(0.0) : topLayoutGuide.length
        let insets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        webView.scrollView.contentInset = insets
        webView.scrollView.scrollIndicatorInsets = insets
        
        view.bringSubviewToFront(progressBar)
        progressBar.frame = CGRect(x: view.frame.minX,
                                   y: topLayoutGuide.length,
                                   width: view.frame.size.width,
                                   height: 2)
    }
    
    
    // MARK: Actions
    
    @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapActionButton(_ sender: UIBarButtonItem) {
        if let url = urlRequest.url {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: activities)
            activityVC.popoverPresentationController?.barButtonItem = sender
            present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    // MARK: KVO
    
    /// :nodoc:
    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        guard let theKeyPath = keyPath , object as? WKWebView == webView else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if theKeyPath == estimatedProgressKeyPath {
            updateProgress()
        }
    }
    
    // MARK: Private
    
    private final func updateProgress() {
        let completed = webView.estimatedProgress == 1.0
        progressBar.setProgress(completed ? 0.0 : Float(webView.estimatedProgress), animated: !completed)
        UIApplication.shared.isNetworkActivityIndicatorVisible = !completed
    }
}
