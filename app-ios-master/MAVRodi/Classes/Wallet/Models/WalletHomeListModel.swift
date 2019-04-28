//
//  WalletHomeListModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class WalletHomeListModel: MRBaseModel {

    var name: String?
    var worth: String?
    var balance: String?
    var id: Int = 0
    var logo: String?
    var address: String?
    var usdtPrice: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            name = otherMapToString(map: map["name"])
            logo = otherMapToString(map: map["logo"])
            address = otherMapToString(map: map["address"])
            
            worth = otherMapToString(map: map["worth"])
            balance = otherMapToString(map: map["balance"])
            id = otherMapToInt(map: map["id"])
            usdtPrice = otherMapToString(map: map["usdtPrice"])
        }
    }
    
}
