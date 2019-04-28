//
//  AlamofireMappleModel.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/4/27.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class AlamofireMappleModel: NSObject, Mappable {
    
    var code: Int = 0
    var msg: String?
    var data: Any?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code <- map["code"]
        
        msg <- map["msg"]
        data <- map["data"]
    }
    
}


