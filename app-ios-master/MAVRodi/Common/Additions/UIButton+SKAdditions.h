//
//  UIButton+SKAdditions.h
//  SKEasyy
//
//  Created by 王 顺强 on 16/8/28.
//  Copyright © 2016年 S.K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(SKAdditions)

@property (nonatomic,retain,nullable) NSDictionary *buttonInfo;
@property (nonatomic, assign) UIEdgeInsets nt_hitInsets;

//垂直居中(图片上面，文字下面)
- (void)verticalCenterButtonSetting;
- (void)verticalCenterButtonSettingWithSpace:(CGFloat)space;

//图片右边，文字左边
- (void)titleLeftImageRightSetting;
- (void)titleLeftImageRightSettingWithSpace:(CGFloat)space;

- (void)titleRightAndImageLeftSettingWithSpace:(CGFloat)space;
@end
