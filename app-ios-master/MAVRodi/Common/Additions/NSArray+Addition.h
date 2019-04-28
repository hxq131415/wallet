//
//  NSArray+Addition.h
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/2.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Addition)

/// 字符串数据按照ASCII码升序排序
- (NSArray *)compareUsingASCIISortedByASC;
/// 字符串排序
- (NSArray *)compareUsingComparator;

@end
