//
//  ColorCircleView.m
//  hangge_1770
//
//  Created by pan on 2019/2/16.
//  Copyright © 2019 hangge. All rights reserved.
//

#import "ColorCircleView.h"
@interface ColorCircleView ()

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@end
@implementation ColorCircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initType
{
    
    __block float a = 0;
    
    [self.circleArray enumerateObjectsUsingBlock:^(NSDictionary *obj,NSUInteger idx, BOOL *_Nonnull stop) {
        
    //创建出CAShapeLayer
        
        self.shapeLayer = [CAShapeLayer layer];
        
        self.shapeLayer.frame =CGRectMake(12.5,12.5, self.bounds.size.width,self.bounds.size.height);//设置shapeLayer的尺寸和位置
        
        //    self.shapeLayer.position = self.view.center;
        
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
        
        //设置线条的宽度和颜色
        
        self.shapeLayer.lineWidth =25.0f;
        
        self.shapeLayer.strokeColor = [obj[@"strokeColor"]CGColor];
        
        //创建出圆形贝塞尔曲线
        //设置半径为10
        CGFloat radius = (self.bounds.size.width-12.5)/2.0f;
        //按照顺时针方向
        BOOL clockWise = true;
        //初始化一个路径
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.bounds.size.width-25)/2.0f, (self.bounds.size.width-25)/2.0f) radius:radius startAngle:(-0.5f*M_PI) endAngle:1.5f*M_PI clockwise:clockWise];
        
        
        
        
        
        
//        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0, self.bounds.size.width-25,self.bounds.size.height-25)];
        
        //让贝塞尔曲线与CAShapeLayer产生联系
        
        self.shapeLayer.path = circlePath.CGPath;
        
        self.shapeLayer.strokeStart = a;
        
        self.shapeLayer.strokeEnd = [obj[@"precent"]floatValue] + a;
        
        a = self.shapeLayer.strokeEnd;
        
        //添加并显示
        
        [self.layer addSublayer:self.shapeLayer];
        
        
        
        
        //添加圆环动画
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        pathAnimation.duration = 0.5;
        
        pathAnimation.fromValue = @(0);
        
        pathAnimation.toValue = @(1);
        
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [self.shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
    }];
    
}



- (void)setCircleArray:(NSArray *)circleArray

{
    
    _circleArray = circleArray;
    
    [self initType];
    
    
    
}

@end
