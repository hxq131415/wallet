//
//  XRWaveView.m
//  XRWaveView
//
//  Created by rttx on 2018/9/14.
//  Copyright © 2018年 rttx. All rights reserved.
//

/**
 * 正弦曲线实现波浪View动画
 */

#import "XRWaveView.h"

@interface XRWaveView()
{
    CGFloat yRisePercent;
    CGFloat waveWidth;
    CGFloat waveHeight;
}

@property (nonatomic, strong) CADisplayLink * displayLink;
@property (nonatomic, strong) CAShapeLayer * foreWaveLayer;
@property (nonatomic, strong) CAShapeLayer * backWaveLayer;
@property (nonatomic, strong) CAGradientLayer * gradientLayer;

// A :振幅,曲线最高位和最低位的距离
@property (nonatomic, assign) CGFloat amplitude;
// φ :初相,曲线左右偏移量
@property (nonatomic, assign) CGFloat waveX;
// k :偏距,曲线上下偏移量
@property (nonatomic, assign) CGFloat k;
// ω :角速度,用于控制周期大小，单位x中起伏的个数
@property (nonatomic, assign) double angluaVelocity;

@end

@implementation XRWaveView
@synthesize foreWaveLayer = foreWaveLayer;
@synthesize backWaveLayer = backWaveLayer;
@synthesize amplitude = amplitude;
@synthesize waveX = waveX;
@synthesize k = k;
@synthesize angluaVelocity = angluaVelocity;

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
        return self;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        return self;
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    backWaveLayer.frame = self.bounds;
    _gradientLayer.frame = self.bounds;
    
    waveHeight = CGRectGetHeight(self.bounds);
    waveWidth = CGRectGetWidth(self.bounds);
    
    k = waveHeight * yRisePercent;
    
    angluaVelocity = M_PI / waveWidth;
}

- (void)setup {
    
    _backWaveColor = [UIColor blueColor];
    _foreWaveColor = [UIColor redColor];
    
    waveHeight = CGRectGetHeight(self.bounds);
    waveWidth = CGRectGetWidth(self.bounds);
    
    _wavePercent = 0.0;
    waveX = 0;
    yRisePercent = 1 - _wavePercent;
    k = waveHeight * yRisePercent;
    
    // 角速度
    angluaVelocity = M_PI / waveWidth;
    amplitude = 10;
    
    backWaveLayer = [CAShapeLayer layer];
    backWaveLayer.frame = self.bounds;
    [self.layer addSublayer:backWaveLayer];
    
    foreWaveLayer = [CAShapeLayer layer];
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    [_gradientLayer setMask:foreWaveLayer];
    [self.layer addSublayer:_gradientLayer];
    
    [self setupWavePath];
}

// 设置初始化时的Wave Path
- (void)setupWavePath {
    
    // back Wave
    CGFloat y = k;
    
    backWaveLayer.fillColor = [UIColor purpleColor].CGColor;
    backWaveLayer.fillMode = kCAFillModeForwards;
    
    CGMutablePathRef backWavePath = CGPathCreateMutable();
    CGPathMoveToPoint(backWavePath, nil, waveX, y);
    
    for (int index = 0; index < waveWidth; index++) {
        y = amplitude * cos(angluaVelocity * (CGFloat)index + waveX) + k;
        CGPathAddLineToPoint(backWavePath, nil, (CGFloat)index, y);
    }
    
    CGPathAddLineToPoint(backWavePath, nil, waveWidth, waveHeight);
    CGPathAddLineToPoint(backWavePath, nil, 0, waveHeight);
    CGPathCloseSubpath(backWavePath);
    
    backWaveLayer.path = backWavePath;
    
    CGPathRelease(backWavePath);
    
    // fore Wave
    
    CGMutablePathRef foreWavePath = CGPathCreateMutable();
    CGPathMoveToPoint(foreWavePath, nil, waveX, y);
    
    for (int index = 0; index <= waveWidth; index++) {
        y = amplitude * sin(angluaVelocity * (CGFloat)index + waveX) + k;
        CGPathAddLineToPoint(foreWavePath, nil, (CGFloat)index, y);
    }
    
    CGPathAddLineToPoint(foreWavePath, nil, waveWidth, waveHeight);
    CGPathAddLineToPoint(foreWavePath, nil, 0, waveHeight);
    CGPathCloseSubpath(foreWavePath);
    
    foreWaveLayer.path = foreWavePath;
    
    CGPathRelease(foreWavePath);
}

