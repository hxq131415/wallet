//
//  MRTextField.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/5.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MRTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 禁止复制，粘贴，剪切，选择，全选功能
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(paste(_:)) ||
            action == #selector(cut(_:)) ||
            action == #selector(copy(_:)) ||
            action == #selector(select(_:)) ||
            action == #selector(selectAll(_:)) ||
            action == #selector(delete(_:)) ||
            action == #selector(makeTextWritingDirectionLeftToRight(_:)) ||
            action == #selector(makeTextWritingDirectionRightToLeft(_:)) ||
            action == #selector(toggleBoldface(_:)) ||
            action == #selector(toggleItalics(_:)) ||
            action == #selector(toggleUnderline(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.classForCoder()) {
            gestureRecognizer.isEnabled = false
        }
        
        super.addGestureRecognizer(gestureRecognizer)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // 禁用放大镜
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.classForCoder()) {
            return false
        }
        
        return true
    }
    
}
