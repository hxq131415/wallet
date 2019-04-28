//
//  CreateWalletPrivateKeyModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/6.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class CreateWalletPrivateKeyModel: MRBaseModel {
    
    var eth_privateKey: String?
    var etc_privateKey: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            etc_privateKey = otherMapToString(map: map["etc"])
            eth_privateKey = otherMapToString(map: map["eth"])
        }
    }
    
}
