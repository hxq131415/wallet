//
//  NSString+Additions.h
//  NTMember
//
//  Created by rttx on 2017/12/23.
//  Copyright © 2017年 MT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)
- (BOOL)isEmpty;
+ (void)parseEmojiUnicodeSaveToFile;
+ (NSString *)readEmojiUnicodeStringFromFile;
// 判断是否包含emoji表情
+ (BOOL)isContainsEmoji:(NSString *)string;

// Crypto
- (NSString *)md5;
- (NSString *)sha1;

#pragma mark - 变化的时间
+ (NSString *)timeChangeTimeEnd:(NSString *)timeEnd;
@end
