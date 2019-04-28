//
//  UIViewController+Extensions.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/4/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit

/// Extension for UIViewController
extension UIViewController {
    
    ///MARK:- 自定义返回按钮
    @objc public func customLeftBackItemButton() {
        let forceSet = self.navigationController != nil && self.navigationController!.viewControllers.count > 1
        let presetSet = self.navigationController != nil && self.navigationController!.viewControllers.count == 1 && self.navigationController!.presentingViewController != nil
        self.forceCustomLeftBackItemButton(forceSet)
        
        if forceSet {
            self.forceCustomLeftBackItemButton(forceSet)
        }
        else if presetSet {
            self.customLeftBackItemButtonWithImageName("icon_back_black")
        }
    }
    
    public func customLeftBackItemButtonWithImageName(_ imageName: String) {
        let barBtnItem = barButtonItemWithFrame(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                imageName: imageName,
                                                selectedImageName: nil,
                                                buttonTitle:nil,
                                                addTarget: self, action: #selector(UIViewController.popWithAnimate))
        if #available(iOS 11, *) {
            if let customView = barBtnItem.customView as? UIButton {
                customView.contentEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
                customView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
                customView.nt_hitInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: 8)
            }
        }
        
        if MRystemVersion >= 7.0 {
            let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            negativeSeperator.width = -20
            self.navigationItem.leftBarButtonItems = [negativeSeperator,barBtnItem]
        }
        else {
            self.navigationItem.leftBarButtonItem = barBtnItem;
        }
    }
    
    public func forceCustomLeftBackItemButton(_ forceSet: Bool) {
        if forceSet {
            let barBtnItem = barButtonItemWithFrame(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                    imageName: "icon_back_black",
                                                    selectedImageName: nil,
                                                    buttonTitle:nil,
                                                    addTarget: self, action: #selector(UIViewController.popWithAnimate))
            
            if #available(iOS 11, *) {
                if let customView = barBtnItem.customView as? UIButton {
                    customView.contentEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
                    customView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
                    customView.nt_hitInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: 8)
                }
            }
            
            if MRystemVersion >= 7.0 {
                let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
                negativeSeperator.width = -20;
                self.navigationItem.leftBarButtonItems = [negativeSeperator,barBtnItem]
            }
            else {
                self.navigationItem.leftBarButtonItem = barBtnItem;
            }
        }
    }
    
    public func setLeftBarButtonItemWithCustomView(customView: UIView){
        
        let barBtnItem = UIBarButtonItem(customView: customView)
        
        if #available(iOS 11, *) {
            if let customView = barBtnItem.customView as? UIButton {
                customView.contentEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
                customView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
                customView.nt_hitInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: 8)
            }
        }
        
        if MRystemVersion >= 7.0 {
            let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            negativeSeperator.width = customView.frame.origin.x - 20
            self.navigationItem.leftBarButtonItems = [negativeSeperator,barBtnItem]
        }
        else {
            self.navigationItem.leftBarButtonItem = barBtnItem;
        }
    }
    
    ///MARK: - 设置右边导航栏
    public func setRightBarButtonItemWithFrameFrame(frame: CGRect,imageName imgName: String?,buttonTitle title: String?,titleColor tColor: UIColor? = nil, titleFont tFont: UIFont? = nil,addTarget target: AnyObject?,action: Selector?) {
        
        let barBtnItem = barButtonItemWithFrame(frame: frame, imageName: imgName, selectedImageName: nil, buttonTitle: title, titleColor: tColor, titleFont: tFont, addTarget: target, action: action)
        
        if #available(iOS 11.0, *) {
            if let customView = barBtnItem.customView as? UIButton {
                customView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
                customView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
                customView.nt_hitInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: 8)
            }
        }
        
        if MRystemVersion >= 7.0 {
            let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            negativeSeperator.width = frame.origin.x - 20
            self.navigationItem.rightBarButtonItems = [negativeSeperator,barBtnItem]
        }
        else {
            self.navigationItem.rightBarButtonItem = barBtnItem;
        }
    }
    
    public func setRightBarButtonItemWithCustomView(customView: UIView){
        
        let barBtnItem = UIBarButtonItem(customView: customView)
        
        if #available(iOS 11.0, *) {
            if let customView = barBtnItem.customView as? UIButton {
                customView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
                customView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
                customView.nt_hitInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: 8)
            }
        }
        
        if MRystemVersion >= 7.0 {
            let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            negativeSeperator.width = customView.frame.origin.x - 20
            self.navigationItem.rightBarButtonItems = [negativeSeperator,barBtnItem]
        }
        else {
            self.navigationItem.rightBarButtonItem = barBtnItem;
        }
    }
    
    ///MARK:- 自定义nav导航栏背景图片
    public func customNavigationBarBackgroundImage() {
        let navBgImg = UIImage(color: MRColorManager.WhiteThemeColor, withFrame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height * theScreenScale))
        self.navigationController?.navigationBar.setBackgroundImage(navBgImg, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage(color: UIColorFromRGB(hexRGB: 0xe9eaeb), withFrame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 1))
    }
    
    public func customNavigationBarBackgroundImageWithBottomLine() {
        let navBgImg = UIImage(color: MRColorManager.WhiteThemeColor, withFrame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height * theScreenScale))
        self.navigationController?.navigationBar.setBackgroundImage(navBgImg, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage(color: UIColorFromRGB(hexRGB: 0xe9eaeb), withFrame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 1))
    }
    
    @objc public func customNavigationBarBackgroundImageWithoutBottomLine() {
        let navBgImg = UIImage(color: MRColorManager.WhiteThemeColor, withFrame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height * theScreenScale))
        self.navigationController?.navigationBar.setBackgroundImage(navBgImg, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc public func customNavigationTitleAttributes() {
        
        let paragphStyle = NSMutableParagraphStyle()
        paragphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.foregroundColor : UIColorFromRGB(hexRGB: 0x111111), NSAttributedStringKey.font : TE_NavigationTitle_Font, NSAttributedStringKey.paragraphStyle: paragphStyle]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    @objc public func popWithAnimate() {
        
        if self.navigationController != nil {
            if self.navigationController!.viewControllers.count > 1 {
                _ = self.navigationController?.popViewController(animated: true)
            }
            else {
                if self.navigationController?.presentingViewController != nil {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                else if self.presentingViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func pushToViewController(viewCtrl:UIViewController) {
        
        viewCtrl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewCtrl, animated: true)
    }
    
    //MARK: - pop指定页面
    func popToViewController(viewCtrl:UIViewController? = nil ,root:Bool = false,animated:Bool)  {
        
        if viewCtrl != nil {
            for i in 0..<(self.navigationController?.viewControllers.count)! {
                if self.navigationController?.viewControllers[i].isKind(of: (viewCtrl?.classForCoder)!) == true {
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[i])!, animated: animated)
                    break
                }
            }
            
        }else {
            if root == true {
                self.navigationController?.popToRootViewController(animated: animated)
            }else {
                self.navigationController?.popViewController(animated: animated)
            }
        }
    }
}




