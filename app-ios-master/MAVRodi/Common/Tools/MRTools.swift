//
//  MRTools.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/8.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import SystemConfiguration.CaptiveNetwork

class MRTools: NSObject {
    
    
    ///------------------------------------------------------------------///
    ///  登录 相关
    ///------------------------------------------------------------------///
    // MARK: - 自动弹出登录页面
//    class func autoPresentLoginPage(presentViewController: UIViewController?, completeHanle:@escaping ((_ isLogin: Bool, _ userId: String?) -> Swift.Void)) {
//
//        if let userModel = TECommonShare.shared.userLoginInfo {
//            TELog(message: "已登录:\(userModel.mobile ?? "")")
//            completeHanle(true, nil)
//        }
//        else {
//            let loginViewCtrl = LoginViewController()
//            let naviViewCtrl = MRNavigationController(rootViewController: loginViewCtrl)
//
//            // TODO: handle login
//            loginViewCtrl.loginActionCallback = {(isLogin_,userId_) in
//                //防止登录页面dismiss的时候 页面已经push过去 看不到动画效果
//                dispatch_after_in_main(0.03, block: {
//
//                    completeHanle(isLogin_,userId_)
//                })
//            }
//
//            if presentViewController != nil {
//                presentViewController!.present(naviViewCtrl, animated: true, completion: nil)
//            }
//            else {
//                if let curDisplayViewCtrl = MRTools.currentDisplayingViewController() {
//                    curDisplayViewCtrl.present(naviViewCtrl, animated: true, completion: nil)
//                }
//            }
//        }
//
//
//    }
    
    
    
    ///------------------------------------------------------------------///
    ///  系统权限检测 相关
    ///------------------------------------------------------------------///
    // MARK: - 检测相机授权
    class func checkAVCaptrueAuthorization(presentViewCtrl: UIViewController?, callBack: @escaping ((_ isAuthorized: Bool) -> Swift.Void)) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if status == AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied {
            
