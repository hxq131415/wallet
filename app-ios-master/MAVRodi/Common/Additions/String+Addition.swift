//
//  String+Addition.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/2.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    // String -> Int
    func toInt() -> Int? {
        
        if self.isEmpty {
            return nil
        }
        
        return Int(self)
    }
    
    // String -> Double
    func toDouble() -> Double? {
        
        if self.isEmpty {
            return nil
        }
        
        return Double(self)
    }
    
    // String -> CGFloat
    func toCGFloat() -> CGFloat? {
        
        if self.isEmpty {
            return nil
        }
        
        let str = NSString(string: self)
        let numberValue = str.doubleValue
        return CGFloat(numberValue)
    }
    
    // String -> Bool
    func toBool() -> Bool {
        let nsText = self as NSString
        return nsText.boolValue
    }
    
    // String -> NSString
    func toNSString() -> NSString {
        let nsText = self as NSString
        return nsText
    }
    
    /// calute string size
    // 计算一行文本的大小
    func sizeForStringOneLineWithFont(font: UIFont) -> CGSize {
        
        if self.isEmpty {
            return CGSize.zero
        }
        
        let size = NSString(string: self).size(withAttributes: [NSAttributedStringKey.font : font])
        return size
    }
    
    /// 富文本高度计算
    public func calculateAttributesSizeWithConstrainedToSize(size: CGSize,attributes: [NSAttributedStringKey: Any],lineSpace: CGFloat? = 0) -> CGSize {
        
        if (self.isEmpty) {
            return CGSize.zero;
        }
        
        let attrStr = NSMutableAttributedString(string: self, attributes: attributes)
        
        if let space = lineSpace, space > 0 {
            
            let pagraphy = NSMutableParagraphStyle()
            pagraphy.lineSpacing = space
            attrStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: pagraphy, range: NSMakeRange(0, self.count))
        }
        
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        tempLabel.numberOfLines = 0
        tempLabel.attributedText = attrStr
        tempLabel.sizeToFit()
        
        return tempLabel.frame.size
    }
    
    /// 计算富文本高度
    public func calculateAttributesSizeWithConstrainedToSize(size: CGSize, attributedString attrStr: NSAttributedString, numberOfLines: Int = 0) -> CGSize {
        
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        tempLabel.numberOfLines = numberOfLines
        tempLabel.attributedText = attrStr
        tempLabel.sizeToFit()
        
        return tempLabel.frame.size
    }
    
    // 计算多行文本高度
    public func calculateTextSizeConstrainedToSize(size: CGSize, textFont: UIFont, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byCharWrapping) -> CGSize {
        
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        tempLabel.numberOfLines = numberOfLines
        tempLabel.textAlignment = textAlignment
        tempLabel.lineBreakMode = lineBreakMode
        tempLabel.text = self
        tempLabel.sizeToFit()
        
        return tempLabel.frame.size
    }
    
    // URL 编码
    func urlEncoding() -> String? {
        
        if #available(iOS 9.0, *) {
            return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        else {
            // iOS 9.0 befer
            return self.toNSString().addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        }
    }
    
    // URL 解码
    func urlDecoding() -> String? {
        
        if #available(iOS 9.0, *) {
            return self.removingPercentEncoding
        }
        else {
            return self.toNSString().replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
        }
    }
    
    // Base64 编码
    func base64Encoding() -> String? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            return base64String
        }
        
        return nil
    }
    
    // Base64解码
    func base64Decoding() -> String? {
        
        if let base64Data = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            let decodingString = String(data: base64Data, encoding: String.Encoding.utf8)
            return decodingString
        }
        
        return nil
    }
    
    // 字符串10 -> ￥10
    func stringMoneyFormat() -> String? {
        
        if self.contains("￥") {
            return self
        }
        return "￥" + self
    }
    
    // 手机号格式化  159*****123
    func stringPhoneNumberFormat() -> String {
        return (self as NSString).substring(to: 3) + "*****" + (self as NSString).substring(from: (self as NSString).length - 3)
    }
    
    // 银行卡号格式化  1234*****1234
    func stringCardNumberFormat() -> String {
        return (self as NSString).substring(to: 4) + "**********" + (self as NSString).substring(from: (self as NSString).length - 4)
    }
    
    // 姓名格式化  李*小 李*
    func stringNameFormat() -> String {
        
        if (self as NSString).length > 1 {
            let c = (self as NSString).substring(with: NSRange.init(location: 1, length: 1))
            return self.replacingOccurrences(of: c, with: "*")
        }
        return self
    }
    
    // 字符串 转 NSNumber
    func stringFormatNumber() -> NSNumber {
        return NSNumber(value: Double(self) ?? 0)
    }
    
    
    // 返回格式化10^-18的数字串
    static func stringFormatMultiplyingByPowerOf10_18(str: String) -> String {
        
        if let douValue = str.toDouble() {
            
            let etcValue = NSDecimalNumber(value: douValue)
            //指数的运算multiplying
            let indexValue = etcValue.multiplying(byPowerOf10: -18)
            //保留8位小数函数方法
            let behavor = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 8, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            //保留八位小数
            let roundValue = indexValue.rounding(accordingToBehavior: behavor)
            
            let etcValueStr = String(format: "%.6f", roundValue.doubleValue)
            return etcValueStr
        }
        
        return "0"
    }
    
    // 返回格式化10^-6的数字串
    static func stringFormatMultiplyingByPowerOf10_6(str: String) -> String {
        
        if let douValue = str.toDouble() {
            
            let etcValue = NSDecimalNumber(value: douValue)
            //指数的运算multiplying
            let indexValue = etcValue.multiplying(byPowerOf10: -6)
            //保留8位小数函数方法
            let behavor = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 8, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            //保留八位小数
            let roundValue = indexValue.rounding(accordingToBehavior: behavor)
            
            let etcValueStr = String(format: "%.6f", roundValue.doubleValue)
            return etcValueStr
        }
        
        return "0"
    }
    
}
