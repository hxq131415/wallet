//
//  XRWaveView.h
//  XRWaveView
//
//  Created by rttx on 2018/9/14.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRWaveView : UIView

@property (nonatomic, strong) UIColor * backWaveColor;
@property (nonatomic, strong) UIColor * foreWaveColor;

// 波浪显示的百分比 0 - 1.0
@property (nonatomic, assign) CGFloat wavePercent;
// 是否需要上升
@property (nonatomic, assign) BOOL isNeedRise;

// 开始Wave动画
- (void)beginWave;
// 结束Wave动画
- (void)endWave;

@end
