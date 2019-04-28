//
//  PlanHarvestLeaderBonusModel.swift
//  MAVRodi
//
//  Created by pan on 2019/2/21.
//  Copyright © 2019 是心作佛. All rights reserved.
//



import UIKit
import ObjectMapper

class PlanHarvestLeaderBonusModel: MRBaseModel {
    
    
    var last_time: Double = 0
    var next_time: Double = 0
    var is_Permitted: Bool = false // 是否禁止收获
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            last_time = otherMapToDouble(map: map["last_time"])
            next_time = otherMapToDouble(map: map["next_time"])
            let isPermitted = otherMapToInt(map: map["isPermitted"])
            is_Permitted = (isPermitted == 0 ? true : false)
        }
    }
    
}

