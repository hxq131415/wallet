//
//  TERequestManager.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/4/26.
//  Copyright © 2018年 rttx. All rights reserved.
//
/****************************************************************
 * 基于`Alamofire`数据请求
 ****************************************************************/

import UIKit
import Alamofire
import CryptoSwift
import SwiftyJSON
import ObjectMapper

/**
 100    客户端参数缺少
 101    客户端校验不通过
 102    客户端版本号错误
 103    签名已过期
 -    -
 200    缺少token
 201    token无效
 202    账户被禁用
 203    账户不存在
 204    更新token失败
 205    微信未绑定
 -    -
 300    缺少参数
 301    没有查询到数据
 302    操作失败
 */

/// Request Code
enum TERequestStatusCode: Int {
    
    // 服务器返回Code
    case ClientMissingParameters   = 100 // 客户端参数缺少
    case ClientVerifyNotPass       = 101 // 客户端校验不通过
    case ClientVersionError        = 102 // 客户端版本号错误
    case SignOutDate         = -21 // 签名已过期
    case MissingToken        = -20 // 缺少token
    case NeedToLogin         = -22 // 请先登录
    case InactiveToken       = -23 // token无效
    case AccountLocked       = 1002 // 账户被禁用
    case ForceOffline        = 1004 // 用户被挤下线
    case AccountLockedTime        = -102 // 用户被锁定多久时间
    
    case AccountNoneExist    = 203 // 账户不存在
    case UpdateTokenFail     = 204 // 更新token失败
    case NotBindingWeiXin    = 205 // 微信未绑定
    case ParameterMissing    = 300 // 缺少参数
    case QueryNoneData       = 301 // 没有查询到数据
    case IncativeOperate     = 302 // 操作失败
    
    // 自定义Code
    case NotJSON = 80001  // 非JSON数据
    case NullData = 80002 // 数据为空
    case Failture = 80003 // 请求失败
}

class TERequestManager: NSObject {
    
    static var defaultSessionManager: SessionManager = {
        
        let sessionManager_ = SessionManager.default
        
        sessionManager_.session.configuration.timeoutIntervalForRequest = 60
        sessionManager_.session.configuration.timeoutIntervalForResource = 60
        
        return sessionManager_
    }()
    
    /// Base Request Api
    static var httpRequestBaseApi: String = MR_Release_BASE_URL
    
    // 切换环境(开发环境/生产环境)
    static func changeRequestEnvironment(isRelease: Bool) {
        
        if isRelease {
            httpRequestBaseApi = MR_Release_BASE_URL
        }
        else {
            httpRequestBaseApi = MR_Test_BASE_URL
        }
        
        // 设置安全策略
        // 暂不需要https双向验证
        setServerTrustPolicys()
    }
    
    // MARK: - 设置https下的安全策略
    static func setServerTrustPolicys() {
        
//        let sessionManager = SessionManager.default
        
        ///========================================================================================
        /// Https双向验证
        /// https提供双向验证，当客户端(浏览器，App)不进行任何处理时即是服务器端的单向验证，若要支持双向验证则需要拿到
        /// 后端提供的证书，验证时带上证书，服务器端通过私钥进行验证。一般App不需要双向验证。
        /// 购买的证书：什么都不用管，改一下服务器地址就行，代码完全不用改。
        /// 自签名证书：找后端哥们儿要一个 crt，自己提取也行，转换成 cer ，放到相应的方法里，手动让处理流程继续即可。
        /// 服务器证书验证策略，需要后端提供证书文件。
//        var certificateArray: [SecCertificate] = []
//
//        if let cerFilePath = Bundle.main.path(forResource: "api", ofType: "cer"),
//            let certificateData = try? Data(contentsOf: URL(fileURLWithPath: cerFilePath)) {
//            if let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) {
//                certificateArray.append(certificate)
//            }
//        }
//
//        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(certificates: certificateArray, validateCertificateChain: true, validateHost: true)
//        if let apiBaseURL = URL(string: httpRequestBaseApi) , let host = apiBaseURL.host {
//            let trustPolices: [String: ServerTrustPolicy] = [host: serverTrustPolicy]
//            let trustPolicyManager = ServerTrustPolicyManager(policies: trustPolices)
//            sessionManager.session.serverTrustPolicyManager = trustPolicyManager
//        }
        
        ///========================================================================================
        
        /// 客户端证书验证策略
        ///...
        ///========================================================================================
        
        // 域名验证策略 一般不用
//        let hostPolicy = ServerTrustPolicy.performDefaultEvaluation(validateHost: true)
//
//        if let apiBaseURL = URL(string: httpRequestBaseApi) , let host = apiBaseURL.host {
//            let trustPolices: [String: ServerTrustPolicy] = [host: hostPolicy]
//            let trustPolicyManager = ServerTrustPolicyManager(policies: trustPolices)
//            sessionManager.session.serverTrustPolicyManager = trustPolicyManager
//        }
    }
    
