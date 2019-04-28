//
//  TENotificationKeyMarcos.h
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/10.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  通知Key定义
//  命名规则：NNKEY+...+NOTIFICATION

#import <Foundation/Foundation.h>

#ifndef TENotificationKeyMarcos_h
#define TENotificationKeyMarcos_h

// 登录成功通知
static NSString * NNKEY_LOGIN_SUCCESS_NOTIFICATION = @"NNKEY_LOGIN_SUCCESS_NOTIFICATION";
// 退出登录通知
static NSString * NNKEY_LOGOUT_NOTIFICATION = @"NNKEY_LOGOUT_NOTIFICATION";

// 签名已过期通知
static NSString * NNKEY_SIGN_OUT_DATE_NOTIFICATION = @"NNKEY_SIGN_OUT_DATE_NOTIFICATION";

// Token失效通知
static NSString * NNKEY_TOKEN_INCATIVE_NOTIFICATION = @"NNKEY_TOKEN_INCATIVE_NOTIFICATION";
// Token更新成功通知
static NSString * NNKEY_TOKEN_UPDATE_SUCCESS_NOTIFICATION = @"NNKEY_TOKEN_UPDATE_SUCCESS_NOTIFICATION";

// 缺少Token
static NSString * NNKEY_MISSING_TOKEN_NOTIFICATION = @"NNKEY_MISSING_TOKEN_NOTIFICATION";

// App语言切换通知
static NSString * NNKEY_APP_LANAGUAGE_CHANGED_NOTIFICATION = @"NNKEY_APP_LANAGUAGE_CHANGED_NOTIFICATION";
// 需要更新会员信息数据通知
static NSString * NNKEY_NEED_TO_UPDATE_USERDATA_NOTIFICATION = @"NNKEY_NEED_TO_UPDATE_USERDATA_NOTIFICATION";

// App首页将要显示通知
static NSString * const NNKEY_HOME_PAGE_VIEW_WILL_APPEAR = @"NNKEY_HOME_PAGE_VIEW_WILL_APPEAR";

// 资金首页
static NSString * const NNKEY_PLAN_RECORD_NOTIFICATION = @"NNKEY_PLAN_RECORD_NOTIFICATION";


#endif /* TENotificationKeyMarcos_h */
