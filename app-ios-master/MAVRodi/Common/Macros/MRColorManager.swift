//
//  MRColorManager.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/4/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit

class MRColorManager: NSObject {
    
    // 主色<导航条颜色，头部视图背景色>
    static let WhiteThemeColor: UIColor = UIColorFromRGB(hexRGB: 0xFFFFFF)
    // 浅蓝 主题色
    static let LightBlueThemeColor: UIColor = UIColorFromRGB(hexRGB: 0x3887FD)
    
    //黄色
    static let YellowColor: UIColor = UIColorFromRGB(hexRGB: 0xFF6D06)
    
    // 白色
    static let WhiteColor: UIColor = UIColorFromRGB(hexRGB: 0xFFFFFF)
    
    //突出色
    static let RedProminentColor: UIColor = UIColorFromRGB(hexRGB: 0xED4C56)
    
    //灰色底色
    static let LightGrayBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0xF4F4F4)
    
    //红色按钮背景色
    static let RedButtonBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0xF96A63)
    // 绿色按钮背景色
    static let GreenButtonBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0x44C08A)
    //蓝色按钮背景色
    static let BlueButtonBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0x2e6ad4)
    // 灰色按钮背景色
    static let GrayButtonBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0x838383)
    
    //所有点击事件底色
    static let ClickLightGrayBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0xF3F3F3)
    
    // 所有控制器页面底色
    static let ViewControllerBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0xFFFFFF)
    static let ViewControllerLightGrayBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0xF6FAFB)
    //所有弹窗遮罩
    static let AlertMaskBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    // TableView And CollectionView BackgroundColor
    static let Table_Collection_ViewBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0xFFFFFF)
    
    // TableView SeparatorLineColor
    static let TableViewSeparatorLineLightColor: UIColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
    static let TableViewSeparatorLineDarkColor: UIColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
    
//    static let StatusBarBackgroundColor: UIColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
    static let StatusBarBackgroundColor: UIColor = UIColor.clear
    
    //边框线
    static let GrayBorderLineColor: UIColor = UIColorFromRGB(hexRGB: 0xE1E1E1)
    
    static let LightGrayBorderColor: UIColor = UIColorFromRGB(hexRGB: 0xDEDEDE)
    
    //普通灰色文字颜色
    static let LightGrayTextColor: UIColor = UIColorFromRGB(hexRGB: 0xe9eaec)
    
    //普通灰色文字颜色
    static let GrayTextColor: UIColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
    
    //黑色字体颜色值
    static let DarkBlackTextColor: UIColor = UIColorFromRGB(hexRGB: 0x2e2922)
    
    //蓝色字体颜色值
    static let BlueTextColor: UIColor = UIColorFromRGB(hexRGB: 0x3887FD)
    
    //红色字体颜色值
    static let RedTextColor: UIColor = UIColorFromRGB(hexRGB: 0xB1282D)
    
}
