//
//  XRDigitalScrollView.m
//  XRDigitalScrollView
//
//  Created by rttx on 2018/9/13.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import "XRDigitalScrollView.h"
#import "XRDigitalView.h"

@interface XRDigitalScrollView()
{
    CGFloat digitalViewWidth;
    CGFloat digitalViewHeight;
}

@property (nonatomic, strong) NSMutableArray <XRDigitalView *> * digitalViewArray;
@property (nonatomic, copy) NSString * numString;

@end

@implementation XRDigitalScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.layer.masksToBounds = YES;
    _digitalViewArray = [NSMutableArray array];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger length = [self.numString length];
    
    digitalViewWidth = CGRectGetWidth(self.bounds) / (CGFloat)length;
    digitalViewHeight = CGRectGetHeight(self.bounds);
    
    for (NSInteger index = 0; index < length; index++) {
        XRDigitalView * digitalView = [_digitalViewArray objectAtIndex:index];
        digitalView.frame = CGRectMake(digitalViewWidth * (CGFloat)index, digitalViewHeight, digitalViewWidth, digitalViewHeight * 10);
    }
}

- (CGSize)setDigitalNumWithNumString:(NSString *)numStr
                         textColor:(UIColor *)textColor
                          textFont:(UIFont *)font {
    
    if (numStr.length <= 0) {
        return CGSizeZero;
    }
    
    self.numString = numStr;
    
    if (_digitalViewArray.count > 0) {
        for (XRDigitalView * digitalVw in _digitalViewArray) {
            [digitalVw removeFromSuperview];
        }
    }
    
    [_digitalViewArray removeAllObjects];
    
    NSInteger length = [numStr length];
    
    digitalViewWidth = CGRectGetWidth(self.bounds) / (CGFloat)length;
    digitalViewHeight = CGRectGetHeight(self.bounds);
    
    CGSize fitSize = CGSizeZero;
    
    for (NSInteger index = 0; index < length; index++) {
        XRDigitalView * digitalView = [[XRDigitalView alloc] initWithFrame:CGRectMake(digitalViewWidth * (CGFloat)index, digitalViewHeight, digitalViewWidth, digitalViewHeight * 10)];
        [self addSubview:digitalView];
        fitSize = [digitalView setDigitalNumTextColor:textColor font:font];
        [_digitalViewArray addObject:digitalView];
    }
    
    return fitSize;
}

// 开始动画
- (void)beginAnimation {
    
    for (NSInteger index = 0; index < _digitalViewArray.count; index++) {
        XRDigitalView * digitalVw = _digitalViewArray[index];
        NSString * subNumStr = [self.numString substringWithRange:NSMakeRange(index, 1)];
        NSScanner* scan = [NSScanner scannerWithString:subNumStr];
        int val;
        BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
        
        NSTimeInterval delayTime = (_digitalViewArray.count - 1 - index) * 0.3;
        BOOL isUsingSpring = index == 0 ? YES : NO;
        if(!isNum)
        {
            [digitalVw startAnimationToNum:100 delayTime:delayTime usingSpring:YES];
        }
        else{
            [digitalVw startAnimationToNum:[subNumStr integerValue] delayTime:delayTime usingSpring:isUsingSpring];
        }
        
    }
}

@end
