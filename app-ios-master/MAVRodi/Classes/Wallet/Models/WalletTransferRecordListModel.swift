//
//  WalletTransferRecordListModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/9.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class WalletTransferRecordListModel: MRBaseModel {

    var num: String = ""
    var add_time: String = ""
    var type: Int = 0 // 类型 1转出 2转入
    var status: Int = 0 // 1打包中 2打包成功 3打包失败
    var toAddress: String = ""
    var fromAddress: String = ""
    var block_height: String = ""
    var block_hash: String = ""
    var fee: String = ""
    var url: String = ""
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            num = otherMapToString(map: map["num"]) ?? ""
            add_time = otherMapToString(map: map["add_time"])  ?? ""
            type = otherMapToInt(map: map["type"])
            status = otherMapToInt(map: map["status"])
            toAddress = otherMapToString(map: map["toAddress"])  ?? ""
            fromAddress = otherMapToString(map: map["fromAddress"])  ?? ""
            block_height = otherMapToString(map: map["block_height"])  ?? ""
            block_hash = otherMapToString(map: map["block_hash"])  ?? ""
            fee = otherMapToString(map: map["fee"])  ?? ""
            url = otherMapToString(map: map["url"]) ?? ""
        }
    }
    
}
