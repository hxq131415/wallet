//
//  TEWebViewController.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/3.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import NJKWebViewProgress

class MRWebViewController: MRBaseViewController {
    
    open var mainWebView: UIWebView = UIWebView(frame: CGRect.zero)
    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    open var webProgress: NJKWebViewProgress = NJKWebViewProgress()
    
    var navTitle: String?
    var url: String?
    var htmlText: String?
    
    private let progressView: UIProgressView = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(title: String?, url: String?, htmlText: String? = nil) {
        self.init(nibName: nil, bundle: nil)
        
        self.navTitle = title
        self.url = url
        self.htmlText = htmlText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xFFFFFF)
        
        if navTitle != nil {
            self.title = navTitle
        }
        else {
            self.title = "加载中..."
        }
        
        self.subViewInitlzation()
        self.progressViewInitlzation()
        self.loadRequestForWebView()
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return false
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func popWithAnimate() {
        
        if mainWebView.canGoBack {
            mainWebView.goBack()
        }
        else {
            super.popWithAnimate()
        }
    }
    
    // MARK: - Initlzations
    func subViewInitlzation() {
        
        self.view.addSubview(mainWebView)
        mainWebView.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainWebView.delegate = webProgress
        mainWebView.scalesPageToFit = false
        mainWebView.scrollView.bouncesZoom = false
        mainWebView.scrollView.zoomScale = 1.0
        mainWebView.allowsInlineMediaPlayback = true
        mainWebView.scrollView.showsHorizontalScrollIndicator = false
        mainWebView.scrollView.showsVerticalScrollIndicator = false
        if #available(iOS 9.0, *) {
            mainWebView.allowsPictureInPictureMediaPlayback = true
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.0, *) {
            mainWebView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        // 去掉WebView底部莫名黑色边
        mainWebView.isOpaque = false
        mainWebView.backgroundColor = UIColor.clear
        
        mainWebView.dataDetectorTypes = .init(rawValue: 0)
        
        self.view.addSubview(loadingView)
        loadingView.snp.remakeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        loadingView.color = UIColorFromRGB(hexRGB: 0xa8a8a8)
        loadingView.hidesWhenStopped = true
        
        webProgress.progressDelegate = self
        webProgress.webViewProxyDelegate = self
    }
    
    func progressViewInitlzation() {
        
        progressView.frame = CGRect(x: 0, y: Sys_Nav_Bar_Height - 2.0, width: Main_Screen_Width, height: 2.0)
        progressView.backgroundColor = UIColor.clear
        progressView.progressTintColor = MRColorManager.LightBlueThemeColor
        if let navigationBar = self.navigationController?.navigationBar {
            if !navigationBar.isHidden {
                navigationBar.addSubview(progressView)
            }
        }
    }
    
    func loadRequestForWebView() {
        
        if url != nil {
            if let webUrl = URL(string: url!) {
                let urlRequest = URLRequest(url: webUrl, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60)
                mainWebView.loadRequest(urlRequest)
            }
        }
        else if htmlText != nil {
            
            mainWebView.loadHTMLString(htmlText!, baseURL: nil)
        }
    }
    
    func startLoadingAnimating() {
        
        loadingView.startAnimating()
    }
    
    func stopLoadingAnimating() {
        
        loadingView.stopAnimating()
    }
    
}

// MARK: - UIWebViewDelegate
extension MRWebViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        self.startLoadingAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // 禁止选择和长按弹框
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none';")
        
        if isNull(str: self.navTitle) {
            self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        }
        
        if htmlText != nil {
            // 修改meta
            let metaJs = "document.getElementsByName(\"viewport\")[0].content = \"width=\(UIScreen.main.bounds.size.width), initial-scale=1.0, viewport-fit=cover, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""
            webView.stringByEvaluatingJavaScript(from: metaJs)
            
            // 调整图片
            let imgJs = "var script = document.createElement('script');" +
                "script.type = 'text/javascript';" +
                "script.text = \"function ResizeImages() {" +
                    "var imgs = document.getElementsByTagName('img');" +
                    "for(var i=0;i<imgs.length;i++){" +
                        "imgs[i].style.maxWidth = '100%';" +
                        "imgs[i].style.height = 'auto';" +
                    "}" +
                "}\";" +
            "document.getElementsByTagName('head')[0].appendChild(script);"
            
            webView.stringByEvaluatingJavaScript(from: imgJs)
            webView.stringByEvaluatingJavaScript(from: "ResizeImages()")
        }
        // 进度走完了
        webProgress.setValue(1.0, forKeyPath: "progress")
        
        self.stopLoadingAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.stopLoadingAnimating()
    }
    
    // 请求拦截
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
}

extension MRWebViewController: NJKWebViewProgressDelegate {
    
    func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        
        progressView.setProgress(progress, animated: true)
        if progress >= 1.0 {
            dispatch_after_in_main(0.75) {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    if let weakSelf = self {
                        weakSelf.progressView.alpha = 0
                    }
                }, completion: { [weak self](_) in
                    if let weakSelf = self {
                        weakSelf.progressView.removeFromSuperview()
                    }
                })
            }
        }
    }
}

