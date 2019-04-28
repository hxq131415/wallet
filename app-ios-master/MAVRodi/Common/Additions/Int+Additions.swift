//
//  Int+Additions.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/21.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

extension Int {
    
    ///数字转中文
    func transToCN() -> String {
        var zhNumbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
        var cn = ""
        if self <= 10 {
            for index in 0..<zhNumbers.count {
                if index == self {
                    cn = zhNumbers[index]
                    break
                }
            }
        }else if self > 10 && self < 100 {
            var num = 0
            for index1 in 0...1 {
                if index1 == 0 {
                    num = self / 10
                }else {
                    num = self % 10
                }
                for index in 0..<zhNumbers.count {
                    if num == 1 && index1 == 0 {
                        cn = "十"
                        continue
                    }
                    if num == 0 && index1 == 1 {
                        cn = "\(cn)十"
                        break
                    }
                    if index == num {
                        cn = "\(cn)\(zhNumbers[index])"
                        break
                    }
                }
            }
        }
        return cn
    }
    
}
