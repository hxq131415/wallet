//
//  MRTabBarItemContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/3.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MRTabBarItemContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = UIColor.clear
        self.highlightTextColor = UIColor.clear
        
        self.iconColor = UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
        self.highlightIconColor = UIColorFromRGB(hexRGB: 0x109baa)
        
        self.backdropColor = .clear
        self.highlightBackdropColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
