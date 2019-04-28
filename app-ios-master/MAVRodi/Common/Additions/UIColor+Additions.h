//
//  UIColor+Additions.h
//  NTMember
//
//  Created by rttx on 2018/3/5.
//  Copyright © 2018年 MT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

- (NSString *)rgbAlphaDescription;
+ (UIColor *)colorFromRgbAlphaDescription:(NSString *)rgbDescription;

@end