    // MARK: - DataRequest
    /// Reuqest for GET
    @discardableResult
    static func dataRequestForGET(with urlStr: String, completeClosure: @escaping ((Any?) -> Void)) -> DataRequest? {
        
        let request = defaultSessionManager.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
            
            if let jsonValue = response.result.value {
                completeClosure(jsonValue)
            }
            else {
                completeClosure(nil)
            }
        }
        
        return request
    }
    
    /// Request for POST
    /// 完整地址请求
    @discardableResult
    static func dataRequestForPOST(with urlStr: String,
                                   parameters: [String: Any]? = nil,
                                   requestInfo: [String: Any]? = nil,
                                   complateBlock: @escaping ((_ object: Any?, _ status: Int, _ message: String?) -> Void)) -> DataRequest? {
        
        let oauthHandler = TEOAuthHandler(parameters: parameters)
        defaultSessionManager.adapter = oauthHandler
        defaultSessionManager.retrier = oauthHandler
        
        // 去掉前后空格，地址前面有空格时会报URL is not valid
        var urlStr_ = urlStr
        urlStr_ = (urlStr_ as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        
        let request = defaultSessionManager.request(urlStr_, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseData { (dataResponse) in
            
            //+++++++++++++++++++++++++++++ Print +++++++++++++++++++++++++++++++++
            TELog(message: "URL--> \(urlStr)")
            Log(message: "+++++++++++++++ 请求已返回 +++++++++++++++")
            /// 打印请求信息，便于出错时调试
            Log(message: "+++++++++++++++ 请求信息 ++++++++++++++++")
            if let req = dataResponse.request {
                Log(message: "URL--> \(req.url?.absoluteString ?? "")")
                if let httpHeader = req.allHTTPHeaderFields {
                    Log(message: "request.allHeaderFields: \(JSON(httpHeader))")
                }
            }
            
            Log(message: "+++++++++++++++ 服务器响应信息 +++++++++++++++")
            if let resp = dataResponse.response {
                Log(message: "response.statusCode: \(resp.statusCode)")
                Log(message: "response.allHeaderFields: \(JSON(resp.allHeaderFields))")
            }
            
            Log(message: "++++++++++++++++++++++++++++++++++++++++++++")
            
            //+++++++++++++++++++++++++++++ Parse +++++++++++++++++++++++++++++++++
            Log(message: "+++++++++++++++ 开始数据解析 +++++++++++++++")
            if dataResponse.result.isSuccess {
                
                guard let data = dataResponse.data else {
                    // 无数据
                    Log(message: "data 为空!")
                    complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据为空")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    Log(message: "JSON数据-->")
                    Log(message: "\(JSON(json))")
                    
                    if let dict = json as? [String: Any], let model = Mapper<AlamofireMappleModel>().map(JSON: dict) {
                        
                        if model.code == TERequestStatusCode.ClientMissingParameters.rawValue {
                            TELog(message: "客户端缺少参数!")
                        }
                        else if model.code == TERequestStatusCode.ClientVerifyNotPass.rawValue {
                            TELog(message: "客户端校验不通过!")
                        }
                        else if model.code == TERequestStatusCode.ClientVersionError.rawValue {
                            TELog(message: "客户端版本号错误!")
                        }
                        else if model.code == TERequestStatusCode.SignOutDate.rawValue {
                            TELog(message: "签名已过期!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_SIGN_OUT_DATE_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.MissingToken.rawValue {
                            TELog(message: "缺少Token!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.AccountLocked.rawValue {
                            TELog(message: "账户被禁用!")
                        }
                        else if model.code == TERequestStatusCode.AccountLockedTime.rawValue {
                            TELog(message: "账户被锁定!")
                        }
                        else if model.code == TERequestStatusCode.AccountNoneExist.rawValue {
                            TELog(message: "账户不存在!")
                        }
                        else if model.code == TERequestStatusCode.InactiveToken.rawValue || model.code == -3 {
                            TELog(message: "token无效!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_TOKEN_INCATIVE_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.UpdateTokenFail.rawValue {
                            TELog(message: "更新token失败!")
                        }
                        else if model.code == TERequestStatusCode.ParameterMissing.rawValue {
                            TELog(message: "缺少请求参数!")
                        }
                        // ... 其他code在具体请求里处理
                        
                        complateBlock(model.data, model.code, model.msg)
                    }
                    else {
                        complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据解析失败了")
                    }
                }
                else if let dataStr = String(data: data, encoding: String.Encoding.utf8) {
                    Log(message: "非JSON数据-->\(dataStr)")
                    Log(message: "\(dataStr)")
                    complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                }
                else {
                    complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                }
                
                Log(message: "+++++++++++++++ 数据解析结束 +++++++++++++++")
                Log(message: "\n")
            }
            else {
                if let err = dataResponse.result.error {
                    Log(message: "\(err.localizedDescription)")
                }
                complateBlock(nil, TERequestStatusCode.Failture.rawValue, "数据请求失败了")
                Log(message: "+++++++++++++++ 请求结束 +++++++++++++++")
            }
        }
        
        return request
    }
    /// 普通请求
    /// Request Code
    @discardableResult
    static func dataRequestForGETWithCode(with reqCode: String,
                                           parameters: [String: Any]? = nil,
                                           requestInfo: [String: Any]? = nil,
                                           complateBlock: @escaping ((_ object: Any?, _ status: Int, _ message: String?) -> Void)) -> DataRequest? {
        
        let oauthHandler = TEOAuthHandler(parameters: parameters)
        defaultSessionManager.adapter = oauthHandler
        defaultSessionManager.retrier = oauthHandler
        
        var urlStr = httpRequestBaseApi + reqCode
        
        // 去掉前后空格，地址前面有空格时会报URL is not valid
        urlStr = (urlStr as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        
        let request = defaultSessionManager.request(urlStr, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseData { (dataResponse) in
                
                //+++++++++++++++++++++++++++++ Print +++++++++++++++++++++++++++++++++
                Log(message: "URL--> \(urlStr)")
                
                Log(message: "+++++++++++++++ 请求已返回 +++++++++++++++")
                
                Log(message: "+++++++++++++++ Time line +++++++++++++++")
                Log(message: "\(dataResponse.timeline)")
                Log(message: "+++++++++++++++ Time End +++++++++++++++")
                
                /// 打印请求信息，便于出错时调试
                Log(message: "+++++++++++++++ 请求信息 ++++++++++++++++")
                if let req = dataResponse.request {
                    Log(message: "URL--> \(req.url?.absoluteString ?? "")")
                    if let httpHeader = req.allHTTPHeaderFields {
                        Log(message: "request.allHeaderFields: \(JSON(httpHeader))")
                    }
                }
                
                if let parameters_ = parameters {
                    Log(message: "请求参数->\n \(JSON(parameters_))")
                }
                
                Log(message: "+++++++++++++++++++++++++++++++++++++++")
                Log(message: "+++++++++++++++ 服务器响应信息 +++++++++++++++")
                if let resp = dataResponse.response {
                    Log(message: "response.statusCode: \(resp.statusCode)")
                    Log(message: "response.allHeaderFields: \(JSON(resp.allHeaderFields))")
                }
                
                Log(message: "++++++++++++++++++++++++++++++++++++++++++++")
                
                //+++++++++++++++++++++++++++++ Parse +++++++++++++++++++++++++++++++++
                Log(message: "+++++++++++++++ 开始数据解析 +++++++++++++++")
                if dataResponse.result.isSuccess {
                    
                    guard let data = dataResponse.data else {
                        // 无数据
                        Log(message: "data 为空!")
                        complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据为空")
                        return
                    }
                    
                    if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                        Log(message: "JSON-->")
                        Log(message: "\(JSON(json))")
                        
                        if let dict = json as? [String: Any], let model = Mapper<AlamofireMappleModel>().map(JSON: dict) {
                            if model.code == TERequestStatusCode.ClientMissingParameters.rawValue {
                                TELog(message: "客户端缺少参数!")
                            }
                            else if model.code == TERequestStatusCode.ClientVerifyNotPass.rawValue {
                                TELog(message: "客户端校验不通过!")
                            }
                            else if model.code == TERequestStatusCode.ClientVersionError.rawValue {
                                TELog(message: "客户端版本号错误!")
                            }
                            else if model.code == TERequestStatusCode.SignOutDate.rawValue {
                                TELog(message: "签名已过期!")
                                NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_SIGN_OUT_DATE_NOTIFICATION), object: model.code)
                            }
                            else if model.code == TERequestStatusCode.MissingToken.rawValue {
                                TELog(message: "缺少Token!")
                                NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                            }
                            else if model.code == TERequestStatusCode.NeedToLogin.rawValue {
                                TELog(message: "请先登录")
                                NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                            }
                            else if model.code == TERequestStatusCode.ForceOffline.rawValue {
                                // 被挤下线，直接弹出登录页面
                                TELog(message: "您被挤下线了!")
                                NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                            }
                            else if model.code == TERequestStatusCode.AccountLocked.rawValue {
                                TELog(message: "账户被禁用!")
                            }
                            else if model.code == TERequestStatusCode.AccountNoneExist.rawValue {
                                TELog(message: "账户不存在!")
                            }
                            else if model.code == TERequestStatusCode.InactiveToken.rawValue || model.code == -3 {
                                TELog(message: "token无效!")
                                NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_TOKEN_INCATIVE_NOTIFICATION), object: model.code)
                            }
                            else if model.code == TERequestStatusCode.UpdateTokenFail.rawValue {
                                TELog(message: "更新token失败!")
                            }
                            else if model.code == TERequestStatusCode.ParameterMissing.rawValue {
                                TELog(message: "缺少请求参数!")
                            }
                            // ... 其他code在具体请求里处理
                            
                            complateBlock(model.data, model.code, model.msg)
                        }
                        else {
                            complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据解析失败了")
                        }
                    }
                    else if let dataStr = String(data: data, encoding: String.Encoding.utf8) {
                        Log(message: "非JSON数据-->\(dataStr)")
                        Log(message: "\(dataStr)")
                        complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                    }
                    else {
                        complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                    }
                    
                    Log(message: "+++++++++++++++ 数据解析结束 +++++++++++++++")
                    Log(message: "++++++++++++++++++++++++++++++++++++++++++")
                    Log(message: "\n")
                }
                else {
                    if let err = dataResponse.result.error {
                        Log(message: "\(err.localizedDescription)")
                    }
                    complateBlock(nil, TERequestStatusCode.Failture.rawValue, "数据请求失败了")
                    Log(message: "+++++++++++++++ 请求结束 +++++++++++++++")
                    Log(message: "+++++++++++++++++++++++++++++++++++++++")
                }
        }
        
        return request
    }
    
    /// 普通请求
    /// Request Code
    @discardableResult
    static func dataRequestForPOSTWithCode(with reqCode: String,
                                   parameters: [String: Any]? = nil,
                                   requestInfo: [String: Any]? = nil,
                                   complateBlock: @escaping ((_ object: Any?, _ status: Int, _ message: String?) -> Void)) -> DataRequest? {
        
        let oauthHandler = TEOAuthHandler(parameters: parameters)
        defaultSessionManager.adapter = oauthHandler
        defaultSessionManager.retrier = oauthHandler
        
        var urlStr = httpRequestBaseApi + reqCode
        
        // 去掉前后空格，地址前面有空格时会报URL is not valid
        urlStr = (urlStr as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        
        let request = defaultSessionManager.request(urlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseData { (dataResponse) in
            
            //+++++++++++++++++++++++++++++ Print +++++++++++++++++++++++++++++++++
            Log(message: "URL--> \(urlStr)")
            
            Log(message: "+++++++++++++++ 请求已返回 +++++++++++++++")
            
            Log(message: "+++++++++++++++ Time line +++++++++++++++")
            Log(message: "\(dataResponse.timeline)")
            Log(message: "+++++++++++++++ Time End +++++++++++++++")
                
            /// 打印请求信息，便于出错时调试
            Log(message: "+++++++++++++++ 请求信息 ++++++++++++++++")
            if let req = dataResponse.request {
                Log(message: "URL--> \(req.url?.absoluteString ?? "")")
                if let httpHeader = req.allHTTPHeaderFields {
                    Log(message: "request.allHeaderFields: \(JSON(httpHeader))")
                }
            }
            
            if let parameters_ = parameters {
                Log(message: "请求参数->\n \(JSON(parameters_))")
            }
            
            Log(message: "+++++++++++++++++++++++++++++++++++++++")
            Log(message: "+++++++++++++++ 服务器响应信息 +++++++++++++++")
            if let resp = dataResponse.response {
                Log(message: "response.statusCode: \(resp.statusCode)")
                Log(message: "response.allHeaderFields: \(JSON(resp.allHeaderFields))")
            }
            
            Log(message: "++++++++++++++++++++++++++++++++++++++++++++")
            
            //+++++++++++++++++++++++++++++ Parse +++++++++++++++++++++++++++++++++
            Log(message: "+++++++++++++++ 开始数据解析 +++++++++++++++")
            if dataResponse.result.isSuccess {
                
                guard let data = dataResponse.data else {
                    // 无数据
                    Log(message: "data 为空!")
                    complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据为空")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    Log(message: "JSON-->")
                    Log(message: "\(JSON(json))")
                    
                    if let dict = json as? [String: Any], let model = Mapper<AlamofireMappleModel>().map(JSON: dict) {
                        if model.code == TERequestStatusCode.ClientMissingParameters.rawValue {
                            TELog(message: "客户端缺少参数!")
                        }
                        else if model.code == TERequestStatusCode.ClientVerifyNotPass.rawValue {
                            TELog(message: "客户端校验不通过!")
                        }
                        else if model.code == TERequestStatusCode.ClientVersionError.rawValue {
                            TELog(message: "客户端版本号错误!")
                        }
                        else if model.code == TERequestStatusCode.SignOutDate.rawValue {
                            TELog(message: "签名已过期!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_SIGN_OUT_DATE_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.MissingToken.rawValue {
                            TELog(message: "缺少Token!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.NeedToLogin.rawValue {
                            TELog(message: "请先登录")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.ForceOffline.rawValue {
                            // 被挤下线，直接弹出登录页面
                            TELog(message: "您被挤下线了!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.AccountLocked.rawValue {
                            TELog(message: "账户被禁用!")
                        }
                        else if model.code == TERequestStatusCode.AccountNoneExist.rawValue {
                            TELog(message: "账户不存在!")
                        }
                        else if model.code == TERequestStatusCode.InactiveToken.rawValue || model.code == -3 {
                            TELog(message: "token无效!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_TOKEN_INCATIVE_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.UpdateTokenFail.rawValue {
                            TELog(message: "更新token失败!")
                        }
                        else if model.code == TERequestStatusCode.ParameterMissing.rawValue {
                            TELog(message: "缺少请求参数!")
                        }
                        // ... 其他code在具体请求里处理
                        
                        complateBlock(model.data, model.code, model.msg)
                    }
                    else {
                        complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据解析失败了")
                    }
                }
                else if let dataStr = String(data: data, encoding: String.Encoding.utf8) {
                    Log(message: "非JSON数据-->\(dataStr)")
                    Log(message: "\(dataStr)")
                    complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                }
                else {
                    complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                }
                
                Log(message: "+++++++++++++++ 数据解析结束 +++++++++++++++")
                Log(message: "++++++++++++++++++++++++++++++++++++++++++")
                Log(message: "\n")
            }
            else {
                if let err = dataResponse.result.error {
                    Log(message: "\(err.localizedDescription)")
                }
                complateBlock(nil, TERequestStatusCode.Failture.rawValue, "数据请求失败了")
                Log(message: "+++++++++++++++ 请求结束 +++++++++++++++")
                Log(message: "+++++++++++++++++++++++++++++++++++++++")
            }
        }
        
        return request
    }
    
    /// 请求+Mapper
    @discardableResult
    static func dataRequestForPOSTWithMapple<T: Mappable>(with reqCode: String,
                                           parameters: [String: Any]? = nil,
                                           requestInfo: [String: Any]? = nil,
                                           complateBlock: @escaping (T?, Int, String?) -> Void) -> DataRequest? {
        
        let oauthHandler = TEOAuthHandler(parameters: parameters)
        defaultSessionManager.adapter = oauthHandler
        defaultSessionManager.retrier = oauthHandler
        
        var urlStr = httpRequestBaseApi + reqCode
        
        // 去掉前后空格，地址前面有空格时会报URL is not valid
        urlStr = (urlStr as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        
        let request = defaultSessionManager.request(urlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseData { (dataResponse) in
            
            //+++++++++++++++++++++++++++++ Print +++++++++++++++++++++++++++++++++
            TELog(message: "URL--> \(urlStr)")
            Log(message: "+++++++++++++++ 请求已返回 +++++++++++++++")
            /// 打印请求信息，便于出错时调试
            Log(message: "+++++++++++++++ 请求信息 ++++++++++++++++")
            if let req = dataResponse.request {
                Log(message: "URL--> \(req.url?.absoluteString ?? "")")
                if let httpHeader = req.allHTTPHeaderFields {
                    Log(message: "request.allHeaderFields: \(JSON(httpHeader))")
                }
            }
            
            Log(message: "+++++++++++++++ 服务器响应信息 +++++++++++++++")
            if let resp = dataResponse.response {
                Log(message: "response.statusCode: \(resp.statusCode)")
                Log(message: "response.allHeaderFields: \(JSON(resp.allHeaderFields))")
            }
            
            Log(message: "++++++++++++++++++++++++++++++++++++++++++++")
            
            //+++++++++++++++++++++++++++++ Parse +++++++++++++++++++++++++++++++++
            Log(message: "+++++++++++++++ 开始数据解析 +++++++++++++++")
            if dataResponse.result.isSuccess {
                
                guard let data = dataResponse.data else {
                    // 无数据
                    Log(message: "data 为空!")
                    complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据为空")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    Log(message: "JSON数据-->")
                    Log(message: "\(JSON(json))")
                    
                    if let dict = json as? [String: Any], let model = Mapper<AlamofireMappleModel>().map(JSON: dict) {
                        
                        if model.code == TERequestStatusCode.ClientMissingParameters.rawValue {
                            TELog(message: "客户端缺少参数!")
                        }
                        else if model.code == TERequestStatusCode.ClientVerifyNotPass.rawValue {
                            TELog(message: "客户端校验不通过!")
                        }
                        else if model.code == TERequestStatusCode.ClientVersionError.rawValue {
                            TELog(message: "客户端版本号错误!")
                        }
                        else if model.code == TERequestStatusCode.SignOutDate.rawValue {
                            TELog(message: "签名已过期!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_SIGN_OUT_DATE_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.MissingToken.rawValue {
                            TELog(message: "缺少Token!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.AccountLocked.rawValue {
                            TELog(message: "账户被禁用!")
                        }
                        else if model.code == TERequestStatusCode.AccountNoneExist.rawValue {
                            TELog(message: "账户不存在!")
                        }
                        else if model.code == TERequestStatusCode.InactiveToken.rawValue || model.code == -3 {
                            TELog(message: "token无效!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_TOKEN_INCATIVE_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.UpdateTokenFail.rawValue {
                            TELog(message: "更新token失败!")
                        }
                        else if model.code == TERequestStatusCode.ParameterMissing.rawValue {
                            TELog(message: "缺少请求参数!")
                        }
                        // ... 其他code在具体请求里处理
                        
                        let tModel = Mapper<T>().map(JSON: dict)
                        complateBlock(tModel, model.code, model.msg)
                    }
                    else {
                        complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据解析失败了")
                    }
                }
                else if let dataStr = String(data: data, encoding: String.Encoding.utf8) {
                    Log(message: "非JSON数据-->\(dataStr)")
                    Log(message: "\(dataStr)")
                    complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                }
                else {
                    complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                }
                
                Log(message: "+++++++++++++++ 数据解析结束 +++++++++++++++")
                Log(message: "++++++++++++++++++++++++++++++++++++++++++++")
                Log(message: "\n")
            }
            else {
                if let err = dataResponse.result.error {
                    Log(message: "\(err.localizedDescription)")
                }
                complateBlock(nil, TERequestStatusCode.Failture.rawValue, "数据请求失败了")
                Log(message: "+++++++++++++++ 请求结束 +++++++++++++++")
                Log(message: "++++++++++++++++++++++++++++++++++++++++++++")
            }
        }
        
        return request
    }
    
    /// 请求+Mapper+keyPath
    @discardableResult
    static func dataRequestForPOSTWithMapple<T: Mappable>(with reqCode: String,
                                                          parameters: [String: Any]? = nil,
                                                          requestInfo: [String: Any]? = nil,
                                                          jsonKeyPath: String? = nil,
                                                          complateBlock: @escaping ((_ resModel: T?, _ status: Int, _ message: String?) -> Void)) -> DataRequest? {
        
        let oauthHandler = TEOAuthHandler(parameters: parameters)
        defaultSessionManager.adapter = oauthHandler
        defaultSessionManager.retrier = oauthHandler
        
        var urlStr = httpRequestBaseApi + reqCode
        
        // 去掉前后空格，地址前面有空格时会报URL is not valid
        urlStr = (urlStr as NSString).trimmingCharacters(in: CharacterSet.whitespaces)
        
        let request = defaultSessionManager.request(urlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseData { (dataResponse) in
            
            //+++++++++++++++++++++++++++++ Print +++++++++++++++++++++++++++++++++
            TELog(message: "URL--> \(urlStr)")
            Log(message: "+++++++++++++++ 请求已返回 +++++++++++++++")
            /// 打印请求信息，便于出错时调试
            Log(message: "+++++++++++++++ 请求信息 ++++++++++++++++")
            if let req = dataResponse.request {
                Log(message: "URL--> \(req.url?.absoluteString ?? "")")
                if let httpHeader = req.allHTTPHeaderFields {
                    Log(message: "request.allHeaderFields: \(JSON(httpHeader))")
                }
            }
            
            Log(message: "+++++++++++++++ 服务器响应信息 +++++++++++++++")
            if let resp = dataResponse.response {
                Log(message: "response.statusCode: \(resp.statusCode)")
                Log(message: "response.allHeaderFields: \(JSON(resp.allHeaderFields))")
            }
            
            Log(message: "++++++++++++++++++++++++++++++++++++++++++++")
            
            //+++++++++++++++++++++++++++++ Parse +++++++++++++++++++++++++++++++++
            Log(message: "+++++++++++++++ 开始数据解析 +++++++++++++++")
            if dataResponse.result.isSuccess {
                
                guard let data = dataResponse.data else {
                    // 无数据
                    Log(message: "data 为空!")
                    complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据为空")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    Log(message: "JSON数据-->")
                    Log(message: "\(JSON(json))")
                    
                    var jsonData: AnyObject?
                    if let keyPath = jsonKeyPath, !keyPath.isEmpty {
                        if let objectForKeyPath = (json as AnyObject).value(forKeyPath: keyPath) {
                            jsonData = objectForKeyPath as AnyObject
                        }
                        else {
                            jsonData = json as AnyObject
                        }
                    }
                    else {
                        jsonData = json as AnyObject
                    }
                    
                    if let dict = jsonData as? [String: Any], let model = Mapper<AlamofireMappleModel>().map(JSON: dict) {
                        
                        if model.code == TERequestStatusCode.ClientMissingParameters.rawValue {
                            TELog(message: "客户端缺少参数!")
                        }
                        else if model.code == TERequestStatusCode.ClientVerifyNotPass.rawValue {
                            TELog(message: "客户端校验不通过!")
                        }
                        else if model.code == TERequestStatusCode.ClientVersionError.rawValue {
                            TELog(message: "客户端版本号错误!")
                        }
                        else if model.code == TERequestStatusCode.SignOutDate.rawValue {
                            TELog(message: "签名已过期!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_SIGN_OUT_DATE_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.MissingToken.rawValue {
                            TELog(message: "缺少Token!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_MISSING_TOKEN_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.AccountLocked.rawValue {
                            TELog(message: "账户被禁用!")
                        }
                        else if model.code == TERequestStatusCode.AccountNoneExist.rawValue {
                            TELog(message: "账户不存在!")
                        }
                        else if model.code == TERequestStatusCode.InactiveToken.rawValue || model.code == -3 {
                            TELog(message: "token无效!")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_TOKEN_INCATIVE_NOTIFICATION), object: model.code)
                        }
                        else if model.code == TERequestStatusCode.UpdateTokenFail.rawValue {
                            TELog(message: "更新token失败!")
                        }
                        else if model.code == TERequestStatusCode.ParameterMissing.rawValue {
                            TELog(message: "缺少请求参数!")
                        }
                        // ... 其他code在具体请求里处理
                        
                        let tModel = Mapper<T>().map(JSON: dict)
                        complateBlock(tModel, model.code, model.msg)
                    }
                    else {
                        complateBlock(nil, TERequestStatusCode.NullData.rawValue, "数据解析失败了")
                    }
                }
                else if let dataStr = String(data: data, encoding: String.Encoding.utf8) {
                    Log(message: "非JSON数据-->\(dataStr)")
                    Log(message: "\(dataStr)")
                    complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                }
                else {
                    complateBlock(nil, TERequestStatusCode.NotJSON.rawValue, "JSON数据解析失败了")
                }
                
                Log(message: "+++++++++++++++ 数据解析结束 +++++++++++++++")
                Log(message: "\n")
            }
            else {
                if let err = dataResponse.result.error {
                    Log(message: "\(err.localizedDescription)")
                }
                complateBlock(nil, TERequestStatusCode.Failture.rawValue, "数据请求失败了")
                Log(message: "+++++++++++++++ 请求结束 +++++++++++++++")
            }
        }
        
        return request
    }
    
    
}





