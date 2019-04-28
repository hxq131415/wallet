//
//  TEDesignableView.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/28.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

@IBDesignable
class TEDesignableView: UIView {
    
    @IBInspectable var te_cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = te_cornerRadius
            self.layer.masksToBounds = te_cornerRadius > 0
        }
    }
    
    @IBInspectable var te_borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = te_borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? = nil {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
}
