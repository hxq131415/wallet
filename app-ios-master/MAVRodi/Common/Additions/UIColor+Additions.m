//
//  UIColor+Additions.m
//  NTMember
//
//  Created by rttx on 2018/3/5.
//  Copyright © 2018年 MT. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

// 返回UIColor的RGB描述字符串
- (NSString *)rgbAlphaDescription {
    
    CGFloat red, green, blue, alpha;
    
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    else {
        const CGFloat * components = CGColorGetComponents(self.CGColor);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    
    NSString * rgbDescription = [NSString stringWithFormat:@"r%.3f_g%.3f_b%.3f_a%.3f", red, green, blue, alpha];
    return rgbDescription;
}

// RGB描述字符串提取UIColor
+ (UIColor *)colorFromRgbAlphaDescription:(NSString *)rgbDescription {
    
    if (rgbDescription && ![rgbDescription isEqualToString:@""]) {
        if ([rgbDescription rangeOfString:@"_"].location != NSNotFound) {
            NSArray * arr = [rgbDescription componentsSeparatedByString:@"_"];
            if (arr.count >= 3) {
                CGFloat red, green, blue, alpha;
                red   = [[arr[0] substringFromIndex:1] floatValue];
                green = [[arr[1] substringFromIndex:1] floatValue];
                blue  = [[arr[2] substringFromIndex:1] floatValue];
                alpha = [[arr[3] substringFromIndex:1] floatValue];
                
                UIColor * rgbColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
                return rgbColor;
            }
        }
    }
    return nil;
}

@end
