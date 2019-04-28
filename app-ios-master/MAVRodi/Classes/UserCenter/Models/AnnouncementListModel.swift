//
//  AnnouncementListModel.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/19.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper

class AnnouncementListModel: MRBaseModel {
    
    var add_time: Double = 0 {
        didSet {
            self.dateStr = Date(timeIntervalSince1970: add_time).dateStringFromDate()
        }
    }
    
    var content: String?
    var title: String?
    var id: Int = 0
    var type: Int = 0
    var is_read: Bool = false
    
    // Additions
    var dateStr: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.mappingType == .fromJSON {
            add_time = otherMapToDouble(map: map["add_time"])
            content = otherMapToString(map: map["content"])
            title = otherMapToString(map: map["title"])
            id = otherMapToInt(map: map["id"])
            type = otherMapToInt(map: map["type"])
            is_read = otherMapToBool(map: map["is_read"])
        }
    }
    
}