#pragma mark - Setter
- (void)setBackWaveColor:(UIColor *)backWaveColor {
    if (_backWaveColor != backWaveColor) {
        _backWaveColor = backWaveColor;
    }
    
    backWaveLayer.fillColor = _backWaveColor.CGColor;
}

- (void)setForeWaveColor:(UIColor *)foreWaveColor {
    if (_foreWaveColor != foreWaveColor) {
        _foreWaveColor = foreWaveColor;
    }
    
    _gradientLayer.colors = @[(__bridge id)foreWaveColor.CGColor, (__bridge id)foreWaveColor.CGColor];
    _gradientLayer.locations = @[@(0.0), @(1.0)];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
}

// 开始Wave动画
- (void)beginWave {
    
    [self endWave];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

// 结束Wave动画
- (void)endWave {
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

/**
 y = Asin(ωx+φ) + k \ y = Acos(ωx+φ) + k
 A :振幅,曲线最高位和最低位的距离
 
 ω :角速度,用于控制周期大小，单位x中起伏的个数
 
 K :偏距,曲线上下偏移量
 
 φ :初相,曲线左右偏移量
 */
- (void)updateWave {
    
    CGMutablePathRef foreWavePath = CGPathCreateMutable();
    CGPathMoveToPoint(foreWavePath, nil, 0, 0);
    
    // 波峰值
    if (_isNeedRise) {
        yRisePercent -= 0.005;
        if (yRisePercent <= (1.0 - _wavePercent)) {
            yRisePercent = (1.0 - _wavePercent);
        }
    }
    else {
        yRisePercent = 1.0 - _wavePercent;
    }
    
    CGFloat k = waveHeight * yRisePercent;
    
    double angluaVelocity = M_PI / waveWidth;
    
    // 移动角度速度，每次runloop移动 M_PI / waveWidth * 5.0 角度
    waveX += (angluaVelocity * 2.5);
    
    // 2π为一个正弦波移动周期，当waveX >= 2π的倍数时置零，避免waveX一直累加导致溢出
    if (waveX >= M_PI_2 * 6 * 4) {
        waveX = 0;
    }
    
    CGFloat y = k;
    
    for (int index = 0; index < waveWidth; index++) {
        y = amplitude * sin(angluaVelocity * (CGFloat)index + waveX) + k;
        CGPathAddLineToPoint(foreWavePath, nil, (CGFloat)index, y);
    }
    
    CGPathAddLineToPoint(foreWavePath, nil, waveWidth, waveHeight);
    CGPathAddLineToPoint(foreWavePath, nil, 0, waveHeight);
    CGPathCloseSubpath(foreWavePath);
    
    foreWaveLayer.path = foreWavePath;
    
    CGPathRelease(foreWavePath);
    
    // back Wave Path
    CGMutablePathRef backWavePath = CGPathCreateMutable();
    CGPathMoveToPoint(backWavePath, nil, 0, y);
    
    for (int index = 0; index < waveWidth; index++) {
        y = amplitude * cos(angluaVelocity * (CGFloat)index + waveX) + k;
        CGPathAddLineToPoint(backWavePath, nil, (CGFloat)index, y);
    }
    
    CGPathAddLineToPoint(backWavePath, nil, waveWidth, waveHeight);
    CGPathAddLineToPoint(backWavePath, nil, 0, waveHeight);
    CGPathCloseSubpath(backWavePath);
    
    backWaveLayer.path = backWavePath;
    
    CGPathRelease(backWavePath);
    
}

@end
