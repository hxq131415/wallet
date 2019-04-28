//
//  PlanJoinUnfreezeAmountModel.swift
//  MAVRodi
//
//  Created by pan on 2019/2/19.
//  Copyright © 2019 是心作佛. All rights reserved.
//

import UIKit
import ObjectMapper

class PlanJoinUnfreezeAmountModel: MRBaseModel {
    
    
    var etc_amount: Double = 0
    var mcoin_amount: Double = 0
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            etc_amount = otherMapToDouble(map: map["etc-amount"])
            mcoin_amount = otherMapToDouble(map: map["mcoin-amount"])
        }
    }
    
}
