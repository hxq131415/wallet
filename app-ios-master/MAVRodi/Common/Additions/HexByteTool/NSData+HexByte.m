//
//  NSData+HexByte.m
//  SocketProcessDemo
//
//  Created by rttx on 2018/7/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import "NSData+HexByte.h"

@implementation NSData (HexByte)

/// NSData hex字节数据转为十六进制字符串
- (NSString *)hexStringFromData {
    
    if (self.length == 0) {
        return nil;
    }
    
    NSMutableString * mutableHexString = [[NSMutableString alloc] initWithCapacity:10];
    
    [self enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        Byte * dataBytes = (Byte *)bytes;
        for (NSUInteger i = 0; i < byteRange.length; i++) {
            Byte byte_ = (Byte)(dataBytes[i] & 0xFF);
            NSString * hexString = [NSString stringWithFormat:@"%02X", byte_];
            [mutableHexString appendFormat:@"%@ ", hexString];
        }
    }];
    
    return mutableHexString;
}

// Byte Data 指定range 转为 hex String
// Data <ff00b601 1103> range(4, 2) -> "11 03"
- (NSString *)hexStringFromDataWithRange:(NSRange)range {
    
    if ([self length] == 0) {
        return nil;
    }
    
    if (range.location < self.length && (range.location + range.length > self.length)) {
        range.length = self.length - range.location;
    }
    
    if (!((range.location + range.length) <= self.length)) {
        MRLog(@"参数`range`不合法，请检查range是否有误.");
        return nil;
    }
    
    NSData * subByteData = [self subdataWithRange:range];
    
    NSString * subHexString = [subByteData hexStringFromData];
    
    return subHexString;
}

@end
