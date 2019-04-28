//
//  MRPageController.swift
//  FriendOfFish
//
//  Created by rttx on 2018/7/16.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import WMPageController

class MRPageController: WMPageController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = MRColorManager.ViewControllerBackgroundColor
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        
        if !self.te_isNavigationBarToHidden() {
            self.customLeftBackItemButton()
            self.customNavigationBarBackgroundImageWithBottomLine()
            self.customNavigationTitleAttributes();
        }
        
        self.resetNavigationBar(animated)
    }
    
    func te_isNavigationBarToHidden() -> Bool {
        return false
    }
    
    func te_navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.default
    }
    
    func resetNavigationBar(_ animated: Bool) {
        let navHidden = self.te_isNavigationBarToHidden()
        self.navigationController?.setNavigationBarHidden(navHidden, animated: animated)
        self.navigationController?.navigationBar.barStyle = self.te_navigationBarStyle()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
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
