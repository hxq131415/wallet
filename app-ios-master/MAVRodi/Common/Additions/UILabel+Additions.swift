//
//  UILabel+Additions.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/27.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    /// 配置 UILabel
    func configLabel(text: String?, numberOfLines: Int = 1, textAlignment: NSTextAlignment, textColor: UIColor?, font: UIFont?) {
        
        self.text = text
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = font
    }
    
    
    
}
