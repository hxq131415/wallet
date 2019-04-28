//
//  CircularProgressView.m
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/24.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

#import "CircularProgressView.h"

@implementation CircularProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //默认颜色
        self.progerssBackgroundColor=[UIColor lightGrayColor];
        self.progerssColor=[UIColor blueColor];
        self.percentFontColor=[UIColor blueColor];
        //默认进度条宽度
        self.progerWidth=15;
        //默认百分比字体大小
        self.percentageFontSize=22;
        
        //百分比标签
        UILabel *cLabel = [[UILabel alloc] initWithFrame:self.bounds];
        cLabel.font = [UIFont boldSystemFontOfSize:self.percentageFontSize];
        cLabel.textColor = self.percentFontColor;
        cLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cLabel];
        self.cLabel = cLabel;
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super frame];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    //默认颜色
    self.progerssBackgroundColor=[UIColor lightGrayColor];
    self.progerssColor=[UIColor blueColor];
    self.percentFontColor=[UIColor blueColor];
    //默认进度条宽度
    self.progerWidth=15;
    //默认百分比字体大小
    self.percentageFontSize=22;
    
    //百分比标签
    UILabel *cLabel = [[UILabel alloc] initWithFrame:self.bounds];
    cLabel.font = [UIFont boldSystemFontOfSize:self.percentageFontSize];
    cLabel.textColor = self.percentFontColor;
    cLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cLabel];
    self.cLabel = cLabel;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.cLabel.frame = self.bounds;
    
}

-(void)setProgerssBackgroundColor:(UIColor *)progerssBackgroundColor {
    _progerssBackgroundColor = progerssBackgroundColor;
    
    [self setNeedsDisplay];
}

-(void)setProgerssColor:(UIColor *)progerssColor {
    _progerssColor = progerssColor;
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

-(void)setProgerWidth:(CGFloat)progerWidth {
    _progerWidth = progerWidth;
    
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _cLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    //路径
    UIBezierPath *backgroundPath = [[UIBezierPath alloc] init];
    //线宽
    backgroundPath.lineWidth = self.progerWidth;
    //颜色
    [self.progerssBackgroundColor set];
    //拐角
    backgroundPath.lineCapStyle = kCGLineCapRound;
    backgroundPath.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - self.progerWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [backgroundPath addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2  clockwise:YES];
    //连线
    [backgroundPath stroke];
    
    
    //路径
    UIBezierPath *progressPath = [[UIBezierPath alloc] init];
    //线宽
    progressPath.lineWidth = self.progerWidth;
    //颜色
    [self.progerssColor set];
    //拐角
    progressPath.lineCapStyle = kCGLineCapRound;
    progressPath.lineJoinStyle = kCGLineJoinRound;
    
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [progressPath addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [progressPath stroke];
}


@end
