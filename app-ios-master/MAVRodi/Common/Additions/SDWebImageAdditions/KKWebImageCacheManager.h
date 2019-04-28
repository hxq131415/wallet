//
//  KKWebImageCacheManager.h
//  kkShop
//
//  Created by soonkong on 17/10/26.
//  Copyright © 2017年 kk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageManager.h>

@interface KKWebImageCacheManager : NSObject

+ (instancetype)shareManager;

/**
 * 自定义SDWebImage 的 缓存key
 */
+ (void)customKKSDWebImageCacheKeyFilter;

+ (NSString *)cacheKeyForURL:(NSURL *)url;

// UIRectCorner Convert
+ (UIRectCorner)cornerTypeFromURLCornerTypeString:(NSString *)cornerTypeStr;
+ (NSString *)cornerTypeStringWithRectCorner:(UIRectCorner)corner;

- (void)prepareForUse;

@end
