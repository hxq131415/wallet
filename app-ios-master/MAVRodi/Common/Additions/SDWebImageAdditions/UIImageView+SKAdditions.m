//
//  UIImageView+SKAdditions.m
//  kkShop
//
//  Created by 王 顺强 on 15/8/16.
//  Copyright (c) 2015年 kk. All rights reserved.
//

#import "UIImageView+SKAdditions.h"
#import "UIView+WebCacheOperation.h"
#import "SDImageCache.h"

#define NTDefaultImageCacheKey(string)      [NSString stringWithFormat:@"NT_Cache_Default_Image_%@",string]
#define NTDefaultImage                      [UIImage imageNamed:@"icon_default_loading.jpg"]
#define NTDefaultWithCornerCacheKey(string) [NSString stringWithFormat:@"NT_Cache_With_Corner_Default_Image_%@", string]


#pragma mark - UIImageView Categorys

@interface UIImageView()

- (void)sd_cancelCurrentImageLoad;

@end

@implementation UIImageView(SKAdditions)

- (void)drawDrashedLineWithSpace:(CGFloat)space color:(UIColor *)color
{
    UIGraphicsBeginImageContext(self.bounds.size);   //开始画线
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {space,space};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextBeginPath(line);
    CGContextSetStrokeColorWithColor(line, color.CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, self.frame.size.width, 0.0);
    CGContextStrokePath(line);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
}

- (void)setDrashedLineImage {
    
    UIGraphicsBeginImageContext(self.bounds.size);   //开始画线
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {10,10};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextBeginPath(line);
    CGContextSetStrokeColorWithColor(line, [UIColor redColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, self.frame.size.width, 0.0);
    CGContextStrokePath(line);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextClosePath(line);
}

#pragma mark - 默认加载图裁剪
- (UIImage *)ntDefaultImageWithSize:(CGSize)size corner:(UIRectCorner)corner radius:(CGFloat)radius {
    
    NSNumber *num = [NSNumber numberWithUnsignedInteger:NSStringFromCGSize(size).hash];
    NSString *cacheKey = NTDefaultWithCornerCacheKey(num.stringValue);
    UIImage *cacheImg = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:cacheKey];
    
    if (cacheImg) {
        return cacheImg;
    }
    else {
        
        // if size is zero , don't draw
        if (size.width == 0 || size.height == 0) {
            return nil;
        }
        
        UIGraphicsBeginImageContext(size);
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)] addClip];
        
        double minWidth = fmin(size.width, size.height);
        
        //居中填充默认图片
        float dwidth = (size.width - minWidth) / 2.0f;
        float dheight = (size.height - minWidth) / 2.0f;
        
        CGRect rect = CGRectMake(dwidth, dheight, minWidth, minWidth);
        [NTDefaultImage drawInRect:rect];
        
        //返回自定义大小的默认图片
        UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[SDImageCache sharedImageCache] storeImage:newimg forKey:cacheKey toDisk:NO completion:nil];
        
        return newimg;
    }
}

- (UIImage *)ntDefaultImageWithSize:(CGSize)size {
    
    if (size.width == size.height) {
        return NTDefaultImage;
    }
    else {
        NSNumber *num = [NSNumber numberWithUnsignedInteger:NSStringFromCGSize(size).hash];
        NSString *cacheKey = NTDefaultImageCacheKey(num.stringValue);
        UIImage *cacheImg = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:cacheKey];
        
        if (cacheImg) {
            return cacheImg;
        }
        else {
            
            // if size is zero , don't draw
            if (size.width == 0 || size.height == 0) {
                return nil;
            }
            
            UIGraphicsBeginImageContextWithOptions(size, NO , [UIScreen mainScreen].scale); // 高清，效率比较慢
            
            //填充默认颜色
            CGContextRef ctx = UIGraphicsGetCurrentContext() ;
            CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
            
            double minWidth = fmin(size.width, size.height);
            
            
            //居中填充默认图片
            float dwidth = (size.width - minWidth) / 2.0f;
            float dheight = (size.height - minWidth) / 2.0f;
            
            CGRect rect = CGRectMake(dwidth, dheight, minWidth, minWidth);
            [NTDefaultImage drawInRect:rect];
            
            //返回自定义大小的默认图片
            UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [[SDImageCache sharedImageCache] storeImage:newimg forKey:cacheKey toDisk:NO completion:nil];
            
            return newimg;
        }
    }
}

//自适应大小的默认图片
- (UIImage *)ntDefaultImage
{
    //必须先layout，不然用约束的话，bounds的宽高不对，默认图会变形
    if (self.superview) {
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }
    
    if (self.bounds.size.width == self.bounds.size.height) {
        return NTDefaultImage;
    }
    else {
        NSNumber *num = [NSNumber numberWithUnsignedInteger:NSStringFromCGSize(self.bounds.size).hash];
        NSString *cacheKey = NTDefaultImageCacheKey(num.stringValue);
        UIImage *cacheImg = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:cacheKey];
        
        if (cacheImg) {
            return cacheImg;
        }
        else {
            
            // if size is zero , don't draw
            if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
                return nil;
            }
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO , [UIScreen mainScreen].scale);
            
            //填充默认颜色
            CGContextRef ctx = UIGraphicsGetCurrentContext() ;
            CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextFillRect(ctx, self.bounds);
            
            double minWidth = fmin(self.bounds.size.width, self.bounds.size.height);
            
            
            //居中填充默认图片
            float dwidth = (self.bounds.size.width - minWidth) / 2.0f;
            float dheight = (self.bounds.size.height - minWidth) / 2.0f;
            
            CGRect rect = CGRectMake(dwidth, dheight, minWidth, minWidth);
            [NTDefaultImage drawInRect:rect];
            
            //返回自定义大小的默认图片
            UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [[SDImageCache sharedImageCache] storeImage:newimg forKey:cacheKey toDisk:NO completion:nil];
            
            return newimg;
        }
    }
}


@end
