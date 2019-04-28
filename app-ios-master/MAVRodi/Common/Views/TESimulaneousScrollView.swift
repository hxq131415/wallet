//
//  TESimulaneousScrollView.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/7/3.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class TESimulaneousScrollView: UIScrollView , UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
}
