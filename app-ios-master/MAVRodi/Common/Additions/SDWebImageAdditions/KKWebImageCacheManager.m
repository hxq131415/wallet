//
//  KKWebImageCacheManager.m
//  kkShop
//
//  Created by soonkong on 17/10/26.
//  Copyright © 2017年 kk. All rights reserved.
//

#import "KKWebImageCacheManager.h"
#import "KKWebImageCacheManager.h"
#import "KKWebImageCacheConst.h"
#import "UIImageView+SKAdditions.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Crap.h"

@interface KKWebImageCacheManager() <SDWebImageManagerDelegate>

@end

@implementation KKWebImageCacheManager

/**
 * 自定义SDWebImage 的 缓存key
 */
+ (void)customKKSDWebImageCacheKeyFilter
{
    [[SDWebImageManager sharedManager] setCacheKeyFilter:^(NSURL *url) {
        if (url && [url absoluteString]) {
            NSMutableString *newCacheKey = [NSMutableString stringWithString:[url absoluteString]];
            
            if ([url sd_cacheKeyInfo]) {
                NSDictionary<NSString *, NSString *> *keyInfo = [url sd_cacheKeyInfo];
                
                [keyInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    if (key && obj) {
                        if ([newCacheKey rangeOfString:@"?"].length > 0) {
                            [newCacheKey appendFormat:@"&%@=%@",key, obj];
                        }
                        else {
                            [newCacheKey appendFormat:@"?%@=%@",key, obj];
                        }
                    }
                    
                }];
            }
            
            return [NSString stringWithString:newCacheKey];
        }
        
        return [url absoluteString];
    }];
}

+ (NSString *)cacheKeyForURL:(NSURL *)url {
    if (!url) {
        return @"";
    }
    
    SDWebImageCacheKeyFilterBlock filter = [SDWebImageManager sharedManager].cacheKeyFilter;
    
    if (filter) {
        return filter(url);
    } else {
        return [url absoluteString];
    }
}

+ (instancetype)shareManager
{
    static KKWebImageCacheManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KKWebImageCacheManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [KKWebImageCacheManager customKKSDWebImageCacheKeyFilter];
        
        [SDWebImageManager sharedManager].delegate = self;
    }
    
    return self;
}

/**
 * 还未知要做什么，先给调用做初始化
 */
- (void)prepareForUse
{

}

+ (UIRectCorner)cornerTypeFromURLCornerTypeString:(NSString *)cornerTypeStr {
    
    __block UIRectCorner cornerType = UIRectCornerTopLeft;
    
    if (cornerTypeStr) {
        if ([cornerTypeStr rangeOfString:@"_"].location != NSNotFound) {
            NSArray * cornerTypeArr = [cornerTypeStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
            [cornerTypeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * objStr = (NSString *)obj;
                
                if ([objStr rangeOfString:k_image_cut_corner_type_all_corners].location != NSNotFound) {
                    cornerType = UIRectCornerAllCorners;
                    *stop = YES;
                }
                else {
                    if ([objStr rangeOfString:k_image_cut_corner_type_top_left].location != NSNotFound) {
                        cornerType = cornerType | UIRectCornerTopLeft;
                    }
                    
                    if ([objStr rangeOfString:k_image_cut_corner_type_top_right].location != NSNotFound) {
                        cornerType = cornerType | UIRectCornerTopRight;
                    }
                    
                    if ([objStr rangeOfString:k_image_cut_corner_type_bottom_left].location != NSNotFound) {
                        cornerType = cornerType | UIRectCornerBottomLeft;
                    }
                    
                    if ([objStr rangeOfString:k_image_cut_corner_type_bottom_right].location != NSNotFound) {
                        cornerType = cornerType | UIRectCornerBottomRight;
                    }
                }
            }];
        }
        else {
            if ([cornerTypeStr rangeOfString:k_image_cut_corner_type_all_corners].location != NSNotFound) {
                cornerType = UIRectCornerAllCorners;
            }
            else if ([cornerTypeStr rangeOfString:k_image_cut_corner_type_top_left].location != NSNotFound) {
                cornerType = UIRectCornerTopLeft;
            }
            else if ([cornerTypeStr rangeOfString:k_image_cut_corner_type_top_right].location != NSNotFound) {
                cornerType = UIRectCornerTopRight;
            }
            else if ([cornerTypeStr rangeOfString:k_image_cut_corner_type_bottom_left].location != NSNotFound) {
                cornerType = UIRectCornerBottomLeft;
            }
            else if ([cornerTypeStr rangeOfString:k_image_cut_corner_type_bottom_right].location != NSNotFound) {
                cornerType = UIRectCornerBottomRight;
            }
        }
    }
    
    return cornerType;
}

