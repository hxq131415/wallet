//
//  XRDigitalView.h
//  XRDigitalScrollView
//
//  Created by rttx on 2018/9/13.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRDigitalView : UIView

/**
 * @brief 设置显示数字的颜色和字体
 *
 * @param textColor 文字颜色
 * @param font      字体
 *
 * @return 返回数字显示的合适的size
 */
- (CGSize)setDigitalNumTextColor:(UIColor *)textColor font:(UIFont *)font;

/**
 * @brief 开始滚动动画
 *
 * @param num       滚动到数字'num'
 * @param delayTime 动画延迟时间
 * @param isSpring  是否使用弹性动画
 */
- (void)startAnimationToNum:(NSInteger)num
                  delayTime:(NSTimeInterval)delayTime
                usingSpring:(BOOL)isSpring;

/**
 * @brief 停止动画
 *
 */
- (void)stopAnimation;

@end
