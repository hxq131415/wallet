//
//  NSData+HexByte.h
//  SocketProcessDemo
//
//  Created by rttx on 2018/7/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HexByte)

/// 十六进制字节Data -> 十六进制字符串
/// NSData <0001ffcc0a0d> -> "00 01 FF CC 0A 0D"
- (NSString *)hexStringFromData;

/// 十六进制字节Data 指定 range -> 十六进制字符串
/// NSData <ff00b601 1103> range(4, 2) -> "11 03"
- (NSString *)hexStringFromDataWithRange:(NSRange)range;



@end
