//
//  PlanHarvestRecordListModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/18.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class PlanHarvestRecordListModel: MRBaseModel {
    
    // 排单时间
    var add_time: Double = 0 {
        didSet {
            dateStr = Date(timeIntervalSince1970: add_time).dateStringFromDate()
        }
    }
    
    // 收款时间
    var confirmStart: Double = 0 {
        didSet {
            confirmDateStr = Date(timeIntervalSince1970: confirmStart).dateStringFromDate()
        }
    }
    // 会员钱包提取时间
    var wallet_tq_time: Double = 0 {
        didSet {
            wallet_tqDateStr = Date(timeIntervalSince1970: wallet_tq_time).dateStringFromDate()
        }
    }
    // 状态 1排队中、2待确认、3已完成
    var status: Int = 0 {
        didSet {
            harvestStatusType = PlanRecordHarvestStatus(rawValue: status) ?? .all
        }
    }
    
    var amount: Double = 0
    var commission: Double = 0
    var reward: Double = 0
    var id: Int = 0
    var transferDeadline: Double = 0 // 确认倒计时截止时间 需要确认才有
    var confirm_time: Double = 0 // 确认开始时间  需要确认才有
    
    
    var is_packed: Bool = false // 是否是正在打包
    
    // Additions
    var harvestStatusType: PlanRecordHarvestStatus = .all
    var dateStr: String?
    var confirmDateStr: String?
    var wallet_tqDateStr: String?

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            id = otherMapToInt(map: map["id"])
            
            add_time = otherMapToDouble(map: map["add_time"])
            amount = otherMapToDouble(map: map["amount"])
            commission = otherMapToDouble(map: map["commission"])
            reward = otherMapToDouble(map: map["reward"])
            transferDeadline = otherMapToDouble(map: map["transferDeadline"])
            confirmStart = otherMapToDouble(map: map["confirmStart"])
            status = otherMapToInt(map: map["status"])
            confirm_time = otherMapToDouble(map: map["confirm_time"])
            wallet_tq_time = otherMapToDouble(map: map["wallet_tq_time"])

            let isPackaged = otherMapToInt(map: map["is_packed"])
            is_packed = (isPackaged == 1 ? true : false)
        }
    }
    
}
