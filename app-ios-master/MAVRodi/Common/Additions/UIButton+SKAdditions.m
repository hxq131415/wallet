//
//  UIButton+SKAdditions.m
//  SKEasyy
//
//  Created by 王 顺强 on 16/8/28.
//  Copyright © 2016年 S.K. All rights reserved.
//

#import "UIButton+SKAdditions.h"
#import <objc/runtime.h>

static const char CustomButtonInfoKey;
static const char hitInsetsKey;

@implementation UIButton(SKAdditions)

//垂直居中(图片上面，文字下面)
- (void)verticalCenterButtonSetting
{
    [self verticalCenterButtonSettingWithSpace:0];
}

- (void)verticalCenterButtonSettingWithSpace:(CGFloat)space
{
    if (self.superview) {
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // 取得imageView最初的center
    CGRect imgBounds = self.imageView.bounds;
    
    // 取得titleLabel最初的center
    CGRect titleBounds = self.titleLabel.bounds;
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = 0;
    CGFloat imageEdgeInsetsLeft = (self.bounds.size.width - imgBounds.size.width) * 0.5;
    CGFloat imageEdgeInsetsBottom = titleBounds.size.height;
    CGFloat imageEdgeInsetsRight = (self.bounds.size.width - imgBounds.size.width) * 0.5;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = imgBounds.size.height + space;
    CGFloat titleEdgeInsetsLeft = -imgBounds.size.height;
    CGFloat titleEdgeInsetsBottom = 0;
    CGFloat titleEdgeInsetsRight = 0;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}

- (void)titleLeftImageRightSetting
{
    [self titleLeftImageRightSettingWithSpace:0];
}

- (void)titleLeftImageRightSettingWithSpace:(CGFloat)space
{
    if (self.superview) {
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // 取得imageView最初的center
    CGRect imgBounds = self.imageView.bounds;
    
    // 取得titleLabel最初的center
    CGRect titleBounds = self.titleLabel.bounds;
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgBounds.size.width-space, 0, imgBounds.size.width+space)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleBounds.size.width+space, 0, -titleBounds.size.width-space)];
}

- (void)titleRightAndImageLeftSettingWithSpace:(CGFloat)space
{
    if (self.superview) {
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -space, 0, space)];
}

- (NSDictionary *)buttonInfo
{
    return (NSDictionary *)objc_getAssociatedObject(self, &CustomButtonInfoKey);
}

- (void)setButtonInfo:(NSDictionary *)buttonInfo
{
    objc_setAssociatedObject(self, &CustomButtonInfoKey, buttonInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNt_hitInsets:(UIEdgeInsets)nt_hitInsets {
    
    objc_setAssociatedObject(self, &hitInsetsKey, [NSValue valueWithUIEdgeInsets:nt_hitInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)nt_hitInsets {
    
    NSValue * value = objc_getAssociatedObject(self, &hitInsetsKey);
    UIEdgeInsets hitInsets = [value UIEdgeInsetsValue];
    return hitInsets;
}

#pragma mark - 按钮点击区域处理
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 判断是否需要进行hit
    if (UIEdgeInsetsEqualToEdgeInsets(self.nt_hitInsets, UIEdgeInsetsZero) || self.hidden || self.alpha <= 0 || !self.enabled) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect hitRect = UIEdgeInsetsInsetRect(self.bounds, self.nt_hitInsets);
    return CGRectContainsPoint(hitRect, point);
}

@end
