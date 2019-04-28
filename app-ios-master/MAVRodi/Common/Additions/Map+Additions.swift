//
//  Map+Additions.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/10.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

public func otherMapToString(map: Map) -> String? {
    var t_type: String?
    t_type <- map
    
    if t_type != nil {
        return t_type!
    }
    
    var i_type: Int?
    i_type <- map
    
    if i_type != nil {
        return "\(i_type!)"
    }
    
    var d_type: Double?
    d_type <- map
    
    if d_type != nil {
        return "\(d_type!)"
    }
    
    return nil
}

public func otherMapToBool(map: Map) -> Bool {
    var t_type: Bool?
    t_type <- map
    
    if t_type != nil {
        return t_type!
    }
    
    var s_type: String?
    s_type <- map
    
    if s_type != nil {
        return s_type == "1" ? true : false
    }
    
    var i_type: Int = 0
    i_type <- map
    
    return i_type == 1 ? true : false
}

public func stringMapToInt(map: Map) -> Int {
    var t_type: String?
    t_type <- map
    
    if let intType = t_type?.toInt() {
        return intType
    }
    
    var i_type: Int = 0
    i_type <- map
    
    return i_type
}

public func dateStringMapToTimeInterval(map: Map) -> Double {
    var t_type: String?
    t_type <- map
    
    if let typeStr = t_type {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: typeStr) {
            return date.timeIntervalSince1970
        }
    }
    
    var d_type: Double = 0
    d_type <- map
    
    return d_type
}

public func stringMapToBool(map: Map) -> Bool {
    var t_type: String?
    t_type <- map
    
    if t_type != nil {
        return t_type!.toBool()
    }
    
    var i_type: Bool = false
    i_type <- map
    
    return i_type
}

public func stringMapToDouble(map: Map) -> Double {
    var t_type: String?
    t_type <- map
    
    if let dType = t_type?.toDouble() {
        return dType
    }
    
    var d_type: Double = 0
    d_type <- map
    
    return d_type
}

public func otherMapToInt(map: Map) -> Int {
    var t_type: String?
    t_type <- map
    
    if let intType = t_type?.toInt() {
        return intType
    }
    
    var d_type: Int = 0
    d_type <- map
    
    return d_type
}

public func otherMapToDouble(map: Map) -> Double {
    
    var t_type: String?
    t_type <- map
    
    if let dType = t_type?.toDouble() {
        return dType
    }
    
    var d_type: Double = 0.0
    d_type <- map
    return d_type
}

public func resetMapArray<T: Mappable>( dataArr dataArray: inout [T],map: Map) {
    var tmp: [T]?
    tmp <- map
    
    dataArray.removeAll(keepingCapacity: false)
    
    if tmp != nil {
        dataArray += tmp!
    }
}


public func resetMapNomalArray<T>( dataArr dataArray: inout [T],map: Map) {
    var tmp: [T]?
    tmp <- map
    
    dataArray.removeAll(keepingCapacity: false)
    
    if tmp != nil {
        dataArray += tmp!
    }
}
