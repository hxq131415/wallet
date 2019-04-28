//
//  UIImageView+SDWebImageKKAdditions.m
//  kkShop
//
//  Created by soonkong on 17/10/26.
//  Copyright © 2017年 kk. All rights reserved.
//

#import "UIImageView+SDWebImageKKAdditions.h"
#import <objc/runtime.h>
#import "UIView+WebCacheOperation.h"
#import "KKWebImageCacheConst.h"
#import "KKWebImageCacheManager.h"
#import "UIColor+Additions.h"

#pragma mark - NSURL Categorys

/**
 * 为了拓展cacheKeyFilter， 增加url键值对 sd_cacheKeyInfo
 */
static const void * SDImageViewCacheInfoKey = &SDImageViewCacheInfoKey;


@implementation NSURL(SDImageViewCacheKeyAdditions)

- (NSDictionary<NSString *,NSString *> *)sd_cacheKeyInfo
{
    return objc_getAssociatedObject(self, SDImageViewCacheInfoKey);
}

- (void)setSd_cacheKeyInfo:(NSDictionary<NSString *,NSString *> *)sd_cacheKeyInfo
{
    objc_setAssociatedObject(self, SDImageViewCacheInfoKey, sd_cacheKeyInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


#pragma mark - SDWebImage KKAdditions

#define KKCustomSDWebImageOptions (SDWebImageRetryFailed | SDWebImageLowPriority)

@implementation UIImageView(SDWebImageKKAdditions)

- (void)nt_setImageWithURL:(NSURL *)url {
    
    [self nt_setImageWithURL:url placeholderImage:nil];
}

- (void)nt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    
    [self nt_setImageWithURL:url placeholderImage:placeholderImage options:KKCustomSDWebImageOptions];
}

- (void)nt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholderImage options:options];
}

- (void)nt_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock {
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:KKCustomSDWebImageOptions completed:completedBlock];
}

/**
 * @brief 按照给定图片尺寸裁剪
 *
 * @param size：指定裁剪的尺寸
 * @param corner 指定圆角
 * @param cornerRadius 圆角大小  当为0时，没有圆角
 */
- (void)autoCutImageWithSize:(CGSize)toSize imageURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
    [self autoCutImageWithSize:toSize imageURL:url placeholderImage:placeholderImage completed:nil];
}

- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                   completed:(SDExternalCompletionBlock)completedBlock {
    
    [self autoCutImageWithSize:toSize imageURL:url placeholderImage:placeholderImage corner:UIRectCornerTopLeft cornerRadius:0 completed:completedBlock];
}

/**
 * @brief 按照给定图片尺寸裁剪
 *
 * @param size         指定裁剪的尺寸
 * @param corner       指定圆角
 * @param cornerRadius 圆角大小  当为0时，没有圆角
 * @param backColor    背景色
 */
- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   backColor:(UIColor *)backColor {
    
    [self autoCutImageWithSize:toSize imageURL:url placeholderImage:placeholderImage corner:corner cornerRadius:cornerRadius backColor:backColor completed:nil];
    
}

- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   backColor:(UIColor *)backColor
                   completed:(SDExternalCompletionBlock)completedBlock {
    
    [self cutImageWithUrl:url placeHolderImage:placeholderImage targetSize:toSize corners:corner cornerRadius:cornerRadius backgroundColor:backColor borderWidth:0 borderColor:nil completed:completedBlock];
}

/**
 * @brief 按照给定图片尺寸裁剪
 *
 * @param size         指定裁剪的尺寸
 * @param corner       指定圆角
 * @param cornerRadius 圆角大小  当为0时，没有圆角
 */
- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
{
    [self autoCutImageWithSize:toSize imageURL:url placeholderImage:placeholderImage corner:corner cornerRadius:cornerRadius completed:nil];
}

- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   completed:(SDExternalCompletionBlock)completedBlock {
    
    [self cutImageWithUrl:url placeHolderImage:placeholderImage targetSize:toSize corners:corner cornerRadius:cornerRadius backgroundColor:nil borderWidth:0 borderColor:nil
                completed:completedBlock];
}

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
                 borderColor:(UIColor *)borderColor
{
    [self autoCutImageWithSize:toSize imageURL:url placeholderImage:placeholderImage corner:corner cornerRadius:cornerRadius backColor:backColor borderWidth:borderWidth borderColor:borderColor completed: nil];
}

