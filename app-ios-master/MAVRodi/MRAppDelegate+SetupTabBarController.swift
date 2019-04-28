//
//  MRAppDelegate+SetupTabBarController.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/31.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController_swift

extension MRAppDelegate {
    
    // 刷新tabbar
    func refreshTabbarController() {
        
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
    }
    
    // 未创建钱包
    public func setupNewWalletTabBarController() {
        
        let tabBarController_ = MRTabBarController()
        tabBarController_.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController_.tabBar.backgroundImage = UIImage(color: UIColor.white)
        
        let walletViewCtrl = WalletNewHomeViewController()
        let walletNavCtrl = MRNavigationController(rootViewController: walletViewCtrl)
        
        let plainViewCtrl = PlanRecordViewController()
        let plainNavCtrl = MRNavigationController(rootViewController: plainViewCtrl)
        
        let userCenterViewCtrl = UserCenterViewController()
        let userCenterNavCtrl = MRNavigationController(rootViewController: userCenterViewCtrl)
        
        walletViewCtrl.tabBarItem = MRTabBarItem(MRTabBarItemContentView(), title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_TabBar_wallet_title_key), image: UIImage(named: "tabBar_wallet_normal"), selectedImage: UIImage(named: "tabBar_wallet_selected"), tag: 0)
        plainViewCtrl.tabBarItem = MRTabBarItem(MRIrregularityContentView(), title: nil, image: UIImage(named: "tabBar_big_icon"), selectedImage: UIImage(named: "tabBar_big_icon"), tag: 1)
        userCenterViewCtrl.tabBarItem = MRTabBarItem(MRTabBarItemContentView(), title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_TabBar_usercenter_title_key), image: UIImage(named: "tabBar_usercenter_normal"), selectedImage: UIImage(named: "tabBar_usercenter_selected"), tag: 2)
        
        tabBarController_.setViewControllers([walletNavCtrl, plainNavCtrl, userCenterNavCtrl], animated: true)
        self.tabBarController = tabBarController_
        
        let rootNavCtrl = MRNavigationController(rootViewController: tabBarController_)
        rootNavCtrl.navigationBar.isHidden = true
        self.window?.rootViewController = rootNavCtrl
        
        tabBarController?.didHijackHandler = {
            tabbarController, viewController, index in
            debugPrint(index)
            
            
        }
    }
    
    // 已创建钱包了
    public func setupWalletTabBarController() {
        
        let tabBarController_ = MRTabBarController()
        tabBarController_.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController_.tabBar.backgroundImage = UIImage(color: UIColor.white)
        
        let walletViewCtrl = WalletHomeViewController()
        let walletNavCtrl = MRNavigationController(rootViewController: walletViewCtrl)
        
        let plainViewCtrl = PlanRecordViewController()
        let plainNavCtrl = MRNavigationController(rootViewController: plainViewCtrl)
        
        let userCenterViewCtrl = UserCenterViewController()
        let userCenterNavCtrl = MRNavigationController(rootViewController: userCenterViewCtrl)
        
        walletViewCtrl.tabBarItem = MRTabBarItem(MRTabBarItemContentView(), title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_TabBar_wallet_title_key), image: UIImage(named: "tabBar_wallet_normal"), selectedImage: UIImage(named: "tabBar_wallet_selected"), tag: 0)
        plainViewCtrl.tabBarItem = MRTabBarItem(MRIrregularityContentView(), title: nil, image: UIImage(named: "tabBar_big_icon"), selectedImage: UIImage(named: "tabBar_big_icon"), tag: 1)
        userCenterViewCtrl.tabBarItem = MRTabBarItem(MRTabBarItemContentView(), title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_TabBar_usercenter_title_key), image: UIImage(named: "tabBar_usercenter_normal"), selectedImage: UIImage(named: "tabBar_usercenter_selected"), tag: 2)
        
        tabBarController_.setViewControllers([walletNavCtrl, plainNavCtrl, userCenterNavCtrl], animated: true)
        self.tabBarController = tabBarController_
        
        let rootNavCtrl = MRNavigationController(rootViewController: tabBarController_)
        rootNavCtrl.navigationBar.isHidden = true
        self.window?.rootViewController = rootNavCtrl
        
        
    }
    
}
