//
//  UITextField+Additions.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/5.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit

private var mr_placeholderColorKey: String = "mr_placeholderColorKey"

extension UITextField {
    
    // 设置placeholder的文字颜色，字体
    func setPlaceholderTextColor(textColor: UIColor?, textFont: UIFont, textAlignment: NSTextAlignment = .left) {
        
        self.setValue(textColor, forKeyPath: "_placeholderLabel.textColor")
        self.setValue(textFont, forKeyPath: "_placeholderLabel.font")
        self.setValue(textAlignment, forKeyPath: "_placeholderLabel.textAlignment")
    }
    
}


