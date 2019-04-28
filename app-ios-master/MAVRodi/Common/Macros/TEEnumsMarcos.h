//
//  TEEnumsMarcos.h
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/10.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TEEnumsMarcos_h
#define TEEnumsMarcos_h


/// 支付宝支付结果状态码，具体支付结果以后端为主
/**
 9000    订单支付成功
 8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 4000    订单支付失败
 5000    重复请求
 6001    用户中途取消
 6002    网络连接出错
 6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 其它    其它支付错误
 */
typedef NS_ENUM(NSInteger, TEAlipayResultStatus) {
    Success = 9000, // 成功
    Process = 8000, // 处理中
    Failture = 4000, // 失败
    Repeti   = 5000, // 重复请求
    CancelByUser = 6001, // 用户取消
    NetworkError = 6002, // 网络错误
    Unknown      = 60004, // 结果未知
};

#endif /* TEEnumsMarcos_h */
