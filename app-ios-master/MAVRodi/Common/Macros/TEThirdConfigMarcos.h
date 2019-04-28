//
//  TEThirdConfigMarcos.h
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/10.
//  Copyright © 2018年 rttx. All rights reserved.
//
/// 存放第三方AppID、AppKey等配置信息

#ifndef TEThirdConfigMarcos_h
#define TEThirdConfigMarcos_h

// 极光推送相关
static NSString * const TEJPushAppKey = @"9d0fc1518687254465d1e66e";
static NSString * const TEJPushChannel = @"AppStore";

// 腾讯移动分析
static NSString * const TE_QQMTA_APPID = @"3203523892";
static NSString * const TE_QQMTA_APPKEY = @"I4VZ4M7ZI5WW";

// 微信相关
// AppID
static NSString * const TE_WeChat_App_ID = @"wx94b55b1fbc62dd64";
// AppSecret
static NSString * const TE_WeChat_App_Sceret = @"96b50e49da34faa9fef13a39cf0dcfbd";

// QQ相关
// AppID
static NSString * const TE_QQ_App_ID = @"101472211";
// AppKEY
static NSString * const TE_QQ_App_Key = @"df0b8ebd91a193901fec9a7e3209a162";

// 新浪微博相关
// AppKEY
static NSString * const TE_SinaWeibo_App_Key = @"974077306";
// AppSecret
static NSString * const TE_SinaWeibo_App_Sceret = @"e00488849496aabaf0b70bc3d9c3bb65";
// redirectUri
static NSString * const TE_SinaWeibo_RedirectUri = @"https://api.weibo.com/oauth2/default.html";

// 支付宝相关
// 后端加签###
// AppID
static NSString * const TE_Alipay_App_ID = @"";

// RSA私钥，接入后端加签后需要删除！
#if DEBUG
#define TE_Alipay_RSA2_Private_Key @""
#else
#define TE_Alipay_RSA2_Private_Key @""
#endif

// 腾讯云 Cos APPID
static NSString * const QCloud_COS_AppID = @"1253753824";

#endif /* TEThirdConfigMarcos_h */
