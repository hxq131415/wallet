//
//  TEUDKeyMarcos.h
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/10.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  UserDefaults Key 定义
//  规则：UDKEY_XXX

#ifndef TEUDKeyMarcos_h
#define TEUDKeyMarcos_h

#pragma mark - 用户相关
// token Key
static NSString * const UDKEY_LOGIN_TOKEN = @"UDKEY_LOGIN_TOKEN";
// refresh token
static NSString * const UDKEY_LOGIN_REFRESH_TOKEN = @"UDKEY_LOGIN_REFRESH_TOKEN";
// 登录账号
static NSString * const UDKEY_LOGIN_USER_EMAIL = @"UDKEY_LOGIN_USER_EMAIL";
// 用户登录数据
static NSString * const UDKEY_USER_LOGIN_DATA = @"UDKEY_USER_LOGIN_DATA";
// 会员信息
static NSString * const UDKEY_USER_INFO_DATA = @"UDKEY_USER_INFO_DATA";
// 公共配置数据
static NSString * const UDKEY_PUBLIC_CONFIG_INFO = @"UDKEY_PUBLIC_CONFIG_INFO";
// App当前设置语言
static NSString * const UDKEY_APP_CURRENT_SET_LANGUAGE = @"UDKEY_APP_CURRENT_SET_LANGUAGE";


// 腾讯云临时上传凭证
static NSString * const UDKEY_QCLOUD_UPLOAD_CER_INFO = @"UDKEY_QCLOUD_UPLOAD_CER_INFO";
// App 版本号
static NSString * const UDKEY_TE_APP_VERSION = @"UDKEY_TE_APP_VERSION";
// 是否是暂不更新新版本
static NSString * const UDKEY_IS_NOT_TO_UPDATE_NEW_VERSION = @"UDKEY_IS_NOT_TO_UPDATE_NEW_VERSION";

// App DEBUG下 环境
static NSString * const UDKEY_APP_ENVIRONMENT = @"UDKEY_APP_ENVIRONMENT";

#endif /* TEUDKeyMarcos_h */
