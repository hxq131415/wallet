//
//  MRLocalizableStringManager.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/19.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MRLocalizableStringManager: NSObject {

    /** 返回国际化字符串
     -  根据系统语言返回对应的国际化字符串
     */
    static func localizableStringFromKey(key: String) -> String {
        
        let localizableString = NSLocalizedString(key, comment: "")
        return localizableString
    }
    
    /** 返回指定table的国际化字符串
     - key 国际化字符串 key
     - 手动切换App语言
     */
    static func localizableStringFromTableHandle(key: String) -> String {
        
        var localizableString: String = ""
        
        // 首先取当前系统语言环境
        var curLanguageType: String = MRTools.currentSystemLanguageType().rawValue
        
        // 再取用户设置的语言环境，若没有设置即第一次打开App，则跟随系统语言环境
        if let curLanguage = UserDefaults.standard.value(forKey: UDKEY_APP_CURRENT_SET_LANGUAGE) as? String {
            curLanguageType = curLanguage
        }
        
        if let path = Bundle.main.path(forResource: curLanguageType, ofType: nil) , let theBundle = Bundle(path: path) {
            localizableString = theBundle.localizedString(forKey: key, value: nil, table: "Localizable")
        }
        
        return localizableString
    }
    
}
