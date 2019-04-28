//
//  LGProgressView.h
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/24.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LQProgressBorderMode) {
    LQProgressBorderModeNormal = 1,
    LQProgressBorderModeRound
};

@interface LGProgressView : UIView


@property (nonatomic, assign) LQProgressBorderMode progressBorderMode;
@property (nonatomic, assign) CGFloat progress;//进度
@property (nonatomic, strong) UIColor *progressTintColor;//进度的颜色
@property (nonatomic, assign) BOOL pause;//暂停与否

@end

NS_ASSUME_NONNULL_END
