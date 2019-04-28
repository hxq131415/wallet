//
//  XRReachabilityTool.swift
//  XRNetworkAutoCheck
//
//  Created by 寒竹子 on 16/4/10.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

/**
 *  @brief 网络状态和网络类型监测
 *         监测网络类型： WiFi, 2G, 3G, 4G
 *         监测网络状态： 有网，无网
 *         支持iPv6
 *
 *  @by    黯丶野火
 */

import UIKit
import CoreTelephony

// 网络类型定义
enum XRNetworkType: Int {
    case XRNet_NUKnow
    case XRNet_UNEnable
    case XRNet_2G
    case XRNet_3G
    case XRNet_4G
    case XRNet_WiFi
}

typealias netChangedClosure = ((_ networkType: XRNetworkType) -> Void)

class XRReachabilityTool: NSObject {
    
    private static let tool: XRReachabilityTool = XRReachabilityTool()
    
    private var netCheckClosure: netChangedClosure? // XRNetworkType 无法转成objc类型
    @objc(googleReach)
    private var googleReach: XRReachability?
    public var currentNetStatus: XRNetworkType = .XRNet_UNEnable
    private var preNetStatus: XRNetworkType = .XRNet_NUKnow
    
    let hostName: String = {
        return "www.apple.com"
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.netStatusChanged(notif:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        self.googleReach = XRReachability(hostName: hostName)
        self.googleReach?.startNotifier()
    }
    
    static func sharedTool() -> XRReachabilityTool {
        
        switch tool.googleReach?.currentReachabilityStatus().rawValue {
        case 0:
            tool.currentNetStatus = .XRNet_UNEnable
            break
        case 1:
            tool.currentNetStatus = .XRNet_WiFi
            break
        case 2:
            tool.currentNetStatus = .XRNet_4G
            break
        default:
            break
        }
        
        return tool
    }
    
    private func getNetworkType() -> XRNetworkType {
        
        // 每次检测都必须创建一个对象，否则锁屏后将无法获取网络信息
        let telephonyNetInfo = CTTelephonyNetworkInfo()
        let netStatus = telephonyNetInfo.currentRadioAccessTechnology
        var networkType: XRNetworkType = .XRNet_4G
        
        if let currentRadioTech = netStatus {
            
            switch currentRadioTech {
                
            case CTRadioAccessTechnologyGPRS:
                networkType = .XRNet_2G
            case CTRadioAccessTechnologyEdge:
                networkType = .XRNet_2G
            case CTRadioAccessTechnologyeHRPD:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyHSDPA:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyWCDMA:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyCDMA1x:
                networkType = .XRNet_2G
            case CTRadioAccessTechnologyLTE:
                networkType = .XRNet_4G
            case CTRadioAccessTechnologyCDMAEVDORev0:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyCDMAEVDORevA:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyCDMAEVDORevB:
                networkType = .XRNet_3G
            case CTRadioAccessTechnologyHSUPA:
                networkType = .XRNet_3G
            default:
                break
            }
        }
        
        return networkType
    }
    
    // 监听到网络状态变化
    @objc private func netStatusChanged(notif: Notification) {
        
        var networkType: XRNetworkType = .XRNet_NUKnow
        
        if let reacha = notif.object as? XRReachability {
            
            if reacha.currentReachabilityStatus() == XRReachable_NotReachable {
                networkType = .XRNet_UNEnable
            }else {
                if reacha.currentReachabilityStatus() == XRReachable_ReachableViaWiFi {
                    networkType = .XRNet_WiFi
                }else if reacha.currentReachabilityStatus() == XRReachable_ReachableViaWWAN {
                    networkType = getNetworkType()
                }
            }
            
            self.currentNetStatus = networkType
            
            if currentNetStatus != preNetStatus {
                preNetStatus = currentNetStatus
                if let closure = netCheckClosure {
                    closure(currentNetStatus)
                    #if FALSE
                    var netStateStr: String = ""
                    switch currentNetStatus {
                    case .XRNet_2G:
                        netStateStr = "当前网络环境：2G"
                        break
                    case .XRNet_3G:
                        netStateStr = "当前网络环境：3G"
                        break
                    case .XRNet_4G:
                        netStateStr = "当前网络环境：4G"
                        break
                    case .XRNet_WiFi:
                        netStateStr = "当前网络环境：WIFI"
                        break
                    case .XRNet_NUKnow:
                        netStateStr = "当前网络环境：未知"
                        break
                    case .XRNet_UNEnable:
                        netStateStr = "当前网络环境：无网络"
                        break
                    }
                    
                    UIApplication.shared.keyWindow?.showHUDWithMessage(message: netStateStr)
                    #endif
                }
            }
        }
    }
    
    // 网络状态发生变化回调
    func getNetworkTypeWithClosure(closure: netChangedClosure?) -> () {
        self.netCheckClosure = closure
    }
    
    
}


