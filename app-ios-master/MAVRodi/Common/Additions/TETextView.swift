//
//  TETextView.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/14.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

//MARK: - 继承扩展增加占位符
class TETextView: UITextView {
    
    var placeHolderLabel:UILabel?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    //占位字符串
    var placeholder:String? {
        didSet{
            self.creatPlaceHolderLabel()
        }
    }
    
    //占位字符颜色
    var placeholderColor:UIColor = .lightGray {
        didSet{
            placeHolderLabel?.textColor = placeholderColor
        }
    }
    
    //占位字符字体
    var placeholderFont:UIFont = UIFont.systemFont(ofSize: 13) {
        didSet{
            placeHolderLabel?.font = placeholderFont
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    //创建站位字符
    func creatPlaceHolderLabel() {
        
        if placeHolderLabel != nil {
            placeHolderLabel?.removeFromSuperview()
            placeHolderLabel = nil
        }
        
        placeHolderLabel = UILabel()
        placeHolderLabel?.font = placeholderFont
        placeHolderLabel?.text = placeholder
        placeHolderLabel?.numberOfLines = 0
        placeHolderLabel?.textColor = placeholderColor
        placeHolderLabel?.sizeToFit()
        self.addSubview(placeHolderLabel!)
        
        if #available(iOS 8.3, *) {
            self.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        }
    }
    
}
