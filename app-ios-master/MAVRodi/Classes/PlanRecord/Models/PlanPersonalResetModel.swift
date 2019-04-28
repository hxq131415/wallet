//
//  PlanPersonalResetModel.swift
//  MAVRodi
//
//  Created by pan on 2019/3/11.
//  Copyright © 2019 是心作佛. All rights reserved.
//

import UIKit
import ObjectMapper
class PlanPersonalResetModel: MRBaseModel {
    
    var cur_principal: Double = 0 //用户参与本金
    var cur_income: Double = 0  //用户收益
    var return_amount: Double = 0  //返还金额--兑换金额
    var loss_amount: Double = 0 //亏损金额
    var earnings_rate: Double = 0 //盈利率
    var return_rate: Double = 0 //回报率
    var return_ratio: Double = 0 //兑换比例
    var gainAll: Double = 0  //静态收益
    var sub_prize: Double = 0  //直推奖励
    var team_prize: Double = 0  //管理奖励
    var sub_count: Int = 0  //直推下线人数
    var team_count: Int = 0  //团队人数
    var team_principal: Double = 0  //团队参与本金
    var reset_id: Int = 0  //重启ID（0：未申请个人重启，非0表示有重启在申请）

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            cur_principal = otherMapToDouble(map: map["cur_principal"])
            cur_income = otherMapToDouble(map: map["cur_income"])
            return_amount = otherMapToDouble(map: map["return_amount"])
            loss_amount = otherMapToDouble(map: map["loss_amount"])
            earnings_rate = otherMapToDouble(map: map["earnings_rate"])
            return_rate = otherMapToDouble(map: map["return_rate"])
            return_ratio = otherMapToDouble(map: map["return_ratio"])
            gainAll = otherMapToDouble(map: map["gainAll"])
            sub_prize = otherMapToDouble(map: map["sub_prize"])
            team_prize = otherMapToDouble(map: map["team_prize"])
            sub_count = otherMapToInt(map: map["sub_count"])
            team_count = otherMapToInt(map: map["team_count"])
            team_principal = otherMapToDouble(map: map["team_principal"])
            reset_id = otherMapToInt(map: map["reset_id"])
            
            
            
        }
    }
    
}
