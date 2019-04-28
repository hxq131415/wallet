//
//  MRNavigationController.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/4/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MRNavigationController: UINavigationController , UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    deinit {
        self.interactivePopGestureRecognizer?.delegate = nil
        self.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: UIBarMetrics.default)
        self.navigationBar.isTranslucent = false
        
        if self.responds(to: #selector(getter: self.interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
        }
        
        self.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var childViewControllerForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false
        }
        return true
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if self.interactivePopGestureRecognizer != nil {
            if navigationController.viewControllers.count == 1 {
                self.interactivePopGestureRecognizer?.isEnabled = false
            }
            else {
                self.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
    
    /// Oerride 处理底部TabBar隐藏显示问题
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.interactivePopGestureRecognizer != nil {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        if self.viewControllers.count >= 1 {
            if viewController.isKind(of: WalletHomeViewController.classForCoder()) {
                viewController.hidesBottomBarWhenPushed = false
            }
            else {
                viewController.hidesBottomBarWhenPushed = true
            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        
        if let fIndex = self.viewControllers.index(of: viewController) {
            if fIndex == 0 {
                viewController.hidesBottomBarWhenPushed = false
            }
            else {
                viewController.hidesBottomBarWhenPushed = true
            }
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        
        for index_ in 0 ..< viewControllers.count {
            let viewCtrl = viewControllers[index_]
            if index_ == 0 {
                viewCtrl.hidesBottomBarWhenPushed = false
            }
            else {
                viewCtrl.hidesBottomBarWhenPushed = true
            }
        }
        
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    /// MARK: - 旋转屏幕控制
    override var shouldAutorotate: Bool {
        if let topCtrl = topViewController {
            return topCtrl.shouldAutorotate
        }
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
}