- (void)autoCutImageWithSize:(CGSize)toSize
                    imageURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholderImage
                      corner:(UIRectCorner)corner
                cornerRadius:(CGFloat)cornerRadius
                   backColor:(UIColor *)backColor
                 borderWidth:(CGFloat)borderWidth
                 borderColor:(UIColor *)borderColor
                   completed:(SDExternalCompletionBlock)completedBlock {
    
    [self cutImageWithUrl:url placeHolderImage:placeholderImage targetSize:toSize corners:corner cornerRadius:cornerRadius backgroundColor:backColor borderWidth:borderWidth borderColor:borderColor completed:completedBlock];
}

#pragma mark - 裁剪正方形图片
/** 裁剪正方形图片
 
 @param url 图片url
 @param tSize 需要裁剪的大小
 @param placeholderImage 默认加载图
 
 @note 当tSize为CGSizeZero时使用屏幕宽度进行裁剪，主要考虑到有些页面的imageView的size不好计算
 */
- (void)autoCutToSquareImageWithURL:(NSURL *)url
                         targetSize:(CGSize)tSize
                   placeholderImage:(UIImage *)placeholderImage
{
    [self autoCutToSquareImageWithURL:url targetSize:tSize placeholderImage:placeholderImage completed:nil];
}

- (void)autoCutToSquareImageWithURL:(NSURL *)url
                         targetSize:(CGSize)tSize
                   placeholderImage:(UIImage *)placeholderImage
                          completed:(SDExternalCompletionBlock)completedBlock
{
    CGSize imageViewSize = CGSizeZero;
    if (CGSizeEqualToSize(tSize, CGSizeZero)) {
        imageViewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    }
    else {
        imageViewSize = tSize;
    }
    [self autoCutImageWithSize:imageViewSize imageURL:url placeholderImage:placeholderImage];
}

#pragma mark - 中间裁剪图片并缓存
- (void)cutImageWithUrl:(NSURL *)url
       placeHolderImage:(UIImage *)placeholderImage
             targetSize:(CGSize)size
                corners:(UIRectCorner)corner
           cornerRadius:(CGFloat)radius
        backgroundColor:(UIColor *)backgroundColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
              completed:(SDExternalCompletionBlock)completedBlock {
    
    NSMutableDictionary *urlInfoDic = [NSMutableDictionary dictionary];
    urlInfoDic[k_image_cut_type_key] = k_image_cut_type_by_center;
    urlInfoDic[k_image_cut_param_size_key] = NSStringFromCGSize(CGSizeMake(size.width, size.height));
    if (radius > 0) {
        urlInfoDic[k_image_cut_param_radius_corner_type_key] = [KKWebImageCacheManager cornerTypeStringWithRectCorner:corner];
        urlInfoDic[k_image_cut_param_radius_corner_size_key] = @(radius).stringValue;
    }
    
    if (borderWidth > 0 && borderColor != nil) {
        urlInfoDic[k_image_cut_param_border_width_key] = @(borderWidth).stringValue;
        urlInfoDic[k_image_cut_param_border_color_key] = [borderColor rgbAlphaDescription];
    }
    
    if (nil != backgroundColor) {
        urlInfoDic[k_image_cut_param_background_color_key] = [backgroundColor rgbAlphaDescription];
    }
    
    url.sd_cacheKeyInfo = urlInfoDic;
    [self nt_setImageWithURL:url placeholderImage:placeholderImage completed:completedBlock];
}

#pragma mark - 顶部裁剪图片并缓存

- (void)autoCutImageByTopWithSize:(CGSize)toSize
                         imageURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholderImage
                           corner:(UIRectCorner)corner
                     cornerRadius:(CGFloat)cornerRadius {
    
    // 需要其他参数时可自行添加
    NSMutableDictionary *urlInfoDic = [NSMutableDictionary dictionary];
    urlInfoDic[k_image_cut_type_key] = k_image_cut_type_by_top;
    urlInfoDic[k_image_cut_param_size_key] = NSStringFromCGSize(CGSizeMake(toSize.width, toSize.height));
    if (cornerRadius > 0) {
        urlInfoDic[k_image_cut_param_radius_corner_type_key] = [KKWebImageCacheManager cornerTypeStringWithRectCorner:corner];
        urlInfoDic[k_image_cut_param_radius_corner_size_key] = @(cornerRadius).stringValue;
    }
    
    url.sd_cacheKeyInfo = urlInfoDic;
    [self nt_setImageWithURL:url placeholderImage:placeholderImage];
}

@end
