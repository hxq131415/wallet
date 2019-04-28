//
//  PlanArrivalAmountTodaytModel.swift
//  MAVRodi
//
//  Created by pan on 2019/2/22.
//  Copyright © 2019 是心作佛. All rights reserved.
//

import UIKit
import ObjectMapper
class PlanArrivalAmountTodaytModel: MRBaseModel {
    
    var todayTop: String? //当日排单总限额，整型
    var todayInput: String?  //当日排单入场总量，整型
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            todayTop = otherMapToString(map: map["arrival_limit"])
            todayInput = otherMapToString(map: map["arrival_amount"])
            
        }
    }
    
}

