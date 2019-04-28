//
//  TEEssayTools.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/14.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  Essasy Founction

import Foundation
import UIKit

// 判断是否是空串
func isNull(str: String?) -> Bool {
    
    guard let string = str else {
        return true
    }
    
    return string.isEmpty
}

/// UserDefaults
func saveUserDefaultsWithValue(value: Any?, key: String) {
    
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func getValueForUserDefaultsWithKey(key: String) -> Any? {
    
    return UserDefaults.standard.value(forKey: key)
}

func removeValueFromUserDefaultsWithKey(key: String) {
    
    UserDefaults.standard.removeObject(forKey: key)
}


