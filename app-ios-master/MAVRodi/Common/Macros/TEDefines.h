//
//  TEDefines.h
//  TeaExpoentNet
//
//  Created by rttx on 2018/7/2.
//  Copyright © 2018年 rttx. All rights reserved.
//

#ifndef TEDefines_h
#define TEDefines_h

/** Const defines */

#if DEBUG
#define MRLog(...) NSLog(@"[%@:(%d)] %s", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__); \
NSLog(__VA_ARGS__)
#else
#define MRLog(...) {}
#endif

// 显示BETA标识
#if DEBUG
#define iSBETA  1
#else
#define iSBETA  0
#endif
// 接口是否启用正式服务器
#define isRelease_forReqURL  1


#define iSiPhoneX \
\
([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)\
\
|| ([UIScreen mainScreen].bounds.size.width == 812 && [UIScreen mainScreen].bounds.size.height == 375)

#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define TE_Screen_Size [UIScreen mainScreen].bounds.size
#define TE_NavigationBar_Height (iSiPhoneX ? 88 : 64)
#define TE_Virtual_Bottom_Height (iSiPhoneX ? 34 : 0)
#define TE_StatusBar_Height  (iSiPhoneX ? 44 : 20)

#endif /* TEDefines_h */
