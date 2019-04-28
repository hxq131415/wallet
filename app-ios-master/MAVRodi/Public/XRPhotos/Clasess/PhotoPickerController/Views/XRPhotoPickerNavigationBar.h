//
//  XRPhotoPickerNavigationBar.h
//  XRPhotos
//
//  Created by rttx on 2017/12/26.
//  Copyright © 2017年 rttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRPhotoPickerNavigationBar : UIView

@property (nonatomic, strong) UIView * bottomLineView;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;

@property (nonatomic, copy) void (^leftBtnClickBlock)(void);
@property (nonatomic, copy) void (^rightBtnClickBlock)(void);

@end
