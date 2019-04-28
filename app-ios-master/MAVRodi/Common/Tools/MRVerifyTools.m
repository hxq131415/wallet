//
//  NTTools.m
//  NTMember
//
//  Created by rttx on 2018/2/26.
//  Copyright © 2018年 MT. All rights reserved.
//

#import "MRVerifyTools.h"

@implementation MRVerifyTools

/** 校验手机号码是否合法
 - 匹配 <13, 14, 15, 16, 17, 18, 19开头的手机号码>
 - 后面9位为0-9任意数字
 */
+ (BOOL)verifyMobilePhoneNum:(NSString *)mobilePhone {
    
    NSString *regexStr = @"^[1][3,4,5,6,7,8,9][0-9]{9}$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:mobilePhone];
}

/** 校验邮箱是否合法
 - email 待验证邮箱地址
 */
+ (BOOL)verifyEmailNum:(NSString *)email {
    
    NSString *regexStr = @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:email];
}

/** 限制输入两位小数
 - 两位小数输入校验
 */
+ (BOOL)verifyInputNumberDoubleBit:(NSString *)numStr {
    
    NSString * regexStr = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:numStr];
}

/** 限制输入正整数
 - 正整数输入校验
 */
+ (BOOL)verifyInputNumberPositiveInteger:(NSString *)numStr {
    
    NSString * regexStr = @"^[0-9]*[1-9][0-9]*$";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:numStr];
}

/** 限制输入正整数+0
 - 正整数输入校验
 */
+ (BOOL)verifyInputNumberPositiveIntegerWithZero:(NSString *)numStr {
    
    NSString * regexStr = @"^[1-9]\\d*|0$";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:numStr];
}

/**
 - 校验身份证号
 */
+ (BOOL)verifyIdentifyCard:(NSString *)idCard {
    
    NSString * regexStr = @"(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:idCard];
}

/**
 - 匹配车牌号后五位
 - 只匹配 A-Z 0-9 五位
 */
+ (BOOL)verifyPlateNumSubfixFiveNum:(NSString *)plate_SubNum {
    
    NSString * regexStr = @"[A-Z0-9]{5}";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:plate_SubNum];
}

/**
 - 验证是否只包含数字
 */
+ (BOOL)verifyOnlyContainsNumber:(NSString *)text {
    
    NSString * regexStr = @"^[0-9]*$";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}

/**
 - 验证只包含A-Z，a-z字母
 */
+ (BOOL)verifyOnlyContainsCharater:(NSString *)text {
    
    NSString * regexStr = @"^[A-Za-z]+$";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}

/**
 - 验证只包含 字母，数字，不含特殊符号
 */
+ (BOOL)verifyContainsNumberAndCharater:(NSString *)text {
    
    NSString * regexStr = @"^[A-Za-z0-9]+$";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}

/**
 - 验证是否包含 数字 字母 特殊字符，且大于等于8位
 */
+ (BOOL)verifyContainsNumberLetterAndSpecialChars:(NSString *)text {
    
    NSString * regexStr = @"^(?=.*\\d)(?=.*[a-zA-Z])(?=.*[\\W])[\\da-zA-Z\\W]{8,}$";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}

/**
 - 验证是否包含数字或者字母
 */
+ (BOOL)verifyContainsNumberOrLetter:(NSString *)text {
    
    NSString * regexStr = @"[\\da-zA-Z]+";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}

/**
 - 检测是否包含数字/计算特殊字符
 */
+ (BOOL)verifyContainsNumber:(NSString *)text {
    
    NSString * regexStr = @".*\\d+.";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}

/**
 - 检测是否包含字母、特殊字符
 */
+ (BOOL)verifyContainsLetter:(NSString *)text {
    
    NSString * regexStr = @".*[a-zA-Z]+.*";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}

/**
 - 检测是否包含大写字母
 */
+ (BOOL)verifyContainsCapitalLetter:(NSString *)text {
    
    NSString * regexStr = @".*[A-Z]+.*";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}

/**
 - 检测是否包含小写字母
 */
+ (BOOL)verifyContainsLowerLetter:(NSString *)text {
    
    NSString * regexStr = @".*[a-z]+.*";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}
/**
 - 检测是否包含数字/不计算特殊字符
 */
+ (BOOL)verifyContainsIncludeNumber:(NSString *)text {
    
    NSString * regexStr = @".*[0-9]+.*";
    NSPredicate * regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [regexPredicate evaluateWithObject:text];
}
@end
