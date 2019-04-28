//
//  TEOAuthHandler.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/8/2.
//  Copyright © 2018年 rttx. All rights reserved.
//

import Foundation
import Alamofire

class TEOAuthHandler: RequestAdapter, RequestRetrier {
    
    public var parameters: Parameters?
    
    init(parameters: Parameters?) {
        self.parameters = parameters
    }
    
    // MARK: - Adapter for Request
    // 包装HttpHeaders
    private func packageHttpHeadersFields() -> [String: String] {
        
        var headerFields: HTTPHeaders = [:]
        
        if let token = UserDefaults.standard.value(forKey: UDKEY_LOGIN_TOKEN) as? String {
            headerFields["token"] = token
        }
        
        if let infoDict = Bundle.main.infoDictionary, let clientVersion = infoDict["CFBundleShortVersionString"] as? String {
            headerFields["client-version"] = clientVersion
        }
        
        if let udid = UIDevice.current.uuid() {
            headerFields["client-id"] = udid
        }
        
        headerFields["client-type"] = "IOS"
        // gzip解压数据
        headerFields["accept-encoding"] = "gzip"
        // Content-Type
        headerFields["Content-Type"] = "application/json"
        // Language 客户端语言 zh-cn中文 en-us英文
        if MRTools.currentSystemLanguageType() == .en_us {
            headerFields["Accept-Language"] = "en-us"
        }
        else {
            headerFields["Accept-Language"] = "zh-cn"
        }
        
        return headerFields
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        var urlReq = urlRequest
        
        let httpHeaderFields: [String: String] = self.packageHttpHeadersFields()
        urlReq.allHTTPHeaderFields = httpHeaderFields
        
        return urlReq
    }
    
    // MARK: - Retrier for Request
    // 暂时无法处理，需要检测到token过期
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
    }
    
    
}

