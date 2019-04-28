//
//  LGProgressView.m
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/24.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

#import "LGProgressView.h"

@interface LGProgressView ()
@property(nonatomic, strong)CAGradientLayer *gradienLayer;
@end

@implementation LGProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, self.bounds.size.height);
    CGContextMoveToPoint(ctx, 0,self.bounds.size.height/2);
    if (self.pause) {
        [[UIColor colorWithWhite:0.1 alpha:0.5] set];
    }
    else if (self.progressTintColor) {
        [self.progressTintColor set];
    }
    else {
        [[UIColor redColor] set];
    }
    CGContextAddLineToPoint(ctx, self.bounds.size.width*_progress, self.bounds.size.height/2);
    CGContextStrokePath(ctx);
    
    [self startAnimationWithLayer:self.gradienLayer];
    
}

- (void)setProgressBorderMode:(LQProgressBorderMode)progressBorderMode {
    _progressBorderMode = progressBorderMode;
    
    switch (progressBorderMode) {
        case LQProgressBorderModeNormal:{
            //不做处理
            break;
        }
        case LQProgressBorderModeRound:{
            self.layer.cornerRadius = self.bounds.size.height/2;
            self.layer.masksToBounds = YES;
            break;
        }
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)startAnimationWithLayer:(CAGradientLayer *)layer {
    if (_progress == 0 || _progress >= 1) {
        layer.hidden = YES;
        return;
    }
    CGFloat toValue = self.bounds.size.width*_progress-layer.bounds.size.width/2;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = @(-10);
    animation.toValue = @(toValue);
    animation.duration = 0.5;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:nil];
}

#pragma mark - lazy

-(CAGradientLayer *)gradienLayer {
    if (!_gradienLayer) {
        _gradienLayer = [CAGradientLayer layer];
        _gradienLayer.frame = CGRectMake(0, 0, 50, self.bounds.size.height);
        _gradienLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor , (__bridge id)[UIColor clearColor].CGColor];
        _gradienLayer.startPoint = CGPointMake(0, 0.5);
        _gradienLayer.endPoint = CGPointMake(1, 0.5);
        
        [self.layer addSublayer:_gradienLayer];
    }
    return _gradienLayer;
}

@end
