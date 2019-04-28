//
//  TEMacros.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/4/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

#if DEBUG

// 打印信息，文件名，函数名，行数
func TELog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    let fileLastComponent = (filename as NSString).lastPathComponent
    print("-----> [\(fileLastComponent):\(line)] \(function)")
    print("\(message)")
}

// 只打印信息
func Log(message: String) {
    print(message)
}

#else

func TELog(message msg: String, filename: String = #file, function: String = #function, line: Int = #line) { }
func Log(message: String) {}

#endif

///延迟 afTime, 回调 block(in main 在主线程)
public func dispatch_after_in_main(_ afTime: TimeInterval,block: @escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64(afTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC) // 1s * popTime
    
    if popTime > DispatchTime(uptimeNanoseconds: 0) {
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: block)
    }
}

///延迟 afTime, 回调 block(in main 在主线程)
public func dispatch_after_in_main(_ afTime: TimeInterval,workBlockItem item: DispatchWorkItem) {
    let popTime = DispatchTime.now() + Double(Int64(afTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC) // 1s * popTime
    
    if popTime > DispatchTime(uptimeNanoseconds: 0) {
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: item)
    }
}

// App版本号 (CFBundleShortVersionString)
public let appBundleShortVersion: String? = {
    
    if let infoDict = Bundle.main.infoDictionary {
        if let version = infoDict["CFBundleShortVersionString"] as? String {
            return version
        }
    }
    return nil
}()

// 推送证书状态
#if DEBUG
public let TEJPushIsProduction: Bool = false
#else
public let TEJPushIsProduction: Bool = true
#endif

//旋转半径
public func RotateRadius(r: Double) -> Double
{
    return (r * Double.pi) / 180.0
}

//delegate
let ShareDelegate = (UIApplication.shared.delegate as! MRAppDelegate)

public let Main_Screen_Height = UIScreen.main.bounds.size.height
public let Main_Screen_Width = UIScreen.main.bounds.size.width

// 系统控件默认高度
public let Sys_Status_Bar_Height: CGFloat = iSiPhoneX() ? 44.0 : 20.0
public let Sys_Nav_Bar_Height: CGFloat = 44.0
public let Sys_Bottom_Bar_Height: CGFloat = 49.0
public let MR_Custom_NavigationBar_Height: CGFloat = iSiPhoneX() ? 88.0 : 64.0
// 主屏幕指示栏高度(适配iPhoneX)
public let Main_IndicatorBar_Height: CGFloat = iSiPhoneX() ? 34.0 : 0.0

// 适配比例 (设计稿是按照iPhone6尺寸做的，若做适配需要用这个比例)
public let theScaleToiPhone_6 = Main_Screen_Width / 375.0
// 屏幕分辨率 2x， 3x
public let theScreenScale = UIScreen.main.scale
// 动画时间
public let MR_AnimateTimeInterval: TimeInterval = 0.25

//MARK: - 沙盒路径
public let PATH_OF_APP_HOME = NSHomeDirectory()
public let PATH_OF_TEMP = NSTemporaryDirectory()

public let PATH_OF_DOCUMENT = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

//MARK: - 屏幕尺寸
// iPhone设备定义(物理尺寸)
func iSiPhoneX() -> Bool {
    return (UIScreen.main.bounds.size.width == 375 && UIScreen.main.bounds.size.height == 812) || (UIScreen.main.bounds.size.width == 812 && UIScreen.main.bounds.size.height == 375)
}

func iSiPhone6_7_8() -> Bool {
    return (UIScreen.main.bounds.size.width == 375) && (UIScreen.main.bounds.size.height == 667) || (UIScreen.main.bounds.size.width == 667) && (UIScreen.main.bounds.size.height == 375)
}

func iSiPhone6_7_8Plus() -> Bool {
    return (UIScreen.main.bounds.size.width == 414) && (UIScreen.main.bounds.size.height == 736) || (UIScreen.main.bounds.size.width == 736) && (UIScreen.main.bounds.size.height == 414)
}

