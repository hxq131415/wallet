//
//  PlanJoinGrapStatusModel.swift
//  MAVRodi
//
//  Created by pan on 2019/3/17.
//  Copyright © 2019 是心作佛. All rights reserved.
//

import UIKit
import ObjectMapper
class PlanJoinGrapStatusModel: MRBaseModel {
    
    var status:Double = 0//抢单是否进行状态 0：未进行 1：进行中
    
    var servertime: Double = 0 //服务器当前时间
    var limit: Double = 0  //抢单限额
    var nexttime: Double = 0
    var nexttimestr:String?
    var servertimestr:String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            status = otherMapToDouble(map: map["status"])
            servertime = otherMapToDouble(map: map["servertime"])
            limit = otherMapToDouble(map: map["limit"])
            nexttime = otherMapToDouble(map: map["nexttime"])
            nexttimestr = otherMapToString(map: map["nexttimestr"])
            servertimestr = otherMapToString(map: map["servertimestr"])
        }
    }
    
}
