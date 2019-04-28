//
//  UserDataModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/10.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class UserDataModel: MRBaseModel {

    var user_id: Int = -1
    var invitationCode: String?
    var download_url: String?
    var invitation_reward: Double = 0
    var management_reward: Double = 0
    var avatar: String?
    var personal_quotes: String?
    var nickname: String?
    var pd_lock: Bool = false // 排单冻结状态 1已冻结不能操作排单 2正常
    var is_bind_wallet: Int = 2 // 是否绑定钱包 1是 2否
    var invitationInformation: String?
    var level: String?
    var account: String?
    var unlock_need_mcoin: Double = 0
    var unlock_status: Int = 0
    
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            user_id = otherMapToInt(map: map["user_id"])
            invitationCode = otherMapToString(map: map["invitationCode"])
            download_url = otherMapToString(map: map["download_url"])
            avatar = otherMapToString(map: map["avatar"])
            personal_quotes = otherMapToString(map: map["personal_quotes"])
            nickname = otherMapToString(map: map["nickname"])
            invitationInformation = otherMapToString(map: map["invitationInformation"])
            invitation_reward = otherMapToDouble(map: map["invitation_reward"])
            management_reward = otherMapToDouble(map: map["management_reward"])
            level = otherMapToString(map: map["level"])
            account = otherMapToString(map: map["account"])
            unlock_need_mcoin = otherMapToDouble(map: map["unlock_need_mcoin"])
            unlock_status = otherMapToInt(map: map["unlock_status"])
            
            let pdLock = otherMapToInt(map: map["pd_lock"])
            pd_lock = pdLock == 1 ? true : false
            
            is_bind_wallet = otherMapToInt(map: map["is_bind_wallet"])
        }
        else {
            avatar <- map["avatar"]
            download_url <- map["download_url"]
            invitationCode <- map["invitationCode"]
            invitation_reward <- map["invitation_reward"]
            management_reward <- map["management_reward"]
            user_id <- map["user_id"]
            personal_quotes <- map["personal_quotes"]
            nickname <- map["nickname"]
            pd_lock <- map["pd_lock"]
            unlock_need_mcoin <- map["unlock_need_mcoin"]
            is_bind_wallet <- map["is_bind_wallet"]
            invitationInformation <- map["invitationInformation"]
            level <- map["level"]
            account <- map["account"]
            unlock_status <- map["unlock_status"]
            
        }
    }
    
}
