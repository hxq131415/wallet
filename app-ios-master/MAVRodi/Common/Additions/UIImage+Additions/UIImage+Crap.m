//
//  UIImage+Scale.m
//  图片裁剪
//
//  Created by xuran on 15/10/8.
//  Copyright (c) 2015年 xuran. All rights reserved.
//

#import "UIImage+Crap.h"

@implementation UIImage(Crap)

/** 
 * 顶部裁剪图片
 */
- (UIImage *)imageCutByTopToSize:(CGSize)toSize corners:(UIRectCorner)corner cornerRadius:(CGFloat)radius {
    
    if (self == nil) {
        return self;
    }
    
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = toSize.width;
    CGFloat targetHeight = toSize.height;
    CGFloat scaleFactor = 1.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, toSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = 0.0;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // 解决内容耗用过高问题
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(toSize, NO, [UIScreen mainScreen].scale);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        // 绘制圆角
        if (radius > 0) {
            [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, toSize.width, toSize.height) byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)] addClip];
        }
        
        [self drawInRect:thumbnailRect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

/**
 * 指定size裁剪图片
 */
- (UIImage *)imageCompressToSize:(CGSize)size {
    
    return [self imageCompressToSize:size corners:UIRectCornerAllCorners cornerRadius:0];
}

/**
 * 指定size和圆角大小以及圆角样式进行裁剪图片
 */
- (UIImage *)imageCompressToSize:(CGSize)size corners:(UIRectCorner)corner cornerRadius:(CGFloat)radius {
    
    return [self imageCompressToSize:size corners:corner cornerRadius:radius backgroundColor:nil borderWidth:0 borderColor:nil];
}

/**
 * 指定size和圆角大小以及圆角样式，背景颜色进行裁剪图片
 */
- (UIImage *)imageCompressToSize:(CGSize)size corners:(UIRectCorner)corner cornerRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor {
    
    return [self imageCompressToSize:size corners:corner cornerRadius:radius backgroundColor:backgroundColor borderWidth:0 borderColor:nil];
}

/**
 * 指定size和圆角大小以及圆角样式，背景颜色，边框大小及边框颜色进行裁剪图片
 */
- (UIImage *)imageCompressToSize:(CGSize)size
                         corners:(UIRectCorner)corner
                    cornerRadius:(CGFloat)radius
                 backgroundColor:(UIColor *)backgroundColor
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor {
    
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 1.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    @autoreleasepool {
        // 裁剪图片，不透明，分辨率为系统分辨率.
        // opaque YES 不透明，不设置背景色或者backgroundColor为clearColor时会默认为黑色背景
        // NO 透明 没有默认的黑色背景
        BOOL opaque = YES;
        if (backgroundColor && backgroundColor != [UIColor clearColor]) {
            opaque = YES;
        }
        else {
            opaque = NO;
        }
        UIGraphicsBeginImageContextWithOptions(size, opaque, [UIScreen mainScreen].scale);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        // 绘制背景色
        if (backgroundColor && backgroundColor != [UIColor clearColor]) {
            [backgroundColor setFill];
            UIRectFill(thumbnailRect);
        }
        
        CGRect bezierPathRect = CGRectMake(0, 0, size.width, size.height);
        UIBezierPath * bezierPath = nil;
        // 绘制边框
        if (borderWidth > 0) {
            bezierPathRect = UIEdgeInsetsInsetRect(CGRectMake(0, 0, size.width, size.height), UIEdgeInsetsMake(borderWidth, borderWidth, borderWidth, borderWidth));
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bezierPathRect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
            bezierPath.lineWidth = borderWidth * 2.0; // lineWidth为insetRect的inset的两倍
            if (radius > 0) {
                if (!(corner & UIRectCornerTopLeft)) {
                    bezierPath.lineCapStyle = kCGLineCapSquare;
                }
                else {
                    bezierPath.lineCapStyle = kCGLineCapRound;
                }
            }
            else {
                bezierPath.lineCapStyle = kCGLineCapSquare;
            }
            [borderColor setStroke];
            [bezierPath stroke];
        }
        else {
            // 绘制圆角
            if (radius > 0) {
                bezierPath = [UIBezierPath bezierPathWithRoundedRect:bezierPathRect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
            }
        }
        
        if (bezierPath) {
            [bezierPath addClip];
        }
        
        [self drawInRect:thumbnailRect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

// 解决拍照旋转90°问题
- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
