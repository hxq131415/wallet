//
//  UIViewController+HUD.h
//  StupidFM
//
//  Created by S.K. on 15/6/3.
//  Copyright (c) 2015年 S.K. All rights reserved.
//  MBProgressHud

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

// 显示提示信息
- (void)showWithMessage:(NSString *)message
                 InView:(UIView *)view;

// 隐藏 HUD
- (void)hideHUD;

// 隐藏 HUD 自己控制动画
- (void)hideHUDWith:(BOOL)animated;

// 设置HUD显示的内容
- (void)showMessage:(NSString *)message;
///只显示文字提示信息
- (void)showMessageText:(NSString *)message toView:(UIView *)view;

// 显示信息
- (void)showMessage:(NSString *)message
            yOffSet:(float)yOffset;

// 只显示文字信息
- (void)showMessageText:(NSString *)message;

/**
 * @brief  在底部位置显示提示信息
 * 
 */
- (void)showBottomMessage:(NSString *)message;

- (void)showHUDWithSuccessText:(NSString *)message;

// 自定义HUD
- (void)showMessageText:(NSString *)message TextSize:(CGFloat)size LabelColor:(UIColor *)labelColor Margin:(CGFloat)margin BackgroundColor:(UIColor *)color CornerRadius:(CGFloat)cornerRadius Square:(BOOL)isSquare HideTime:(CGFloat)hideTime Opacity:(CGFloat)opacity;

/**
 * @brief  显示成功提示
 *
 */
- (void)showSuccessMessage:(NSString *)message;

- (void)hideHUDWithSuperView:(UIView *)superVw;

/**
 * @brief  显示失败提示
 *
 */
- (void)showErrorMessage:(NSString *)message;

- (void)showMessage:(NSString *)message icon:(NSString *)icon;

@end
