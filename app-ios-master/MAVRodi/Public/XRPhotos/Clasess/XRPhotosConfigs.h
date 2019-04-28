//
//  XRPhotosConfigs.h
//  XRAudioPlayer
//
//  Created by xuran on 2017/11/16.
//  Copyright © 2017年 rttx. All rights reserved.
//

#ifndef XRPhotosConfigs_h
#define XRPhotosConfigs_h

/** Const defines */

#if DEBUG
#define XRLog(...) NSLog(@"-----> [%@:(%d)] %s", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__); \
NSLog(__VA_ARGS__)
#else
#define XRLog(...) {}
#endif

#define iSiPhoneX \
\
([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)\
\
|| ([UIScreen mainScreen].bounds.size.width == 812 && [UIScreen mainScreen].bounds.size.height == 375)

#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define XR_Screen_Size [UIScreen mainScreen].bounds.size
#define XR_NavigationBar_Height (iSiPhoneX ? 88 : 64)
#define XR_Virtual_Bottom_Height (iSiPhoneX ? 34 : 0)
#define XR_StatusBar_Height  (iSiPhoneX ? 44 : 20)
#define XR_PhotoAsset_Grid_Border (XR_Screen_Size.width < 375.0 ? 2.0 : 5.0)

/** Static Consts */

static const CGFloat XR_PhotoPicker_BottomView_Height = 50;
static const CGFloat XR_PhotoAsset_GridCell_SelectButtonWidth = 18.0f;

static const CGFloat XR_AlbumListShow_AnimateTime = 0.25;
static const CGFloat XR_PhotoAlbumList_Cell_Height = 75.0;
static const CGFloat XR_PhotoAlbumList_ThumbImageToTop = 10;
static const CGFloat XR_PhotoAlbumList_ThumbImageToLeft = 15.0;

// NNKEY
static NSString * const NNKEY_XR_PHMANAGER_DOWNLOAD_IMAGE_FROM_ICLOUD = @"NNKEY_XR_PHMANAGER_DOWNLOAD_IMAGE_FROM_ICLOUD";

#endif /* XRPhotosConfigs_h */
