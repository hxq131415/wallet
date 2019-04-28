//
//  UIImageView+SKAdditions.h
//  kkShop
//
//  Created by 王 顺强 on 15/8/16.
//  Copyright (c) 2015年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>

/**
 * 为了拓展cacheKeyFilter， 增加url键值对 sd_cacheKeyInfo
 */
@interface NSURL(SDImageViewCacheKeyAdditions)

@property (nonatomic, retain) NSDictionary<NSString *, NSString *> *sd_cacheKeyInfo;

@end

@interface UIImageView(SKAdditions)

- (void)drawDrashedLineWithSpace:(CGFloat)space color:(UIColor *)color;

- (UIImage *)ntDefaultImageWithSize:(CGSize)size corner:(UIRectCorner)corner radius:(CGFloat)radius;

//自适应大小的默认图片
- (UIImage *)ntDefaultImage;

// 根据尺寸返回默认图
- (UIImage *)ntDefaultImageWithSize:(CGSize)size;

@end
