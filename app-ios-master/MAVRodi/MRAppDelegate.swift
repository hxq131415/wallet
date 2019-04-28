//
//  AppDelegate.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/29.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import IQKeyboardManager
import XREasyRefresh

@UIApplicationMain
class MRAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var tabBarController: MRTabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //集成崩溃日志
        Bugly.start(withAppId: "b6fdcc930c")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
#if DEBUG
        if UserDefaults.standard.value(forKey: "PSWrequestAPI") == nil
        {
            UserDefaults.standard.setValue("true", forKey: "PSWrequestAPI")
            UserDefaults.standard.synchronize()
            TERequestManager.changeRequestEnvironment(isRelease: true)
        }
        else{
            let requestAPIValue:String! = UserDefaults.standard.value(forKey: "PSWrequestAPI") as? String
            if requestAPIValue == "false"
            {
                TERequestManager.changeRequestEnvironment(isRelease: false)
            }
            else
            {
                TERequestManager.changeRequestEnvironment(isRelease: true)
            }
        }
#else
        if isRelease_forReqURL == 1 {
            TERequestManager.changeRequestEnvironment(isRelease: true)
        }
        else {
            TERequestManager.changeRequestEnvironment(isRelease: false)
        }
#endif
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // 请求会员信息
        MRTools.requestForGetUserData(completeBlock: {
            
        })
        
        // setup TabBarController
        if let userData = MRCommonShared.shared.userInfo {
            if userData.is_bind_wallet == 1 {
                self.setupWalletTabBarController()
            }
            else {
                self.setupNewWalletTabBarController()
            }
        }
        else {
            self.setupNewWalletTabBarController()
        }
        
        // 注册通知
        self.addNotifications()
        
        //键盘扩展
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
        // Disabled Handle
        //        IQKeyboardManager.shared().disabledDistanceHandlingClasses.addObjects(from: [])
        
        // Disabled ToolBar
        IQKeyboardManager.shared().disabledToolbarClasses.addObjects(from: [
            LoginViewController.classForCoder(),
            MRPaymentPasswordInputController.classForCoder()
            ])
        
        //KKWebImageCacheManager 初始化
        KKWebImageCacheManager.share().prepareForUse()
        
        XRRefreshControlSettings.sharedSetting.configSettings(
            animateTimeForAdjustContentInSetTop: 0.5,
            animateTimeForEndRefreshContentInSetTop: 0.5,
            afterDelayTimeForEndInsetTopRefreshing: 0.5,
            pullLoadingMoreMode: XRRefreshFooterPullLoadingMode.ignorePullReleaseFast,
            refreshStatusLblTextColor: UIColorFromRGB(hexRGB: 0x2e2922),
            refreshStatusLblTextFont: UIFont.systemFont(ofSize: 13))
        
        // 请求App配置信息
        MRTools.requestForPublicConfig {
            
            let udAppVersion = MRCommonShared.shared.config?.version
            let currentVersion = appBundleShortVersion
            
            var needUpdate: Bool = false
            
            if let udVersion = udAppVersion, let curVersion = currentVersion {
                
                if udVersion.compare(curVersion, options: NSString.CompareOptions.numeric) == .orderedDescending {
                    // 1.0 -> 1.2 版本升级
#if DEBUG
                    needUpdate = false
#else
                    needUpdate = true
#endif
                    
                }
            }
            
            if needUpdate {
                UpdateAlertView.showUpdateAlertView(superV: ShareDelegate.window ?? (MRTools.currentDisplayingViewController()?.view)!) {
                    //下载
                    if let download_url = MRCommonShared.shared.config?.download_url , let url = URL(string: download_url),  UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
                /*
                let alertCtrl = MRAlertController(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MRUpdateVersioAlert_title_key), message: MRLocalizableStringManager.localizableStringFromTableHandle(key: MRUpdateVersioAlert_update_content_key), preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MRUpdateVersioAlert_update_left_btn_title_key), style: UIAlertActionStyle.cancel) { (_) in
                    
                }
                
                let confirmAction = UIAlertAction(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MRUpdateVersioAlert_update_right_btn_title_key), style: UIAlertActionStyle.default) { (_) in
                    
                                                                                                                                                                                                                if let download_url = MRCommonShared.shared.config?.download_url , let url = URL(string: download_url),  UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
                
                alertCtrl.addAction(cancelAction)
                alertCtrl.addAction(confirmAction)
                
                dispatch_after_in_main(1, block: {
                    MRTools.currentDisplayingViewController()?.present(alertCtrl, animated: true, completion: nil)
                })
                **/
            }
        }
        
        // 全局关闭UITableView的self-sizing
        if #available(iOS 11, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
        
        //光标颜色
        UITextView.appearance().tintColor = MRColorManager.BlueTextColor
        UITextField.appearance().tintColor = MRColorManager.BlueTextColor
        
        //设置launchView
        _ = LaunchView(frame: (window?.bounds)!)
        self.window?.makeKeyAndVisible()
        // 检测用户登录状态
        self.checkUserLoginState()
        
        return true
    }
    
    // 注册通知监听
    func addNotifications() {
        
        // 缺少token
        NotificationCenter.default.addObserver(self, selector: #selector(self.missTokenAction), name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: nil)
        
        // token验证失败，token无效
        NotificationCenter.default.addObserver(self, selector: #selector(self.missTokenAction), name: Notification.Name(rawValue: NNKEY_TOKEN_INCATIVE_NOTIFICATION), object: nil)
        
        // token过期
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenOutDateAction), name: Notification.Name(rawValue: NNKEY_SIGN_OUT_DATE_NOTIFICATION), object: nil)
    }
    
    // MARK: - token处理
    // 缺少token，token无效
    @objc func missTokenAction() {
        
        MRCommonShared.shared.loginInfo = nil
        self.checkUserLoginState()
    }
    
    // token过期
    @objc func tokenOutDateAction() {
        
        // 刷新token
        MRCommonShared.shared.loginInfo = nil
        self.checkUserLoginState()
    }
    
    // 检测用户是否登录了
    func checkUserLoginState() {
        
        if MRCommonShared.shared.loginInfo == nil {
            // 未登录，退出登录，或者token过期
            let loginViewCtrl = LoginViewController()
            let loginNavCtrl = MRNavigationController(rootViewController: loginViewCtrl)
            
            if let curDisplayCtrl = MRTools.currentDisplayingViewController() {
                if curDisplayCtrl.isKind(of: LoginViewController.classForCoder()) {
                    return
                }
            }
            
            (self.tabBarController?.selectedViewController as? MRNavigationController)?.visibleViewController?.present(loginNavCtrl, animated: true) {
                
            }
        }
        else {
            // 已经登录了
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    // 后台任务标识
    var backgroundTask:UIBackgroundTaskIdentifier! = nil
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // 延迟程序静止的时间
        DispatchQueue.global().async() {
            //如果已存在后台任务，先将其设为完成
            if self.backgroundTask != nil {
                application.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskInvalid
            }
        }
        
        //如果要后台运行
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

