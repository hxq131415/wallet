//
//  MRCommonShared.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/3.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class MRCommonShared: NSObject {

    static let shared: MRCommonShared = MRCommonShared()
    
    // 登录信息
    var loginInfo: LoginInfoModel? {
        
        get {
            if let dict = getValueForUserDefaultsWithKey(key: UDKEY_USER_LOGIN_DATA) as? [String: Any] {
                let loginInfo_ = LoginInfoModel(JSON: dict)
                return loginInfo_
            }
            return nil
        }
        
        set(newValue) {
            saveUserDefaultsWithValue(value: newValue?.toJSON(), key: UDKEY_USER_LOGIN_DATA)
        }
    }
    
    // 会员信息
    var userInfo: UserDataModel? {
        
        get {
            if let dict = getValueForUserDefaultsWithKey(key: UDKEY_USER_INFO_DATA) as? [String: Any] {
                let userData = UserDataModel(JSON: dict)
                return userData
            }
            return nil
        }
        
        set (newValue) {
            saveUserDefaultsWithValue(value: newValue?.toJSON(), key: UDKEY_USER_INFO_DATA)
        }
        
    }
    
    // 配置信息
    var config: AppConfigModel? {
        
        get {
            if let dict = getValueForUserDefaultsWithKey(key: UDKEY_PUBLIC_CONFIG_INFO) as? [String: Any] {
                let config_ = Mapper<AppConfigModel>().map(JSON: dict)
                return config_
            }
            return nil
        }
        
        set(newValue) {
            if newValue != nil {
                let dict = newValue!.toJSON()
                saveUserDefaultsWithValue(value: dict, key: UDKEY_PUBLIC_CONFIG_INFO)
            }
            else {
                saveUserDefaultsWithValue(value: nil, key: UDKEY_PUBLIC_CONFIG_INFO)
            }
        }
    }
    
    private override init() {
        super.init()
    }
    
    // 清除登录信息
    func cleanUserLoginInfo() {
        
        removeValueFromUserDefaultsWithKey(key: UDKEY_LOGIN_TOKEN)
        removeValueFromUserDefaultsWithKey(key: UDKEY_USER_LOGIN_DATA)
        self.loginInfo = nil
    }
    
    
}

// App配置信息
class AppConfigModel: MRBaseModel {
    
    var registrationAgreement: String? // 协议
    var entryFee: Double = 0 // 参与手续费(%) 计算: 参与金额*手续费/100
    var appearanceFee: Double = 0 // 收货手续费(%) 计算: 收货金额*手续费/100
    var download_url: String?
    var version: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            registrationAgreement = otherMapToString(map: map["registrationAgreement"])
            entryFee = otherMapToDouble(map: map["entryFee"])
            appearanceFee = otherMapToDouble(map: map["appearanceFee"])
//            download_url = otherMapToString(map: map["download_url"])
            let randomNum = Int(arc4random_uniform(8999) + 1000) //8999是区间,1000是最小数
            download_url = String(format: "%s%d", otherMapToString(map: map["download_url"])!,randomNum)//加随机数防止缓存导致下载错误
//            download_url = MR_DownloadApp_BASE_URL

            version = otherMapToString(map: map["version"])
        }
        else {
            registrationAgreement <- map["registrationAgreement"]
            entryFee <- map["entryFee"]
            appearanceFee <- map["appearanceFee"]
            download_url <- map["download_url"]
//            download_url = MR_DownloadApp_BASE_URL
            version <- map["version"]
        }
    }
    
    
    
}


