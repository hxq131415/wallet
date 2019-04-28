//
//  NSString+Additions.m
//  NTMember
//
//  Created by rttx on 2017/12/23.
//  Copyright © 2017年 MT. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonCrypto.h>

#define NT_Emoji_Unicode_FilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"ntqc_emoji_unicode.txt"]

@implementation NSString (Additions)

- (BOOL)isEmpty
{
    return [[self trimWhitespace] isEqualToString:@""];
}

- (NSString * _Nullable)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

// 解析Emoji的Unicode并写入文件
+ (void)parseEmojiUnicodeSaveToFile {
    
    NSString *pathForResource = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"txt"];
    NSURL * fileURL = [NSURL fileURLWithPath:pathForResource];
    NSString * readText = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString * emojiString = [NSMutableString string];
    
    NSArray * textArray1 = [readText componentsSeparatedByString:@"\n"];
    
    if (textArray1.count > 0) {
        for (NSString * textStr in textArray1) {
            if ([textStr containsString:@";"]) {
                NSArray * textArray2 = [textStr componentsSeparatedByString:@";"];
                if (textArray2.count > 1) {
                    NSString * unicodeText = textArray2[1];
                    if ([unicodeText containsString:@"#"]) {
                        NSArray * unicodeTextArray = [unicodeText componentsSeparatedByString:@"#"];
                        if (unicodeTextArray.count > 1) {
                            NSString * emojiText = unicodeTextArray[1];
                            emojiText = [emojiText substringFromIndex:1];
                            if ([emojiText containsString:@" "]) {
                                NSArray * emojiArray = [emojiText componentsSeparatedByString:@" "];
                                if (emojiArray.count > 0) {
                                    NSString * emoji = emojiArray[0];
                                    [emojiString appendString:emoji];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    [emojiString writeToFile:NT_Emoji_Unicode_FilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

// 读取emoji文件返回所有的emoji的Unicode字符串
+ (NSString *)readEmojiUnicodeStringFromFile {
    
    NSURL * fileURL = [NSURL fileURLWithPath:NT_Emoji_Unicode_FilePath];
    NSString * emojiString = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    
    return emojiString;
}

// 判断是否包含emoji表情 (现在只是判断单个输入是否包含，以后需要判断多个字符包含，因为颜文字会包含emoji表情)
+ (BOOL)isContainsEmoji:(NSString *)string {
    
    NSString * emojiStr = [self readEmojiUnicodeStringFromFile];
    if (emojiStr && ![emojiStr isEqualToString:@""]) {
        return [emojiStr containsString:string];
    }
    return NO;
}

// 32位MD5加密
- (NSString *)md5 {
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result copy];
}

// 40位SHA1
- (NSString *)sha1 {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

#pragma mark - 计算时间间隔
+ (NSTimeInterval)timeCountDown:(NSString *)targetTime
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];//初始化管理器
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];//设置格式
    dateFormatter.timeZone = NSTimeZone.systemTimeZone;
    NSDate *endTime = [dateFormatter dateFromString:targetTime];//结束时间
    
    NSDate *startTime = [NSDate date];//得到当前时间
    NSTimeInterval time = [endTime timeIntervalSinceDate:startTime];//时间比较
    //    NSLog(@"%f秒",time);//输出总时间
    return time;
}

#pragma mark - 剩余时间转化
+ (NSString *)timeToGetFormat:(NSTimeInterval)time
{
    int days = ((int)time)/(3600*24);//取天的整数
    int hours = ((int)time)%(3600*24)/3600;//取小时的整数
    int minute = ((int)time)%(3600*24)%3600/60;//取分的整数
    int second = ((int)time)%(3600*24)%3600%60;//取分的余数
    //    NSString *remainingTime = [NSString stringWithFormat:@"%d天%d时%d分%d秒", days, hours, minute, second];//转化
    
    if (days <= 0) days = 0;
    if (hours <= 0) hours = 0;
    if (minute <= 0) minute = 0;
    if (second <= 0) second = 0;
    //时分秒
//    NSString *remainingTime = [NSString stringWithFormat:@"%d-%d-%d", days * 24 + hours, minute, second];//转化
        NSString *remainingTime = [NSString stringWithFormat:@"%d-%d-%d-%d", days, hours, minute, second];//转化
//    if (days > 0) {
//        remainingTime = [NSString stringWithFormat:@"%d-%d-%d", days * 24 + hours, minute, second];//转化
//    }else {
//        remainingTime = [NSString stringWithFormat:@"%d-%d-%d", days * 24 + hours, minute, second];//转化
//    }
    return remainingTime;
}

#pragma mark - 变化的时间
+ (NSString *)timeChangeTimeEnd:(NSString *)timeEnd
{
    __block int timeOver = [self timeCountDown:timeEnd];
    
    NSString *remainingTime = [self timeToGetFormat:timeOver];
    return remainingTime;
}
@end