            if let infoDict = Bundle.main.infoDictionary , let appName = infoDict["CFBundleDisplayName"] as? String {
                let alertView = MRAlertController(title: "无法访问您的相机", message: "请在“设置->\(appName)->相机”设置为打开状态", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                let setAction = UIAlertAction(title: "去设置", style: UIAlertActionStyle.default, handler: { (action) in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                })
                
                alertView.addAction(action)
                alertView.addAction(setAction)
                presentViewCtrl?.present(alertView, animated: true, completion: nil)
            }
            
            DispatchQueue.main.async(execute: {
                callBack(false)
            })
        }
        else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (authorized) in
                if authorized {
                    DispatchQueue.main.async(execute: {
                        callBack(authorized)
                    })
                }
            })
        }
        else if status == .authorized {
            DispatchQueue.main.async(execute: {
                callBack(true)
            })
        }
        else {
            DispatchQueue.main.async(execute: {
                callBack(false)
            })
        }
    }
    
    // MARK: - 检测相册访问授权
    class func checkPhotoLibraryAuthorization(presentViewCtrl: UIViewController?, callBack: @escaping ((_ isAuthorized: Bool) -> Swift.Void)) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .restricted || status == .denied {
            if let infoDict = Bundle.main.infoDictionary , let appName = infoDict["CFBundleDisplayName"] as? String {
                let alertView = MRAlertController(title: "无法访问您的相册", message: "请在“设置->\(appName)->照片”设置为打开状态", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                let setAction = UIAlertAction(title: "去设置", style: UIAlertActionStyle.default, handler: { (action) in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                })
                
                alertView.addAction(action)
                alertView.addAction(setAction)
                presentViewCtrl?.present(alertView, animated: true, completion: nil)
            }
            
            DispatchQueue.main.async(execute: {
                callBack(false)
            })
        }
        else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (authoriStatus) in
                if authoriStatus == .authorized {
                    DispatchQueue.main.async(execute: {
                        callBack(true)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {
                        callBack(false)
                    })
                }
            })
        }
        else if status == .authorized {
            DispatchQueue.main.async(execute: {
                callBack(true)
            })
        }
        else {
            DispatchQueue.main.async(execute: {
                callBack(false)
            })
        }
    }
    
    ///------------------------------------------------------------------///
    ///  公用数据请求 相关
    ///------------------------------------------------------------------///
    // MARK: - 请求配置信息
    static func requestForPublicConfig(completeBlock: (() -> ())? = nil) {
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_INDEX_GET_CONFIGS, parameters: nil, requestInfo: nil) { (dataDict, code, msg) in
            if code == 0 {
                if let dict = dataDict as? [String: Any] {
                    let configModel = AppConfigModel(JSON: dict)
                    saveUserDefaultsWithValue(value: configModel?.toJSON(), key: UDKEY_PUBLIC_CONFIG_INFO)
                    MRCommonShared.shared.config = configModel
                }
                
                if completeBlock != nil {
                    completeBlock!()
                }
            }
            else {
                Log(message: "配置信息获取失败!!!")
            }
        }
    }
    
    // MARK: - 请求个人信息
    static func requestForGetUserData(completeBlock: @escaping (() -> Void)) {
        
        if MRCommonShared.shared.loginInfo == nil {
            return
        }
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_USER_USERDATA, parameters: nil, requestInfo: nil) { (data, status, message) in
            if status == 0 {
                if let dict = data as? [String: Any] {
                    let userInfoModel = UserDataModel(JSON: dict)
                    MRCommonShared.shared.userInfo = userInfoModel
                    MRCommonShared.shared.loginInfo?.userInfo = userInfoModel
                }
            }
            else {
                Log(message: "会员信息加载失败了")
            }
            
            completeBlock()
        }
    }
    
    ///------------------------------------------------------------------///
    ///  控制器 相关
    ///------------------------------------------------------------------///
    // MARK: - 控制器
    static func getCurrentDisplayingViewController(viewController: UIViewController) -> UIViewController {
        
        if viewController.presentedViewController != nil {
            return self.getCurrentDisplayingViewController(viewController: viewController.presentedViewController!)
        }
        else if let viewCtrl = viewController as? UISplitViewController {
            // SplitViewController
            if let lastViewCtrl = viewCtrl.viewControllers.last {
                return self.getCurrentDisplayingViewController(viewController: lastViewCtrl)
            }
            else {
                return viewController
            }
        }
        else if let viewCtrl = viewController as? UITabBarController {
            // UITabBarController
            if let selectViewCtrl = viewCtrl.selectedViewController {
                return self.getCurrentDisplayingViewController(viewController: selectViewCtrl)
            }
            else {
                return viewController
            }
        }
        else if let viewCtrl = viewController as? UITabBarController {
            // TETabBarController
            if let selectViewCtrl = viewCtrl.selectedViewController {
                return self.getCurrentDisplayingViewController(viewController: selectViewCtrl)
            }
            else {
                return viewController
            }
        }
        else if let viewCtrl = viewController as? UINavigationController {
            // UINavigationController
            if let topViewCtrl = viewCtrl.topViewController {
                return self.getCurrentDisplayingViewController(viewController: topViewCtrl)
            }
            else {
                return viewController
            }
        }
        else {
            return viewController
        }
    }
    
    // MARK: 获取当前显示的ViewController
    static func currentDisplayingViewController() -> UIViewController? {
        
        if let rootViewCtrl = (UIApplication.shared.delegate as? MRAppDelegate)?.window?.rootViewController {
            return self.getCurrentDisplayingViewController(viewController: rootViewCtrl)
        }
        return nil
    }
    
    // 获取最顶层Window
    static func getTopWindow() -> UIWindow? {
        
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        
        return keyWindow
    }
    
    ///传入base64的字符串，可以是没有经过修改的转换成的以data开头的，也可以是base64的内容字符串，然后转换成UIImage
    static func base64StringToUIImage(base64String:String)->UIImage? {
        var str = base64String
        
        // 1、判断用户传过来的base64的字符串是否是以data开口的，如果是以data开头的，那么就获取字符串中的base代码，然后在转换，如果不是以data开头的，那么就直接转换
        if str.hasPrefix("data:image") {
            guard let newBase64String = str.components(separatedBy: ",").last else {
                return nil
            }
            str = newBase64String
        }
        // 2、将处理好的base64String代码转换成NSData
        guard let imgNSData = NSData(base64Encoded: str, options: NSData.Base64DecodingOptions()) else {
            return nil
        }
        // 3、将NSData的图片，转换成UIImage
        guard let codeImage = UIImage(data: imgNSData as Data) else {
            return nil
        }
        return codeImage
    }
    
    // MARK: - 获取当前连接的WiFiSSID
    static func getCurrentLinkingWiFiInfo() -> String? {
        
        var wifi_ssid: String?
        
        if let cfArr: NSArray = CNCopySupportedInterfaces() {
            for cfInterface in cfArr {
                let cfStr = cfInterface as! CFString
                if let curNetInfo = CNCopyCurrentNetworkInfo(cfStr) {
                    let dict = curNetInfo as NSDictionary
                    let ssidKey = kCNNetworkInfoKeySSID as String
                    if let ssid = dict[ssidKey] as? String {
                        Log(message: "wifi ssid-->\(ssid)")
                        wifi_ssid = ssid
                    }
                }
            }
        }
        
        return wifi_ssid
    }
    
    // MARK: - 获取当前连接的Wifi ip地址
    static func getWifiIpAddress() -> String? {
        
        var address: String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        
        if getifaddrs(&ifaddr) == 0 {
            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                defer {
                    ptr = ptr?.pointee.ifa_next
                }
                
                if let interface = ptr?.pointee {
                    // Check for IPv4 or IPv6 interface
                    let addrFamily = interface.ifa_addr.pointee.sa_family
                    if addrFamily == __uint8_t(AF_INET) || addrFamily == __uint8_t(AF_INET6) {
                        let name = String(cString: interface.ifa_name)
                        if name == "en0" { // Wifi
                            var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                            address = String(cString: hostName)
                        }
                    }
                }
            }
            
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
    // MARK: - 获取当前系统语言环境
    static func currentSystemLanguageType() -> MRSystemLanaguageType {
        
        var languageType: MRSystemLanaguageType = .zh_cn
        
        // 先取系统首选语言
        if let appLanguages = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String] {
            if let currentLanguage = appLanguages.first {
                if currentLanguage.hasPrefix("en") {
                    // 英文环境
                    languageType = .en_us
                }
                else if currentLanguage.hasPrefix("zh") {
                    // 中文环境 (简体，繁体)，目前没有考虑繁体，繁体时显示的是英文
                    languageType = .zh_cn
                }
            }
        }
        
        // 再取用户设置的语言
        if let languageValue = UserDefaults.standard.value(forKey: UDKEY_APP_CURRENT_SET_LANGUAGE) as? String {
            if languageValue == MRSystemLanaguageType.en_us.rawValue {
                languageType = .en_us
            }
            else if languageValue == MRSystemLanaguageType.zh_cn.rawValue {
                languageType = .zh_cn
            }
        }
        
        return languageType
    }
    
    /**
     强：密码串包含其中三种或以上
     中：密码串包含其中两种
     弱：密码串包含其中一种
     */
    static func getWalletPasswordLevel(pwd: String) -> MRPasswordLevel {
        
        if pwd.isEmpty {
            return MRPasswordLevel.none
        }
        
        if pwd.count < 8 {
            return MRPasswordLevel.none
        }
        
        // 字母 + 数字 <特殊字符>
        if MRVerifyTools.verifyContainsNumberLetterAndSpecialChars(pwd) {
            return MRPasswordLevel.high
        }
        else if MRVerifyTools.verifyOnlyContainsNumber(pwd) ||
            MRVerifyTools.verifyOnlyContainsCharater(pwd) {
            // 纯字母或纯数字
            return MRPasswordLevel.low
        }
        else if MRVerifyTools.verifyContainsNumberAndCharater(pwd) {
            return MRPasswordLevel.middle
        }
        else {
            // 特殊字符 + 数字
            if MRVerifyTools.verifyContainsNumber(pwd) {
                return MRPasswordLevel.middle
            }
            
            // 特殊字符 + 字母
            if MRVerifyTools.verifyContainsLetter(pwd) {
                return MRPasswordLevel.middle
            }
            
            return MRPasswordLevel.low
        }
    }
    
}
