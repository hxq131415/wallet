//
//  UIImage+Scale.h
//  图片裁剪
//
//  Created by xuran on 15/10/8.
//  Copyright (c) 2015年 xuran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Crap)

// 根据图片尺寸裁剪到目标大小，从Top开始裁剪，可以设置圆角.
- (UIImage *)imageCutByTopToSize:(CGSize)toSize corners:(UIRectCorner)corner cornerRadius:(CGFloat)radius;
// 根据size进行图片裁剪
- (UIImage *)imageCompressToSize:(CGSize)size;
// 根据size进行图片裁剪，可以添加圆角
- (UIImage *)imageCompressToSize:(CGSize)size corners:(UIRectCorner)corner cornerRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor;
- (UIImage *)imageCompressToSize:(CGSize)size corners:(UIRectCorner)corner cornerRadius:(CGFloat)radius;
// 裁剪带边框的图片
- (UIImage *)imageCompressToSize:(CGSize)size corners:(UIRectCorner)corner cornerRadius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

// 解决拍照旋转90°问题
- (UIImage *)fixOrientation;


@end
