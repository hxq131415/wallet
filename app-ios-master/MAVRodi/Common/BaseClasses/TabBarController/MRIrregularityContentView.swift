//
//  MRIrregularityContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/3.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MRIrregularityContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.insets = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        self.imageView.transform = .identity
        self.superview?.bringSubview(toFront: self)
        
        self.textColor = UIColor.clear
        self.highlightTextColor = UIColor.clear
        
        self.renderingMode = .alwaysOriginal
        self.iconColor = .clear
        self.highlightIconColor = .clear
        
        self.backdropColor = .clear
        self.highlightBackdropColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateLayout() {
        super.updateLayout()
        
        self.imageView.sizeToFit()
        self.imageView.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        
    }
    
    
}

