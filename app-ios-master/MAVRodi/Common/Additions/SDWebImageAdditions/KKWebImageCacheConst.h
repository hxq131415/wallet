//
//  KKWebImageCacheConst.h
//  kkShop
//
//  Created by xuran on 2017/10/26.
//  Copyright © 2017年 kk. All rights reserved.
//

#ifndef KKWebImageCacheConst_h
#define KKWebImageCacheConst_h

/// 图片裁剪规则： 裁剪类型 + 裁剪参数 确保唯一性
static NSString * const k_image_cut_type_key = @"k_image_cut_type_key";

/** 图片裁剪的类型
 k_image_cut_type_by_center     中间裁剪
 k_image_cut_type_by_top        顶部裁剪
 ...
 */
static NSString * const k_image_cut_type_by_center = @"k_image_cut_type_by_center";
static NSString * const k_image_cut_type_by_top = @"k_image_cut_type_by_top";
static NSString * const k_image_cut_type_by_left = @"k_image_cut_type_by_left";
static NSString * const k_image_cut_type_by_right = @"k_image_cut_type_by_right";
static NSString * const k_image_cut_type_by_bottom = @"k_image_cut_type_by_bottom";

/** 图片裁剪需要指定的参数
 k_image_cut_param_size_key 指定需要裁剪的大小
 k_image_cut_param_border_width_key 指定需要裁剪的图片边框的大小
 k_image_cut_param_border_color_key 指定需要裁剪的图片边框的颜色值
 k_image_cut_param_background_color_key 指定需要裁剪的图片的背景颜色值
 k_image_cut_param_radius_corner_type_key 指定需要裁剪的图片的圆角类型
 k_image_cut_param_radius_corner_size_key 指定需要裁剪的图片的圆角大小
 */
static NSString * const k_image_cut_param_size_key = @"k_image_cut_param_size_key";
static NSString * const k_image_cut_param_border_width_key = @"k_image_cut_param_border_width_key";
static NSString * const k_image_cut_param_border_color_key = @"k_image_cut_param_border_color_key";
static NSString * const k_image_cut_param_background_color_key = @"k_image_cut_param_background_color_key";
static NSString * const k_image_cut_param_radius_corner_type_key = @"k_image_cut_param_radius_corner_type_key";
static NSString * const k_image_cut_param_radius_corner_size_key = @"k_image_cut_param_radius_corner_size_key";

/** 圆角类型 */
/**
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 UIRectCornerAllCorners  = ~0UL
 */
static NSString * const k_image_cut_corner_type_top_left = @"topleft";
static NSString * const k_image_cut_corner_type_top_right = @"topright";
static NSString * const k_image_cut_corner_type_bottom_left = @"bottomleft";
static NSString * const k_image_cut_corner_type_bottom_right = @"bottomright";
static NSString * const k_image_cut_corner_type_all_corners = @"allcorners";

#endif /* KKWebImageCacheConst_h */


