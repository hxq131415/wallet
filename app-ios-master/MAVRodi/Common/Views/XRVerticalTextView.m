//
//  XRVerticalTextView.m
//  MAVRodi
//
//  Created by rttx on 2018/9/14.
//  Copyright © 2018年 rttx. All rights reserved.
//

/**
 * CoreText 绘制竖排文字
 */

#import "XRVerticalTextView.h"
#import <CoreText/CoreText.h>

@implementation XRVerticalTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
        return self;
    }
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        return self;
    }
    
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
        return self;
    }
    
    return nil;
}

#pragma mark - Setter
- (void)setVeritalText:(NSString *)veritalText {
    if (veritalText != _veritalText) {
        _veritalText = veritalText;
        
        [self setNeedsDisplay];
    }
}

- (void)setAttributes:(NSDictionary *)attributes {
    if (attributes != _attributes) {
        _attributes = attributes;
        
        [self setNeedsDisplay];
    }
}

- (void)setup {
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

// CoreText 绘制竖排文字
- (void)drawRect:(CGRect)rect {
    
    _veritalText = [_veritalText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_veritalText == nil || [_veritalText isEqualToString:@""]) {
        return;
    }
    
    if ([_veritalText length] == 0) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:_veritalText attributes:_attributes];
    
    CGSize fitSize = [[_veritalText substringWithRange:NSMakeRange(0, 1)] sizeWithAttributes:_attributes];
    CGFloat textHeight = [_veritalText sizeWithAttributes:_attributes].width;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, CGRectMake((CGRectGetWidth(self.bounds) - fitSize.width) * 0.5, -(CGRectGetHeight(self.bounds) - textHeight) * 0.5, fitSize.width, CGRectGetHeight(self.bounds)));
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    CTFrameRef tfFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), path, (__bridge CFDictionaryRef)_attributes);
    
    CTFrameDraw(tfFrame, ctx);
    
    // Release
    CGPathRelease(path);
    CFRelease(framesetter);
    CFRelease(tfFrame);
}

@end
