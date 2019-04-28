//
//  NSString+HexByte.m
//  SocketProcessDemo
//
//  Created by rttx on 2018/7/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import "NSString+HexByte.h"

@implementation NSString (HexByte)

// 十六进制字符串转为字节数组Data
- (NSData *)hexByteDataWithHexString {
    
    NSString * tmpString = self;
    tmpString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    tmpString = [tmpString lowercaseString];
    tmpString = [tmpString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    
    if ([tmpString length] < 2) {
        NSLog(@"hex string 长度必须大于1!");
        return nil;
    }
    
    if ([tmpString length] % 2 == 1) {
        NSLog(@"转换 byte array 失败，请检查hex string是否有误!");
        return nil;
    }
    
    NSUInteger byteLength = [tmpString length] / 2;
    Byte dataByteArray[byteLength];
    
    NSUInteger maxLength = tmpString.length % 2 == 0 ? tmpString.length : tmpString.length - 1;
    for (NSUInteger index = 0; index < maxLength; index += 2) {
        NSString * subHexString = [tmpString substringWithRange:NSMakeRange(index, 2)];
        NSString * subDecimalString = [subHexString decimalStringFromHexString];
        NSInteger byteValue = subDecimalString.integerValue;
        dataByteArray[index / 2] = byteValue;
    }
    
    NSData * byteData = [NSData dataWithBytes:dataByteArray length:byteLength];
    return byteData;
}

// 十六进制字符串 -> 十进制字符串
- (NSString *)decimalStringFromHexString {
    
    NSString * tmpSting = [self stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSString * decimalString = [NSString stringWithFormat:@"%lu", strtoul([tmpSting UTF8String], 0, 16)];
    return decimalString;
}

// 十六进制字符串 -> 十进制数
- (unsigned long)decimalValueFromHexString {
    
    if ([self length] == 0) {
        return 0;
    }
    
    NSString * tmpString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    unsigned long decimalValue = strtoul([tmpString UTF8String], 0, 16);
    return decimalValue;
}

// ASCII字符 -> 十六进制字符串
// 智能硬件传输数据时有时会以ASCII码字符格式，以十六进制的Byte Data传输.
// 如Port "8899" -> Byte {0x38,0x38,0x39,0x39}.
- (NSString *)hexStringFromAsciiCharaterString {
    
    NSString * tmpString = self;
    tmpString = [tmpString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([tmpString length] == 0) {
        return nil;
    }
    
    NSMutableString * hexString = [[NSMutableString alloc] initWithCapacity:10];
    for (NSUInteger index = 0; index < tmpString.length; index++) {
        unsigned int asciiCodeValue = [tmpString characterAtIndex:index];
        Byte asciiByte = (Byte)(asciiCodeValue & 0xFF);
        NSString * hexSubString = [NSString stringWithFormat:@"%02X ", asciiByte];
        [hexString appendString:hexSubString];
    }
    
    return hexString;
}

- (Byte *)hexByteArrayFromAsciiCharaterString {
    
    NSString * tmpString = self;
    tmpString = [tmpString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([tmpString length] == 0) {
        return nil;
    }
    
    Byte * bytes = malloc(tmpString.length);
    
    for (NSUInteger index = 0; index < tmpString.length; index++) {
        unsigned int asciiCodeValue = [tmpString characterAtIndex:index];
        Byte asciiByte = (Byte)(asciiCodeValue & 0xFF);
        bytes[index] = asciiByte;
    }
    
    return bytes;
}

/// ASCII格式字符串 -> Hex Byte Data
- (NSData *)hexByteDataFromAsciiCharaterString {
    
    NSString * hexString = [self hexStringFromAsciiCharaterString];
    
    if (hexString == nil) {
        return nil;
    }
    
    if (hexString.length == 0) {
        return nil;
    }
    
    NSData * hexByteData = [hexString hexByteDataWithHexString];
    return hexByteData;
}

@end
