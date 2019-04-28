//
//  LoginInfoModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/3.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginInfoModel: MRBaseModel {
    
    var token_expires: Double = 0
    var refresh_token_expires: Double = 0
    var refresh_token: String?
    var token: String?
    var userInfo: UserDataModel?
    var cpStatus: Double = 0

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        userInfo <- map["userData"]
        if map.mappingType == .fromJSON {
            refresh_token = otherMapToString(map: map["refresh_token"])
            token = otherMapToString(map: map["token"])
            token_expires = otherMapToDouble(map: map["token_expires"])
            refresh_token_expires = otherMapToDouble(map: map["refresh_token_expires"])
            cpStatus = otherMapToDouble(map: map["cpStatus"])
        }
        else {
            refresh_token <- map["refresh_token"]
            token <- map["token"]
            token_expires <- map["token_expires"]
            refresh_token_expires <- map["refresh_token_expires"]
            cpStatus <- map["cpStatus"]
        }
    }
    
}

