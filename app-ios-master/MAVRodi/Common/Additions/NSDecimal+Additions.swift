//
//  NSDecimal+Additions.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/11.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation

extension NSDecimalNumber {
    
    // 对Double数值进行四舍五入
    // scale: 位数 默认两位小数
    // value    1.2  1.21  1.25  1.35  1.27
    // Plain    1.2  1.2   1.3   1.4   1.3
    // Down     1.2  1.2   1.2   1.3   1.2
    // Up       1.2  1.3   1.3   1.4   1.3
    // Bankers  1.2  1.2   1.2   1.4   1.3
    static func roundingDoubleValueWithScale(scale: Int16 = 2, doubleValue: Double) -> Double {
        
        let decimalHandle = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain,
                                                   scale: scale,
                                                   raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let decimalNumber = NSDecimalNumber(value: doubleValue)
        let roundingValue = decimalNumber.rounding(accordingToBehavior: decimalHandle)
        return roundingValue.doubleValue
    }
    
}
