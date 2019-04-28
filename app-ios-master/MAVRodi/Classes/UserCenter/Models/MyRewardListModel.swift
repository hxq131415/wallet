//
//  MyRewardListModel.swift
//  MAVRodi
//
//  Created by pan on 2019/2/23.
//  Copyright © 2019 是心作佛. All rights reserved.
//

import UIKit
import ObjectMapper

class MyRewardListModel: MRBaseModel {
    
    var change_amount: String = ""
    var add_time: String = ""
    var type: Int = 0 // 类型 1转出 2转入
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            change_amount = otherMapToString(map: map["change_amount"]) ?? ""
            add_time = otherMapToString(map: map["add_time"])  ?? ""
            
            let changeFloat = Double(change_amount)!
            type = changeFloat > 0.0 ? 2 : 1
        }
    }
    
}

