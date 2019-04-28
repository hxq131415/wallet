//
//  MyRewardModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/10.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class MyRewardModel: MRBaseModel {

    var corpus: Double = 0
    var bonus_total: Double = 0
    var bonus_yesterday: Double = 0
    var bonus_weekly: Double = 0
    var bonus_monthly: Double = 0
    var level: String = ""
    var underlings: Int = 0
    var underling_corpus: Double = 0
    var team: Int = 0
    var team_corpus: Double = 0
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        corpus = otherMapToDouble(map: map["corpus"])
        bonus_total = otherMapToDouble(map: map["bonus_total"])
        bonus_yesterday = otherMapToDouble(map: map["bonus_yesterday"])
        bonus_weekly = otherMapToDouble(map: map["bonus_weekly"])
        bonus_monthly = otherMapToDouble(map: map["bonus_monthly"])
        underlings = otherMapToInt(map: map["underlings"])
        underling_corpus = otherMapToDouble(map: map["underling_corpus"])
        team = otherMapToInt(map: map["team"])
        team_corpus = otherMapToDouble(map: map["team_corpus"])
        level <- map["level"]
    }
    
}

// 奖励记录
class MyRewardRecordListModel: MRBaseModel {
    
    var add_time: String?
    var amount: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            add_time = otherMapToString(map: map["add_time"])
            amount = otherMapToString(map: map["amount"])
        }
    }
    
}

