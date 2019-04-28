//
//  TEBaseModel.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/4/27.
//  Copyright © 2018年 rttx. All rights reserved.
//
/// Mapple Base Model

import UIKit
import ObjectMapper

class MRBaseModel: NSObject, Mappable {

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
}
