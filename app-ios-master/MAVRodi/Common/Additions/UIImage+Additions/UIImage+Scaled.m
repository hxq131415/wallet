//
//  UIImage+Scaled.m
//  kkShop
//
//  Created by gyanping on 15/8/19.
//  Copyright (c) 2015年 kk. All rights reserved.
//

#define KDocumentImagePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"images"]

#import "UIImage+Scaled.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (Scaled)
+(UIImage *)imageWithColor:(UIColor *)aColor{
    return [UIImage imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    UIGraphicsBeginImageContextWithOptions(aFrame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(CGFloat)sizeOfImageMB
{
    NSData * imageData = UIImageJPEGRepresentation(self, 1.0);
    NSUInteger dataSize = imageData.length;
    CGFloat length = (float)dataSize / 1024.0 / 1024.0;
    return length;
}

+(CGFloat)sizeOfImageDataMB:(NSData *)data
{
    NSUInteger dataSize = data.length;
    CGFloat length = (float)dataSize / 1024.0 / 1024.0;
    return length;
}

//裁剪图片
+(UIImage *)cutImageWithFitImgView:(UIImage*)image withImgView:(UIView *)_imgView
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((image.size.width / image.size.height) == (_imgView.bounds.size.width / _imgView.bounds.size.height)) {
        return image;
    }
    
    if ((image.size.width / image.size.height) < (_imgView.bounds.size.width / _imgView.bounds.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * _imgView.bounds.size.height / _imgView.bounds.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * _imgView.bounds.size.width / _imgView.bounds.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    
    //modify by S.K. 没调用CGImageRelease 释放内存
    UIImage *curImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return curImg;
}

//裁剪顶部图片
+ (UIImage *)cutTopImageWithFitImgView:(UIImage *)image withImgView:(UIView *)_imgView
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((image.size.width / image.size.height) == (_imgView.bounds.size.width / _imgView.bounds.size.height)) {
        return image;
    }
    
    if ((image.size.width / image.size.height) < (_imgView.bounds.size.width / _imgView.bounds.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * _imgView.bounds.size.height / _imgView.bounds.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * _imgView.bounds.size.width / _imgView.bounds.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, newSize.width, newSize.height));
    }
    
    //modify by S.K. 没调用CGImageRelease 释放内存
    UIImage *curImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return curImg;
}

//压缩图片
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(CGFloat)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    while ([compressedImage sizeOfImageMB] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
        compressedImage = [UIImage imageWithData:imageData];
    }
    
    return compressedImage;
}

- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height {
    
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    CGImageRef imageRef = self.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4*destW,
                                                CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *resultImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resultImage;
}

-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality{
    if (highQuality) {
        targetSize = CGSizeMake(2*targetSize.width, 2*targetSize.height);
    }
    return [self scaledToSize:targetSize];
}

-(UIImage *)scaledToMaxSize:(CGSize)size{
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    // 如果不需要缩放
    if (scaleFactor > 1.0) {
        return self;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage *)scaledToMinSize:(CGSize)size{
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ?  height / oldWidth : width / oldHeight;
    
    // 如果不需要缩放
    if (scaleFactor > 1.0) {
        return self;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];//fullScreenImage已经调整过方向了
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    return img;
}


//裁剪图片
//按照窗口宽高比例，将原图横向或者纵向裁剪掉多余的部分，然后不设置UIImageView的contentMode属性，将裁剪后的图片送进去，使其自动适应窗口。
//- (UIImage *)cutImage:(UIImage*)image
//{
//    //压缩图片
//    CGSize newSize;
//    CGImageRef imageRef = nil;
//
//    if ((image.size.width / image.size.height) < (_headerView.bgImgView.size.width / _headerView.bgImgView.size.height)) {
//        newSize.width = image.size.width;
//        newSize.height = image.size.width * _headerView.bgImgView.size.height / _headerView.bgImgView.size.width;
//
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//
//    } else {
//        newSize.height = image.size.height;
//        newSize.width = image.size.height * _headerView.bgImgView.size.width / _headerView.bgImgView.size.height;
//
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//
//    }
//
//    return [UIImage imageWithCGImage:imageRef];
//}



- (NSData *)imageData
{
    return UIImageJPEGRepresentation(self, 1.0);
}

#pragma mark - add by rttx
// 保存图片到沙盒
+ (void)saveImageWithFileName:(NSString *)fileName Data:(NSData *)imageData
{
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error = nil;
    
    BOOL ret = [fm createDirectoryAtPath:KDocumentImagePath withIntermediateDirectories:YES attributes:nil error:&error];
    if (ret && !error) {
        
        NSString * filePath = [KDocumentImagePath stringByAppendingPathComponent:fileName];
        [imageData writeToFile:filePath atomically:YES];
    }else {
        
    }
}

#pragma mark - 图片压缩

#pragma mark - 对图片进行目标尺寸压缩
-(UIImage*)scaledToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 1.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
    }
    scaleFactor = MIN(scaleFactor, 1.0);
    CGFloat targetWidth = imageSize.width* scaleFactor;
    CGFloat targetHeight = imageSize.height* scaleFactor;
    
    targetSize = CGSizeMake(targetWidth, targetHeight);
    UIGraphicsBeginImageContext(targetSize); // this will crop
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 以目标尺寸和目标大小进行压缩图片
- (void)compressImageScaledToSize:(CGSize)toSize toMBSize:(CGFloat)toMBSize completeBlock:(void (^)(UIImage *, NSData *))complete
{
    if ([self sizeOfImageMB] <= toMBSize) {
        complete(self, [self imageData]);
        return;
    }
    
    UIImage * scaledImage = self;
    
    //size与原图相同，或size为0，不缩放size
    if (!CGSizeEqualToSize(self.size, toSize) && !CGSizeEqualToSize(toSize, CGSizeZero)) {
        scaledImage = [self scaledToSize:toSize];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (scaledImage == nil) {
        complete(self, [self imageData]);
    }else {
        if ([scaledImage sizeOfImageMB] <= toMBSize) {
            complete(scaledImage, [scaledImage imageData]);
        }else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CGFloat compressNum = 0.9;
                CGFloat compression = 0.05;
                NSData * imageData = UIImageJPEGRepresentation(scaledImage, compressNum);
                
                while ([UIImage sizeOfImageDataMB:imageData] > toMBSize && compressNum >= compression) {
                    compressNum -= compression;
                    imageData = UIImageJPEGRepresentation(scaledImage, compressNum);
                }
                
                // 获取主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage * targetImage = [UIImage imageWithData:imageData];
                    if (targetImage) {
                        complete(targetImage, imageData);
                    }else {
                        complete(weakSelf, [weakSelf imageData]);
                    }
                });
            });
        }
    }
}

- (void)compressImageToMBSize:(CGFloat)toMBSize completeBlock:(void (^)(UIImage *, NSData *))complete
{
    [self compressImageScaledToSize:self.size toMBSize:toMBSize completeBlock:complete];
}

+ (UIImage *)createImageFromCIImage:(CIImage *)ciImage withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    // 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(NULL, width, height, 8, 0, colorRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * ciContext = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImg = [ciContext createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImg);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImg);
    UIImage * resImage = [UIImage imageWithCGImage:scaledImage];
    
    return resImage;
}
 

@end