+ (NSString *)cornerTypeStringWithRectCorner:(UIRectCorner)corner {
    
    NSString * cornerTypeString = nil;
    NSMutableArray <NSString *>* cornerTypeArr = [NSMutableArray arrayWithCapacity:5];
    
    if (corner == UIRectCornerAllCorners) {
        if (![cornerTypeArr containsObject:k_image_cut_corner_type_all_corners]) {
            [cornerTypeArr addObject:k_image_cut_corner_type_all_corners];
        }
    }
    else {
        if (corner & UIRectCornerTopLeft) {
            if (![cornerTypeArr containsObject:k_image_cut_corner_type_top_left]) {
                [cornerTypeArr addObject:k_image_cut_corner_type_top_left];
            }
        }
        
        if (corner & UIRectCornerTopRight) {
            if (![cornerTypeArr containsObject:k_image_cut_corner_type_top_right]) {
                [cornerTypeArr addObject:k_image_cut_corner_type_top_right];
            }
        }
        
        if (corner & UIRectCornerBottomLeft) {
            if (![cornerTypeArr containsObject:k_image_cut_corner_type_bottom_left]) {
                [cornerTypeArr addObject:k_image_cut_corner_type_bottom_left];
            }
        }
        
        if (corner & UIRectCornerBottomRight) {
            if (![cornerTypeArr containsObject:k_image_cut_corner_type_bottom_right]) {
                [cornerTypeArr addObject:k_image_cut_corner_type_bottom_right];
            }
        }
    }
    
    if (cornerTypeArr.count > 1) {
        cornerTypeString = [cornerTypeArr componentsJoinedByString:@"_"];
    }
    else if (cornerTypeArr.count == 1) {
        cornerTypeString = cornerTypeArr[0];
    }
    
    return cornerTypeString;
}

#pragma mark - SDWebImageManagerDelegate
- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    if (imageURL && [imageURL sd_cacheKeyInfo]) {
        
        NSDictionary * cacheKeyInfo = [imageURL sd_cacheKeyInfo];
        
        if ([cacheKeyInfo valueForKey:k_image_cut_type_key]) {
            NSString * cutTypeKey = [cacheKeyInfo valueForKey:k_image_cut_type_key];
            
            CGSize tSize = CGSizeZero;
            CGFloat radius = 0;
            CGFloat borderWidth = 0;
            
            UIColor * borderColor = nil;
            UIColor * backgroundColor = nil;
            UIRectCorner cornerType = UIRectCornerAllCorners;
            
            UIImage * cutImg = nil;
            
            if ([cacheKeyInfo valueForKey:k_image_cut_param_size_key]) {
                tSize = CGSizeFromString([cacheKeyInfo valueForKey:k_image_cut_param_size_key]);
                
                if (!CGSizeEqualToSize(tSize, CGSizeZero)) {
                    if ([cacheKeyInfo valueForKey:k_image_cut_param_radius_corner_size_key]) {
                        radius = [[cacheKeyInfo valueForKey:k_image_cut_param_radius_corner_size_key] floatValue];
                    }
                    
                    if ([cacheKeyInfo valueForKey:k_image_cut_param_radius_corner_type_key]) {
                        NSString * cornerTypeStr = (NSString *)[cacheKeyInfo valueForKey:k_image_cut_param_radius_corner_type_key];
                        if (cornerTypeStr && ![cornerTypeStr isEmpty]) {
                            cornerType = [KKWebImageCacheManager cornerTypeFromURLCornerTypeString:cornerTypeStr];
                        }
                    }
                    
                    borderWidth = [[cacheKeyInfo valueForKey:k_image_cut_param_border_width_key] floatValue];
                    
                    if ([cacheKeyInfo valueForKey:k_image_cut_param_border_color_key]) {
                        borderColor = [UIColor colorFromRgbAlphaDescription:[cacheKeyInfo valueForKey:k_image_cut_param_border_color_key]];
                    }
                    
                    if ([cacheKeyInfo valueForKey:k_image_cut_param_background_color_key]) {
                        backgroundColor = [UIColor colorFromRgbAlphaDescription:[cacheKeyInfo valueForKey:k_image_cut_param_background_color_key]];
                    }
                    
                    if ([cutTypeKey isEqualToString:k_image_cut_type_by_top]) {
                        // 顶部裁剪
                        cutImg = [image imageCutByTopToSize:tSize corners:cornerType cornerRadius:radius];
                        return cutImg;
                    }
                    else if ([cutTypeKey isEqualToString:k_image_cut_type_by_center]) {
                        // 中间裁剪
                        if (borderWidth > 0 && borderColor != nil) {
                            cutImg = [image imageCompressToSize:tSize corners:cornerType cornerRadius:radius backgroundColor:backgroundColor borderWidth:borderWidth borderColor:borderColor];
                        }
                        else if (backgroundColor != nil) {
                            cutImg = [image imageCompressToSize:tSize corners:cornerType cornerRadius:radius backgroundColor:backgroundColor];
                        }
                        else {
                            cutImg = [image imageCompressToSize:tSize corners:cornerType cornerRadius:radius];
                        }
                        
                        return cutImg;
                    }
                }
            }
        }
    }
    
    return image;
}

@end
