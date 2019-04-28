//
//  TETableView.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/29.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class TETableView: UITableView , UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let otherGesView = otherGestureRecognizer.view , otherGesView.isKind(of: UIWebView.classForCoder()) {
            return true
        }
        return false
    }
    
}
