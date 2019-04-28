//
//  XRDigitalScrollView.h
//  XRDigitalScrollView
//
//  Created by rttx on 2018/9/13.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRDigitalScrollView : UIView

/**
 * @brief 设置需要显示的数字
 *
 * @param numStr 需要显示的数字字符串
 * @param textColor 文字颜色
 * @param font      字体
 *
 * @return 返回一个数字显示的合适最小size
 */
- (CGSize)setDigitalNumWithNumString:(NSString *)numStr
                         textColor:(UIColor *)textColor
                          textFont:(UIFont *)font;

/**
 * @brief 开始动画
 */
- (void)beginAnimation;

@end
