//
//  ProfitInfoListModel.swift
//  MAVRodi
//
//  Created by pan on 2018/12/21.
//  Copyright © 2018 是心作佛. All rights reserved.
//

import UIKit
import ObjectMapper
class ProfitInfoListModel: MRBaseModel {
    
    var invest: Double = 0 //个人投资本金
    var gain: Double = 0  //个人投资收益
    var investAll: Double = 0 //总投资本金
    var gainAll: Double = 0  //总投资收益
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            invest = otherMapToDouble(map: map["invest"])
            gain = otherMapToDouble(map: map["gain"])
            investAll = otherMapToDouble(map: map["investAll"])
            gainAll = otherMapToDouble(map: map["gainAll"])
        }
    }
    
}
