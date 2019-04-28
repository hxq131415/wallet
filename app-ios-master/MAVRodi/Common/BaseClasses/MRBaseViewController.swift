//
//  MRBaseViewController.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/4/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MRBaseViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        Log(message: "\(NSStringFromClass(self.classForCoder)) is dealloc!")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = MRColorManager.WhiteThemeColor
        
        self.addNotifications()
        
        if self.responds(to: #selector(getter: UIViewController.edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = UIRectEdge()
            self.extendedLayoutIncludesOpaqueBars = false;
        }
        
        // 设置不允许UIScrollView及其子类向下偏移
        if self.responds(to: #selector(setter: self.automaticallyAdjustsScrollViewInsets)) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 适配iOS11
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().prefersLargeTitles = false
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
            // 当需要调用系统的页面时要将contentInsetAdjustmentBehavior设置为automatic，否则系统的页面会被遮盖
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        
        if let nav = self.navigationController {
            nav.navigationBar.isTranslucent = false;
        }
        
        self.customLeftBackItemButton()
        self.customNavigationBarBackgroundImageWithBottomLine()
        self.customNavigationTitleAttributes();
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isNavigationBarToHidden() {
            self.customLeftBackItemButton()
            self.customNavigationBarBackgroundImageWithBottomLine()
            self.customNavigationTitleAttributes();
        }
        
        self.resetNavigationBar(animated)
        self.resetStatusBarBackgroundColor()
    }
    
    func isNavigationBarToHidden() -> Bool {
        return false
    }
    
    func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.default
    }
    
    func resetNavigationBar(_ animated: Bool) {
        let navHidden = self.isNavigationBarToHidden()
        self.navigationController?.setNavigationBarHidden(navHidden, animated: animated)
        self.navigationController?.navigationBar.barStyle = self.navigationBarStyle()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func resetStatusBarBackgroundColor() {
        
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
        let statusBar = statusBarWindow?.value(forKey: "statusBar") as? UIView
        if statusBar!.responds(to: #selector(getter: UIView.backgroundColor)) {
            UIView.animate(withDuration: MR_AnimateTimeInterval) {
                statusBar?.backgroundColor = self.statusBarBackgroundColor
            }
        }
    }
    
    var statusBarBackgroundColor: UIColor? {
        get {
            return nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    // Override
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    @objc override func customNavigationBarBackgroundImageWithoutBottomLine() {
        super.customNavigationBarBackgroundImageWithoutBottomLine()
    }
    
    /// 收键盘处理
    /// 若需要特殊处理时需要子类override
    // 重写touchsBegin
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if let touchView = touch.view {
                if touchView.isKind(of: UITextField.classForCoder()) || touchView.isKind(of: UITextView.classForCoder()) {
                    super.touchesBegan(touches, with: event)
                }
                else {
                    touchView.endEditing(true)
                }
            }
        }
    }
    
    // 注册通知
    func addNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appLanguageChanged(notifi:)), name: Notification.Name(rawValue: NNKEY_APP_LANAGUAGE_CHANGED_NOTIFICATION), object: nil)
        // 缺少token
        NotificationCenter.default.addObserver(self, selector: #selector(self.missTokenAction), name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: nil)
        
        // token验证失败，token无效
        NotificationCenter.default.addObserver(self, selector: #selector(self.missTokenAction), name: Notification.Name(rawValue: NNKEY_TOKEN_INCATIVE_NOTIFICATION), object: nil)
        
        // token过期
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenOutDateAction), name: Notification.Name(rawValue: NNKEY_SIGN_OUT_DATE_NOTIFICATION), object: nil)
    }
    
    // App语言环境切换通知
    @objc open func appLanguageChanged(notifi: Notification) {
        
//        exit(0)
    }
    
    // MARK: - token处理
    // 缺少token，token无效
    @objc func missTokenAction() {
        
        MRCommonShared.shared.loginInfo = nil
        (UIApplication.shared.delegate as? MRAppDelegate)?.checkUserLoginState()
    }
    
    // token过期
    @objc func tokenOutDateAction() {
        
        // 刷新token
        MRCommonShared.shared.loginInfo = nil
        (UIApplication.shared.delegate as? MRAppDelegate)?.checkUserLoginState()
    }
    
    // MARK: - 屏幕旋转控制 (默认是竖屏)
    override var shouldAutorotate: Bool {
        return false
    }
    
    // 设置可以支持的屏幕旋转的方向集合 (当页面是push的，屏幕的旋转方向决定于此)
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    // present时调用，设置默认的屏幕方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    

}