func iSiPhone4_4S() -> Bool {
    return (UIScreen.main.bounds.size.width == 320) && (UIScreen.main.bounds.size.height == 480) || (UIScreen.main.bounds.size.width == 480) && (UIScreen.main.bounds.size.height == 320)
}

func iSiPhone5_5S_5C() -> Bool {
    return (UIScreen.main.bounds.size.width == 320) && (UIScreen.main.bounds.size.height == 568) || (UIScreen.main.bounds.size.width == 568) && (UIScreen.main.bounds.size.height == 320)
}

//是否备份过私钥
func isBucketPrivate() -> String {
    if let account = MRCommonShared.shared.userInfo?.account {
        return "Bucket_Private_key_\(account)"
    }
    return "Bucket_Private_key"
}

//是否显示过钱包服务弹窗
func isShowWalletServiceAlert() -> String {
    if let account = MRCommonShared.shared.userInfo?.account {
        return "Wallet_Service_Alert_key_\(account)"
    }
    return "Wallet_Service_Alert_key"
}

//MARK: - 版本
// 当前版本
public let MRystemVersion = (UIDevice.current.systemVersion as NSString).floatValue
public let SSystemVersion = UIDevice.current.systemVersion

//MARK: - 颜色
// 颜色(RGB)
public func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor
{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

public func  RGBCOLOR(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor
{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

//RGB颜色转换（16进制）
public func UIColorFromRGB(hexRGB: UInt32) -> UIColor
{
    let redComponent = (hexRGB & 0xFF0000) >> 16
    let greenComponent = (hexRGB & 0x00FF00) >> 8
    let blueComponent = hexRGB & 0x0000FF
    
    return RGBCOLOR(r: CGFloat(redComponent), g: CGFloat(greenComponent), b: CGFloat(blueComponent))
}

//RGB颜色转换（16进制）+ 透明度  --add by gyanping
public func UIColorFromRGBAlpha(hexRGB: UInt32, alphas: CGFloat) -> UIColor
{
    let redComponent = (hexRGB & 0xFF0000) >> 16
    let greenComponent = (hexRGB & 0x00FF00) >> 8
    let blueComponent = hexRGB & 0x0000FF
    
    return RGBA(r: CGFloat(redComponent), g: CGFloat(greenComponent), b: CGFloat(blueComponent),a: alphas)
}

//随机颜色
public func randomColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1.0)
}

//MARK: - 圆角
// View 圆角和加边框
public func ViewBorderRadius(View: UIView!, Radius: CGFloat?, Width: CGFloat?, Color: UIColor?)
{
    if Radius != nil {
        View.layer.cornerRadius = Radius!
        View.layer.masksToBounds = true
    }
    
    if Width != nil {
        View.layer.borderWidth = Width!
    }
    
    if Color != nil {
        View.layer.borderColor = Color!.cgColor
    }
}


//MARK: - NSUserDefault
//NSUserDefault 存取数据
public func UNSaveObject(obj: Any?,key: String){
    if let tmpObj = obj {
        UserDefaults.standard.set(tmpObj, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

public func UNGetObject(key: String) -> Any? {
    return UserDefaults.standard.object(forKey: key)
}


//NSUserDefault 序列化存取数据
public func UNSaveSerializedObject(obj: AnyObject,key: String) {
    let serialized = NSKeyedArchiver.archivedData(withRootObject: obj)
    
    UserDefaults.standard.set(serialized, forKey: key)
    UserDefaults.standard.synchronize()
}

public func UNGetSerializedObject(key: String) -> Any? {
    if let serialized = UserDefaults.standard.object(forKey:key) as? Data {
        return NSKeyedUnarchiver.unarchiveObject(with: serialized)
    }
    
    return nil
    
}

//NSUserDefault 删除数据
public func UNDeletedSerializedObject(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

//MARK: - Button
public func buttonWithFrame(frame: CGRect,imageName imgName: String?,selectedImageName selImgName: String?,buttonTitle title: String?,addTarget target: AnyObject?,action: Selector?) -> UIButton {
    
    let btn = UIButton(type: UIButtonType.custom)
    btn.frame = frame
    
    if imgName != nil {
        btn.setImage(UIImage(named: imgName!), for: UIControlState.normal)
    }
    
    if selImgName != nil {
        btn.setImage(UIImage(named: selImgName!), for: UIControlState.selected)
        btn.setImage(UIImage(named: selImgName!), for: UIControlState.highlighted)
    }
    
    if title != nil {
        btn.setTitle(title, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    if target != nil && action != nil {
        btn.addTarget(target!, action: action!, for: UIControlEvents.touchUpInside)
    }
    
    return btn
}

public func buttonWithFrame(frame: CGRect,
                            imageName imgName: String?,
                            selectedImageName selImgName: String?,
                            buttonTitle title: String?,
                            titleColor tColor: UIColor?,
                            titleFont tFont: UIFont?,
                            addTarget target: AnyObject?,
                            action: Selector?) -> UIButton {
    
    let btn = UIButton(type: UIButtonType.custom)
    btn.frame = frame
    
    if imgName != nil {
        btn.setImage(UIImage(named: imgName!), for: UIControlState.normal)
    }
    
    if selImgName != nil {
        btn.setImage(UIImage(named: selImgName!), for: UIControlState.selected)
        btn.setImage(UIImage(named: selImgName!), for: UIControlState.highlighted)
    }
    
    if title != nil {
        btn.setTitle(title, for: UIControlState.normal)
    }
    
    if tColor != nil {
        btn.setTitleColor(tColor, for: .normal)
    }
    
    if tFont != nil {
        btn.titleLabel?.font = tFont
    }
    
    if target != nil && action != nil {
        btn.addTarget(target!, action: action!, for: UIControlEvents.touchUpInside)
    }
    
    return btn
}

//MARK: - UIBarButtonItem
public func barButtonItemWithFrame(frame: CGRect,imageName imgName: String?,selectedImageName selImgName: String?,buttonTitle title: String?,addTarget target: AnyObject?,action: Selector?) -> UIBarButtonItem {
    let btn = buttonWithFrame(frame: frame, imageName: imgName, selectedImageName:selImgName, buttonTitle: title, addTarget: target, action: action)
    return UIBarButtonItem(customView: btn)
}

public func barButtonItemWithFrame(frame: CGRect,imageName imgName: String?,selectedImageName selImgName: String?,buttonTitle title: String?, titleColor tColor: UIColor?, titleFont tFont: UIFont?, addTarget target: AnyObject?,action: Selector?) -> UIBarButtonItem {
    let btn = buttonWithFrame(frame: frame, imageName: imgName, selectedImageName: selImgName, buttonTitle: title, titleColor: tColor, titleFont: tFont, addTarget: target, action: action)
    return UIBarButtonItem(customView: btn)
}

//拓展gbk中文字符
public extension String.Encoding {
    public static let gb2312: String.Encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue)))
}

public let TE_NavigationTitle_Font = UIFont.systemFont(ofSize: 18)


// MARK: - 公用enum定义

// 发送验证码类型
enum MRGetVerifyCodeType: Int {
    case register = 1        // 注册
    case resetPassword = 2   // 重新设置密码
    case setPaymentPwd = 3   // 设置支付密码
    case transfer = 4   // 转账
}

// 语言环境定义
enum MRSystemLanaguageType: String {
    case en_us = "en.lproj" // 英文环境
    case zh_cn = "zh-Hans.lproj" // 中文环境
}

// 密码强度（等级）
enum MRPasswordLevel {
    case none   // 无等级
    case low    // 低
    case middle // 中
    case high   // 高
}

