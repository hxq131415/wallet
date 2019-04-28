//
//  UIButton+Additions.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/27.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    /// 配置普通Button
    func configButtonForNormal(title: String?, textAlignment: NSTextAlignment = .center, textColor: UIColor?, font: UIFont?, normalImage: UIImage?, selectedImage: UIImage?,  backgroundColor: UIColor?) {
        
        self.backgroundColor = backgroundColor
        self.setTitleColor(textColor, for: UIControlState.normal)
        self.setTitleColor(textColor, for: [.normal, .highlighted])
        self.setTitle(title, for: UIControlState.normal)
        self.setTitle(title, for: UIControlState.selected)
        self.setImage(normalImage, for: UIControlState.normal)
        self.setImage(selectedImage, for: UIControlState.selected)
        self.titleLabel?.textAlignment = textAlignment
        self.titleLabel?.font = font
    }
    
    /// 配置按钮，button title 普通\选中状态
    func configButtonForTitleState(title: String?, textAlignment: NSTextAlignment = .center, font: UIFont?, backgroundColor: UIColor?, normalTextColor: UIColor?, selectedTextColor: UIColor?) {
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: UIControlState.normal)
        self.setTitle(title, for: UIControlState.selected)
        self.setTitleColor(normalTextColor, for: UIControlState.normal)
        self.setTitleColor(normalTextColor, for: [.normal, .highlighted])
        self.setTitleColor(selectedTextColor, for: UIControlState.selected)
        self.setTitleColor(selectedTextColor, for: [.selected, .highlighted])
        self.titleLabel?.textAlignment = textAlignment
        self.titleLabel?.font = font
    }
    
    /// 配置按钮，button image 普通\选中状态
    func configButtonForImageState(normalImage: UIImage?, selectedImage: UIImage?,  backgroundColor: UIColor?) {
        
        self.backgroundColor = backgroundColor
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
    }
    
}
