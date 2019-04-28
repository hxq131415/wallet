//
//  PlanJoinRecordListModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/15.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class PlanJoinRecordListModel: MRBaseModel {
    
    // 参与时间
    var add_time: Double = 0 {
        didSet {
            joinDateStr = Date(timeIntervalSince1970: add_time).dateStringFromDate()
        }
    }
    
    // 用户转款时间
    var userTransferTime: Double = 0 {
        didSet {
            userTransferDateStr = Date(timeIntervalSince1970: userTransferTime).dateStringFromDate()
        }
    }
    
    // 系统确认转账时间
    var transferConfirmTime: Double = 0 {
        didSet {
            transferConfirmDateStr = Date(timeIntervalSince1970: transferConfirmTime).dateStringFromDate()
        }
    }
    
    // 用户收获提款时间
    var tq_ime: Double = 0 {
        didSet {
            tqTimeDateStr = Date(timeIntervalSince1970: tq_ime).dateStringFromDate()
        }
    }
    
    var status: Int = 0 {
        didSet {
            joinStatusType = PlanRecordJoinStatus(rawValue: status) ?? .all
        }
    }
    
    var amount: Double = 0
    var commission: Double = 0
    var reward: Double = 0
    var id: Int = 0
    var transferStart: Double = 0 // 转款开始时间
    var transferDeadline: Double = 0 // 转款截止时间
//    var userTransferTime: Double = 0 // 用户转款时间
//    var transferConfirmTime: Double = 0 // 系统确认转账时间
    var is_packed: Bool = false // 是否正在打包
    
    // Additions
    var joinStatusType: PlanRecordJoinStatus = .all
    var joinDateStr: String?
    var userTransferDateStr: String?
    var transferConfirmDateStr: String?
    var tqTimeDateStr: String?
    
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
            transferStart = otherMapToDouble(map: map["transferStart"])
            transferDeadline = otherMapToDouble(map: map["transferDeadline"])
            userTransferTime = otherMapToDouble(map: map["userTransferTime"])
            transferConfirmTime = otherMapToDouble(map: map["transferConfirmTime"])
            tq_ime = otherMapToDouble(map: map["tq_time"])
            
            status = otherMapToInt(map: map["status"])
            
            let isPackaged = otherMapToInt(map: map["is_packed"])
            is_packed = (isPackaged == 1 ? true : false)
        }
    }
    
}
