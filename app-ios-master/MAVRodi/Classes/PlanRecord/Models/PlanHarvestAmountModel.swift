//
//  PlanHarvestAmountModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/17.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class PlanHarvestAmountModel: MRBaseModel {

    var gameReward: HarvestAmountModel?
    var sysReward: HarvestAmountModel?
    var teamReward: HarvestAmountModel?
    var shareReward: HarvestAmountModel?
    var quantifiedRewards: HarvestAmountModel?

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        gameReward <- map["gameRewards"]
//        sysReward <- map["sysRewards"]
        sysReward <- map["shareRewards"]
        teamReward <- map["teamRewards"]
        shareReward <- map["shareRewards"]
        quantifiedRewards <- map["quantifiedRewards"]
    }
    
}

class HarvestAmountModel: MRBaseModel {
    
    var type: Int = 0
    var name: String?
    var amount: Double = 0
    var availableQuantity: Double = 0 // 可提取金额
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            type = otherMapToInt(map: map["type"])
            name = otherMapToString(map: map["name"])
            amount = otherMapToDouble(map: map["amount"])
            availableQuantity = otherMapToDouble(map: map["availableQuantity"])
        }
    }
    
}
