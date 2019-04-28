//
//  NSString+HexByte.h
//  SocketProcessDemo
//
//  Created by rttx on 2018/7/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HexByte)

/// 十六进制字符串 -> Byte Array Data
/// 00 FF 0A 0D -> <00ff0a0d>
- (NSData *)hexByteDataWithHexString;

/// 十六进制字符串 -> 十进制字符串
/// 0A -> 10
- (NSString *)decimalStringFromHexString;

/// 十六进制字符串 -> 十进制数
/// 0D0A(0D 0A) -> 3338
- (unsigned long)decimalValueFromHexString;

/// ASCII字符格式字符串 -> 十六进制字符串
/// 智能硬件传输数据时有时会以ASCII码字符格式，以十六进制的Byte Data传输 如WIFI账号密码等.
/// 如Port "8899" -> "38 38 39 39".
- (NSString *)hexStringFromAsciiCharaterString;

/// ASCII格式字符串 -> Hex Bytes
- (Byte *)hexByteArrayFromAsciiCharaterString;

/// ASCII格式字符串 -> Hex Byte Data
- (NSData *)hexByteDataFromAsciiCharaterString;

@end
