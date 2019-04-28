//
//  NTPhotoBrowser.m
//  NTMember
//
//  Created by rttx on 2017/12/27.
//  Copyright © 2017年 MT. All rights reserved.
//
//  基于`MWPhotoBrowser`定制的图片预览

#define iSiPhoneX \
\
([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)\
\
|| ([UIScreen mainScreen].bounds.size.width == 812 && [UIScreen mainScreen].bounds.size.height == 375)

#define XR_Screen_Size [UIScreen mainScreen].bounds.size
#define XR_NavigationBar_Height (iSiPhoneX ? 88 : 64)
#define XR_Virtual_Bottom_Height (iSiPhoneX ? 34 : 0)
#define XR_StatusBar_Height  (iSiPhoneX ? 44 : 20)

#import "NTPhotoBrowser.h"
#import <MWPhotoBrowser/MWPhotoBrowserPrivate.h>

@interface MWPhotoBrowser ()

- (void)updateNavigation;

@end

@interface NTPhotoBrowser ()

@property (nonatomic, strong) UIView * navigationBarView;
@property (nonatomic, strong) UILabel * titleLbl;

@end

@implementation NTPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //---- Custom Navigation Bar -----
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XR_Screen_Size.width, XR_NavigationBar_Height)];
    _navigationBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.16];
    [self.view addSubview:_navigationBarView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, XR_StatusBar_Height, 40, XR_NavigationBar_Height - XR_StatusBar_Height);
    [backBtn setImage:[UIImage imageNamed:@"icon_nav_left_white"] forState:UIControlStateNormal];
    [_navigationBarView addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(_navigationBarView.frame) - 100) * 0.5, XR_StatusBar_Height, 100, XR_NavigationBar_Height - XR_StatusBar_Height)];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.textColor = [UIColor whiteColor];
    _titleLbl.font = [UIFont systemFontOfSize:16];
    [_navigationBarView addSubview:_titleLbl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnAction {
    
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Override Methods

- (void)updateNavigation {
    
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    if (numberOfPhotos > 1) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:titleForPhotoAtIndex:)]) {
            self.titleLbl.text = [self.delegate photoBrowser:self titleForPhotoAtIndex:self.currentIndex];
        } else {
            self.titleLbl.text = [NSString stringWithFormat:@"%lu %@ %lu", (unsigned long)(self.currentIndex+1), @"/", (unsigned long)numberOfPhotos];
        }
    } else {
        self.titleLbl.text = @"图片预览";
    }
}

@end
