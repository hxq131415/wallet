//
//  UIImageView+SDWebImageKKAdditions.h
//  kkShop
//
//  Created by soonkong on 17/10/26.
//  Copyright © 2017年 kk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView(SDWebImageKKAdditions)

// Custom NT setImageWithURL Methods
- (void)nt_setImageWithURL:(NSURL *)url;
- (void)nt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;
- (void)nt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock;

//自动裁剪为正方形图片
/** 裁剪正方形图片
 
 @param url 图片url
 @param tSize 需要裁剪的大小
 @param placeholderImage 默认加载图
 
 @note 当tSize为CGSizeZero时使用屏幕宽度进行裁剪，主要考虑到有些页面的imageView的size不好计算
 */
- (void)autoCutToSquareImageWithURL:(NSURL *)url
                         targetSize:(CGSize)tSize
                   placeholderImage:(UIImage *)placeholderImage;

- (void)autoCutToSquareImageWithURL:(NSURL *)url
                         targetSize:(CGSize)tSize
                   placeholderImage:(UIImage *)placeholderImage
                          completed:(SDExternalCompletionBlock)completedBlock;



/**
 * @brief 按照给定图片尺寸裁剪
 *
 * @param size：指定裁剪的尺寸
 */
- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage;

- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                   completed:(SDExternalCompletionBlock)completedBlock;

/**
 * @brief  给定尺寸裁剪图片，从Top开始裁剪
 *
 * @param size：指定裁剪的尺寸
 * @param corner 指定圆角
 * @param cornerRadius 圆角大小  当为0时，没有圆角
 */
- (void)autoCutImageByTopWithSize:(CGSize)toSize imageURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage corner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius;

/**
 * @brief 根据指定尺寸裁剪图片
 *
 * @param toSize: 裁剪尺寸
 * @param url: 图片URL
 * @param placeholderImage: 加载默认图
 * @param corner: 圆角选项
 * @param cornerRadius: 圆角大小
 */
- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius;

- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   completed:(SDExternalCompletionBlock)completedBlock;

/**
 * @brief 根据指定尺寸裁剪图片
 *
 * @param toSize: 裁剪尺寸
 * @param url: 图片URL
 * @param placeholderImage: 加载默认图
 * @param corner: 圆角选项
 * @param cornerRadius: 圆角大小
 * @param backColor: 图片背景色
 */
- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   backColor:(UIColor *)backColor;

- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   backColor:(UIColor *)backColor
                   completed:(SDExternalCompletionBlock)completedBlock;

/**
 * @brief 带边框图片裁剪
 *
 * @param toSize: 裁剪尺寸
 * @param url: 图片URL
 * @param placeholderImage: 加载默认图
 * @param corner: 圆角选项
 * @param cornerRadius: 圆角大小
 * @param backColor: 图片背景色
 * @param borderWidth: 图片边框宽度
 * @param borderColor: 图片边框颜色
 */
- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   backColor:(UIColor *)backColor
                 borderWidth:(CGFloat)borderWidth
                 borderColor:(UIColor *)borderColor;

- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   backColor:(UIColor *)backColor
                 borderWidth:(CGFloat)borderWidth
                 borderColor:(UIColor *)borderColor
                   completed:(SDExternalCompletionBlock)completedBlock;

@end
