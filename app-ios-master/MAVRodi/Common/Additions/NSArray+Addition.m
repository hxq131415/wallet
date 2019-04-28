//
//  NSArray+Addition.m
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/2.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import "NSArray+Addition.h"
#import <Foundation/Foundation.h>

@implementation NSArray (Addition)

// 字符串数据按照ASCII码升序排序
- (NSArray *)compareUsingASCIISortedByASC {
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch
    | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    NSComparator sortor = ^(NSString * obj1, NSString * obj2) {
        NSRange range = NSMakeRange(0, obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    NSArray * resultArr = [self sortedArrayUsingComparator:sortor];
    
    return resultArr;
}

- (NSArray *)compareUsingComparator {
    
    NSArray * sortedArr = [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return sortedArr;
}

@end
