//
//  NotificationCenter+Additions.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/21.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

extension NotificationCenter {
    
    static func addObserver(observer:Any,selector:Selector,name:String,object:Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    static func post(name:String,object:Any? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object)
    }
}
