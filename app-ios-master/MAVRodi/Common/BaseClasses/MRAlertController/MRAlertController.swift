//
//  MRAlertController.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/9.
//  Copyright © 2018年 rttx. All rights reserved.
//

/** 通过对`UIAlertController`自定义系统弹框样式
 *
 *  修改文字颜色及字体
 */

import Foundation
import UIKit

class MRAlertController: UIAlertController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // title
        if let title_ = self.title {
            let titleAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x111111)]
            let attributesTitle = NSMutableAttributedString(string: title_, attributes: titleAttributes)
            
            self.setValue(attributesTitle, forKey: "attributedTitle")
        }
        
        // message
        if let message_ = self.message {
            let messageAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0xA8A8A8)]
            let attributesMessage = NSMutableAttributedString(string: message_, attributes: messageAttributes)
            
            self.setValue(attributesMessage, forKey: "attributedMessage")
        }
        
    }
    
    override func addAction(_ action: UIAlertAction) {
        super.addAction(action)
        
        if action.style == .cancel {
            action.setValue(UIColorFromRGB(hexRGB: 0xA8A8A8), forKey: "titleTextColor")
        }
        else if action.style == .default {
            action.setValue(UIColorFromRGB(hexRGB: 0x333333), forKey: "titleTextColor")
        }
        else if action.style == .destructive {
            action.setValue(UIColorFromRGB(hexRGB: 0xB1282D), forKey: "titleTextColor")
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
