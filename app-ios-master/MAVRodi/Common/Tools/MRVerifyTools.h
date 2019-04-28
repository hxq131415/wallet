//
//  TEVerifyTools.h
//  NTMember
//
//  Created by rttx on 2018/2/26.
//  Copyright © 2018年 MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRVerifyTools : NSObject

/**
 - 判断是否是合法手机号码
 - YES 是， NO，非法手机号码
 */
+ (BOOL)verifyMobilePhoneNum:(NSString *)mobilePhone;
// 判断邮箱  - YES 合法， NO 非法
+ (BOOL)verifyEmailNum:(NSString *)email;
// 限制输入两位小数
+ (BOOL)verifyInputNumberDoubleBit:(NSString *)numStr;
// 限制输入正整数
+ (BOOL)verifyInputNumberPositiveInteger:(NSString *)numStr;
// 限制输入正整数+0
+ (BOOL)verifyInputNumberPositiveIntegerWithZero:(NSString *)numStr;
// 校验是否是合法的身份证号
+ (BOOL)verifyIdentifyCard:(NSString *)idCard;
// 匹配车牌号后五位
+ (BOOL)verifyPlateNumSubfixFiveNum:(NSString *)plate_SubNum;

// 验证只包含数字
+ (BOOL)verifyOnlyContainsNumber:(NSString *)text;
// 验证只包含字母
+ (BOOL)verifyOnlyContainsCharater:(NSString *)text;
// 验证只包含字母+数字，不包含特殊字符
+ (BOOL)verifyContainsNumberAndCharater:(NSString *)text;
// 验证是否包含 数字 字母 特殊字符，且大于等于8位
+ (BOOL)verifyContainsNumberLetterAndSpecialChars:(NSString *)text;
// 验证是否包含数字和字母
+ (BOOL)verifyContainsNumberOrLetter:(NSString *)text;
// 验证是否包含数字/包含特殊字符
+ (BOOL)verifyContainsNumber:(NSString *)text;
// 验证是否包含字母
+ (BOOL)verifyContainsLetter:(NSString *)text;
// 验证是否包含大写字母
+ (BOOL)verifyContainsCapitalLetter:(NSString *)text;
// 验证是否包含小写字母
+ (BOOL)verifyContainsLowerLetter:(NSString *)text;
// 验证是否包含数字/不包含特殊字符
+ (BOOL)verifyContainsIncludeNumber:(NSString *)text;

@end
