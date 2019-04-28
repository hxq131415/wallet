//
//  XRDigitalView.m
//  XRDigitalScrollView
//
//  Created by rttx on 2018/9/13.
//  Copyright © 2018年 rttx. All rights reserved.
//
/**
 * 数字View 0 - 9
 */

#import "XRDigitalView.h"

static NSString * XRDigitalViewPositionBasicAnimationKey = @"XRDigitalViewPositionBasicAnimationKey";
static NSString * XRDigitalViewPositionSpringAnimationKey = @"XRDigitalViewPositionSpringAnimationKey";
static NSString * XRDigitalViewPositionAnimationKeyPath = @"position.y";

@interface XRDigitalView()
{
    CGFloat digitalLblHeight;
    CGFloat digitalLblWidth;
}

@property (nonatomic, strong) NSMutableArray <UILabel *>* subLblArray;

@end

@implementation XRDigitalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDigitalView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)setupDigitalView {
    
    _subLblArray = [NSMutableArray array];
    
    digitalLblHeight = CGRectGetHeight(self.frame) / 10;
    digitalLblWidth = CGRectGetWidth(self.frame);
    
    // 0 - 9+.
    for (NSInteger index = 0; index < 11; index++) {
        UILabel * digitalLbl = [[UILabel alloc] init];
        digitalLbl.frame = CGRectMake(0, digitalLblHeight * (CGFloat)index, digitalLblWidth, digitalLblHeight);
        digitalLbl.textAlignment = NSTextAlignmentCenter;
        digitalLbl.font = [UIFont boldSystemFontOfSize:40];
        digitalLbl.textColor = [UIColor whiteColor];
        if(index < 10)
        {
            digitalLbl.text = [NSString stringWithFormat:@"%ld", (long)index];
        }
        else
        {
            digitalLbl.text = [NSString stringWithFormat:@"%@", @"."];
        }
        [self addSubview:digitalLbl];
        [_subLblArray addObject:digitalLbl];
    }
}

- (CGSize)setDigitalNumTextColor:(UIColor *)textColor font:(UIFont *)font {
    
    CGSize fitSize = CGSizeZero;
    for (NSInteger index = 0; index < _subLblArray.count; index++) {
        UILabel * digitalLbl = _subLblArray[index];
        digitalLbl.textColor = textColor;
        digitalLbl.textAlignment = NSTextAlignmentCenter;
        digitalLbl.font = font;
        if(index < 10)
        {
            digitalLbl.text = [NSString stringWithFormat:@"%ld", (long)index];
        }
        else
        {
            digitalLbl.text = [NSString stringWithFormat:@"%@", @"."];
        }
        
        if (index == _subLblArray.count - 2) {
            [digitalLbl sizeToFit];
            fitSize = digitalLbl.frame.size;
        }
    }
    
    return fitSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    digitalLblHeight = CGRectGetHeight(self.frame) / 10;
    digitalLblWidth = CGRectGetWidth(self.frame);
    
    for (NSInteger index = 0; index < _subLblArray.count; index++) {
        UILabel * digitalLbl = [_subLblArray objectAtIndex:index];
        digitalLbl.frame = CGRectMake(0, digitalLblHeight * (CGFloat)index, digitalLblWidth, digitalLblHeight);
    }
}

// 开始动画到数字'num'
- (void)startAnimationToNum:(NSInteger)num
                  delayTime:(NSTimeInterval)delayTime
                usingSpring:(BOOL)isSpring {
    
    [self stopAnimation];
    
    NSInteger targetIndex = num + 1;
    
    if (isSpring) {
        if(num == 100)
        {
            CASpringAnimation * spAnima = [CASpringAnimation animationWithKeyPath:XRDigitalViewPositionAnimationKeyPath];
            spAnima.fromValue = @(self.layer.position.y);
            spAnima.toValue = @(self.layer.position.y - digitalLblHeight * (CGFloat)11);
            
            spAnima.autoreverses = NO;
            spAnima.removedOnCompletion = NO;
            spAnima.fillMode = kCAFillModeForwards;
            spAnima.beginTime = CACurrentMediaTime() + delayTime;
            spAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            
            spAnima.mass = 1.5;
            spAnima.stiffness = 28;
            spAnima.damping = 10;
            spAnima.initialVelocity = 0;
            spAnima.duration = spAnima.settlingDuration;
            
            
            [self.layer addAnimation:spAnima forKey:XRDigitalViewPositionSpringAnimationKey];
            
        }
        else
        {
            CASpringAnimation * spAnima = [CASpringAnimation animationWithKeyPath:XRDigitalViewPositionAnimationKeyPath];
            spAnima.fromValue = @(self.layer.position.y);
            spAnima.toValue = @(self.layer.position.y - digitalLblHeight * (CGFloat)targetIndex);
            
            spAnima.autoreverses = NO;
            spAnima.removedOnCompletion = NO;
            spAnima.fillMode = kCAFillModeForwards;
            spAnima.beginTime = CACurrentMediaTime() + delayTime;
            spAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            
            spAnima.mass = 1.5;
            spAnima.stiffness = 28;
            spAnima.damping = 10;
            spAnima.initialVelocity = 0;
            spAnima.duration = spAnima.settlingDuration;
            
            [self.layer addAnimation:spAnima forKey:XRDigitalViewPositionSpringAnimationKey];
        }
        
    }
    else {
        CABasicAnimation * posAnima = [CABasicAnimation animationWithKeyPath:XRDigitalViewPositionAnimationKeyPath];
        posAnima.fromValue = @(self.layer.position.y);
        posAnima.toValue = @(self.layer.position.y - digitalLblHeight * (CGFloat)(targetIndex));
        posAnima.duration = 0.24 * (CGFloat)(targetIndex);
        posAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        posAnima.removedOnCompletion = NO;
        posAnima.autoreverses = NO;
        posAnima.fillMode = kCAFillModeForwards;
        posAnima.beginTime = CACurrentMediaTime() + delayTime;
        
        [self.layer addAnimation:posAnima forKey:XRDigitalViewPositionBasicAnimationKey];
    }
}

// 结束动画
- (void)stopAnimation {
    
    if ([self.layer animationForKey:XRDigitalViewPositionBasicAnimationKey]) {
        [self.layer removeAnimationForKey:XRDigitalViewPositionBasicAnimationKey];
    }
    
    if ([self.layer animationForKey:XRDigitalViewPositionSpringAnimationKey]) {
        [self.layer removeAnimationForKey:XRDigitalViewPositionSpringAnimationKey];
    }
}

@end
