//
//  Date+Additions.swift
//  NTMember
//
//  Created by rttx on 2018/2/2.
//  Copyright © 2018年 MT. All rights reserved.
//

import Foundation

extension Date {
    
    // 获取距离当前时间的时间戳
    func getTimeIntervalSinceNow() -> TimeInterval {
        
//        let timeZone = NSTimeZone.system
//        let timeInterval = timeZone.secondsFromGMT(for: self)
//        let gmtDateTime = self.addingTimeInterval(TimeInterval(timeInterval))
        return self.timeIntervalSinceNow
    }
    
    // 获取距离1970-01-01的时间戳
    func getTimeIntervalSince1970() -> TimeInterval {
        
//        let timeZone = NSTimeZone.system
//        let timeInterval = timeZone.secondsFromGMT(for: self)
//        let gmtDateTime = self.addingTimeInterval(TimeInterval(timeInterval))
        return self.timeIntervalSince1970
    }
    
    ///获取当前时间并格式化时间
    static func getCurrentTimeAndFormat(format:String) -> String {
        
        let curTime = Date(timeIntervalSince1970: self.getCurrentTimestamp())
        let dateFormat = DateFormatter()
        dateFormat.timeZone = NSTimeZone.system
        dateFormat.dateFormat = format
        let dateString = dateFormat.string(from: curTime)
        
        return dateString
    }
    
    static func timeIntervalFormat(format:String, interval:TimeInterval) -> String {
        
        let curTime = Date(timeIntervalSince1970: interval + 28800)
        let dateFormat = DateFormatter()
        dateFormat.timeZone = NSTimeZone.system
        dateFormat.dateFormat = format
        let dateString = dateFormat.string(from: curTime)
        
        return dateString
    }
    
    static func dateStringFromDateFormatter(date: Date, format: String) -> String {
        
        let dateFormat = DateFormatter()
        dateFormat.timeZone = NSTimeZone.system
        dateFormat.dateFormat = format
        let dateString = dateFormat.string(from: date)
        
        return dateString
    }
    
    ///获取当前时间的时间戳
    static func getCurrentTimestamp() -> Double {
        // 得到当前时间（世界标准时间 UTC/GMT）
//        var curDate = Date()
        // 设置系统时区为本地时区
//        let zone = NSTimeZone.system
        // 计算本地时区与 GMT 时区的时间差
//        let second = zone.secondsFromGMT()
        // 在 GMT 时间基础上追加时间差值，得到本地时间
//        curDate = curDate.addingTimeInterval(TimeInterval(second))
        let timestamp = Date().timeIntervalSince1970
        
        return timestamp
    }
    
    static func getCurrentTime() -> Date {
        
        let date = Date(timeIntervalSince1970: self.getCurrentTimestamp())
        return date
    }
    
    // 日期格式化字符串-> Date
    static func dateFromFormatTimeString(dateStr: String) -> Date? {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormater.timeZone = NSTimeZone.system
        
        let date = dateFormater.date(from: dateStr)
        return date
    }
    
    // 日期 -> 日期字符串
    func dateStringFromDate() -> String? {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        dateFormater.timeZone = NSTimeZone.system
        
        let dateStr = dateFormater.string(from: self)
        return dateStr
    }
    
    // 日期 -> 日期字符串
    func dateStringFromDate(formatString: String) -> String? {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = formatString
        dateFormater.timeZone = NSTimeZone.system
        
        let dateStr = dateFormater.string(from: self)
        return dateStr
    }
    
    // 日期 -> 时间字符串
    func dateStringFromTime(formatString: String) -> String? {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = formatString
        dateFormater.timeZone = NSTimeZone.system
        
        let dateStr = dateFormater.string(from: self)
        return dateStr
    }
    
    func dateTimeStringFromDate() -> String? {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormater.timeZone = NSTimeZone.system
        
        let dateStr = dateFormater.string(from: self)
        return dateStr
    }
    
    // 偏移numDays后的日期
    func offSetDay(numDays: Int) -> Date? {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        calendar?.firstWeekday = 2
        
        let offsetComponents = NSDateComponents()
        offsetComponents.day = numDays
        let date = calendar?.date(byAdding: offsetComponents as DateComponents, to: self, options: NSCalendar.Options(rawValue: 0))
        return date
    }
    
    // 偏移numMonth后的日期
    func offSetMonth(numMonth: Int) -> Date? {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        calendar?.firstWeekday = 2
        
        let offsetComponents = NSDateComponents()
        offsetComponents.month = numMonth
        let date = calendar?.date(byAdding: offsetComponents as DateComponents, to: self, options: NSCalendar.Options(rawValue: 0))
        return date
    }
    
    // 计算两个日期之间的天数
    func numberOfDaysFromStartDate(endDate: Date) -> Int? {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let compoents = calendar?.components(NSCalendar.Unit.day, from: self, to: endDate, options: NSCalendar.Options.wrapComponents)
        
        return compoents?.day
    }
    
}
