//
//  UIImage+Scaled.h
//  kkShop
//
//  Created by gyanping on 15/8/19.
//  Copyright (c) 2015年 kk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Scaled)
-(CGFloat)sizeOfImageMB;
+(CGFloat)sizeOfImageDataMB:(NSData *)data;
+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage*)scaledToMaxSize:(CGSize )size;
-(UIImage *)scaledToMinSize:(CGSize)size;
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset;


//压缩图片
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(CGFloat)maxFileSize;
- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height;
+(UIImage *)cutImageWithFitImgView:(UIImage*)image withImgView:(UIView *)_imgView;
// 保存图片到沙盒
+ (void)saveImageWithFileName:(NSString *)fileName Data:(NSData *)imageData;
//裁剪顶部图片
+ (UIImage *)cutTopImageWithFitImgView:(UIImage *)image withImgView:(UIView *)_imgView;
/* 压缩图片到指定的尺寸大小 */
- (void)compressImageScaledToSize:(CGSize)toSize toMBSize:(CGFloat)toMBSize completeBlock:(void (^)(UIImage * targetImage, NSData * targetData))complete;
/* 压缩图片到指定的大小 */
- (void)compressImageToMBSize:(CGFloat)toMBSize completeBlock:(void (^)(UIImage *, NSData *))complete;

// CIImage根据指定的size生成UIImage
// 生成清晰图片
+ (UIImage *)createImageFromCIImage:(CIImage *)ciImage withSize:(CGFloat)size;
 

@end
