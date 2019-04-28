//
//  MRTabBarController.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/31.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MRTabBarController: ESTabBarController,UITabBarControllerDelegate {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var lastDidTabbarIndex: Int = 0
    var isShowPlanView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
        self.addNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // App语言环境切换通知
    @objc open func appLanguageChanged(notifi: Notification) {
        
        let selectIndex = self.selectedIndex
        
        guard let viewCtrls = self.viewControllers else {
            return
        }
        
        if viewCtrls.count > 0 {
            let viewCtrl1 = viewCtrls[0]
            viewCtrl1.tabBarItem = MRTabBarItem(MRTabBarItemContentView(), title: nil, image: UIImage(named: "tabBar_wallet_normal"), selectedImage: UIImage(named: "tabBar_wallet_selected"), tag: 0)
        }
        
        if viewCtrls.count > 1 {
            let viewCtrl2 = viewCtrls[1]
            viewCtrl2.tabBarItem = MRTabBarItem(MRIrregularityContentView(), title: nil, image: UIImage(named: "tabBar_big_icon"), selectedImage: UIImage(named: "tabBar_big_icon"), tag: 1)
        }
        
        if viewCtrls.count > 2 {
            let viewCtrl3 = viewCtrls[2]
            viewCtrl3.tabBarItem = MRTabBarItem(MRTabBarItemContentView(), title: nil, image: UIImage(named: "tabBar_usercenter_normal"), selectedImage: UIImage(named: "tabBar_usercenter_selected"), tag: 2)
        }
        
        self.selectedIndex = selectIndex
    }

    
}

//MARK: - 显示点击中间按钮弹出视图
extension MRTabBarController {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        debugPrint("didSelect:\(tabBarController.selectedIndex)")
        
//        MRTools.requestForGetUserData(completeBlock: {
//            if let userInfo = MRCommonShared.shared.userInfo {
//                if userInfo.pd_lock {
//                    //弹框提示用户超过72小时未转款，该用户已被锁定。请联系管理员解锁后进行转账操作
//                    let title = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirm_key)
//                    let msg = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirmTips_key)
//                    CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: msg) {
//
//                    }
//                    return
//                }
//            }
//        })
        
        if tabBarController.selectedIndex == 1 && lastDidTabbarIndex == 1 {//显示
            if let userInfo = MRCommonShared.shared.userInfo {
                if userInfo.pd_lock {
                    return
                }
                else
                {
                    if let keyWindow = ShareDelegate.window {
                        if isShowPlanView {
                            PlanRecordPopView.hiddenPlanRecordPopView(superV: keyWindow, animate: true)
                        }else {
                            PlanRecordPopView.showPlanRecordPopView(superV: keyWindow, confirmTapClosure: { (index) in
                                if index != 9999 {
                                    var type: PlanNotificationType = .join
                                    if index == 100 {
                                        type = PlanNotificationType.join
                                    }else if index == 200 {
                                        type = PlanNotificationType.reward
                                    }else {
                                        type = PlanNotificationType.harvest
                                    }
                                    NotificationCenter.post(name: NNKEY_PLAN_RECORD_NOTIFICATION, object: type)
                                }
                                self.isShowPlanView = false
                            })
                        }
                        isShowPlanView = !isShowPlanView
                    }
                }
            }
            
        }else {//隐藏
            if let keyWindow = ShareDelegate.window {
                PlanRecordPopView.hiddenPlanRecordPopView(superV: keyWindow)
                isShowPlanView = false
            }
        }
        lastDidTabbarIndex = tabBarController.selectedIndex
    }
    
}
