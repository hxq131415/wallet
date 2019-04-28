//
//  UIViewController+HUD.m
//  StupidFM
//
//  Created by S.K. on 15/6/3.
//  Copyright (c) 2015年 S.K. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/runtime.h>

// 屏幕尺寸
#define MainScreen_Size [UIScreen mainScreen].bounds.size
// 提示距离屏幕底部的距离
#define DistanceInfoToBottom 70.0

// 设备定义
#define iPhone4S    (MainScreen_Size.height == 480? YES: NO)
// iPhone5 == iPhone5S
#define iPhone5S    (MainScreen_Size.height == 568? YES: NO)
#define iPhone6     (MainScreen_Size.height == 667? YES: NO)
#define iPhone6Plus (MainScreen_Size.height == 736? YES: NO)

static CGFloat const KK_ALERT_CONTENT_VIEW_MIN_SIZE                     = 100;   //alert内容区域最小尺寸
static CGFloat const KK_ALERT_CONTENT_VIEW_MAX_SIZE                     = 220;  //alert内容区域最大尺寸
static CGFloat const KK_ALERT_CONTENT_VIEW_INSET_SPACE                  = 12;
static CGFloat const KK_ALERT_CONTENT_TEXT_ORIGIN_Y                     = 85;   //内容顶部距离
static CGFloat const KK_ALERT_ICON_IMAGE_SIZE                           = 58;   //标题icon图片大小

static const void * HttpRequestHUDKey = &HttpRequestHUDKey;

static NSInteger const customProgressHUDTag = 9892283;
static NSInteger const kProgressHUDTag = 208283;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 * @brief  显示等待加载的信息
 *
 */
- (void)showWithMessage:(NSString *)message InView:(UIView *)view
{
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.tag = kProgressHUDTag;
    HUD.label.font       = [UIFont systemFontOfSize:14.0f];
    HUD.label.text       = message;
    HUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    HUD.contentColor = [UIColor whiteColor];
    HUD.square          = YES;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

/**
 * @brief  显示提示信息
 *
 */
- (void)showMessage:(NSString *)message
{
    UIView * view       = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode=MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize textSize = [message boundingRectWithSize:CGSizeMake((self.view.frame.size.width - 60.0), MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 0;
    hud.customView= label;
    hud.margin = 10.0;
    hud.offset = CGPointMake(0, MainScreen_Size.height * 0.5 - textSize.height * 0.5 - DistanceInfoToBottom);
    
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)hideHUDWithSuperView:(UIView *)superVw {
    [[superVw viewWithTag:kProgressHUDTag] removeFromSuperview];
}

/**
 * @brief  隐藏HUD
 * 
 */
- (void)hideHUD
{
    [[self HUD] hideAnimated:YES];
}

- (void)hideHUDWith:(BOOL)animated
{
    [[self HUD] hideAnimated:animated];
    
    UIView * view = [[UIApplication sharedApplication].delegate window];
    for (UIView *view_ in view.subviews) {
        if ([view_ isKindOfClass:MBProgressHUD.class]) {
            [view_ removeFromSuperview];
        }
    }
}

/**
 * @brief  在指定位置显示提示信息
 *
 * @param  yOffset 距离HUD superView的中点y的偏移量
 *
 */
- (void)showMessage:(NSString *)message yOffSet:(float)yOffset
{
    UIView * view = [[UIApplication sharedApplication].delegate window];
    
    if (nil != [view viewWithTag:customProgressHUDTag]) {
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = customProgressHUDTag;
    hud.mode=MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize textSize = [message boundingRectWithSize:CGSizeMake((self.view.frame.size.width - 60.0), MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15.0];
    label.numberOfLines = 0;
    hud.customView= label;
    hud.margin = 12.5;
    hud.offset = CGPointMake(0, MainScreen_Size.height * 0.5 - textSize.height * 0.5 - yOffset);
    
    [hud hideAnimated:YES afterDelay:1];
}

/**
 * @brief  在底部位置显示提示信息
 *
 */
- (void)showBottomMessage:(NSString *)message
{
    UIView * view = [[UIApplication sharedApplication].delegate window];
    
    if (nil != [view viewWithTag:customProgressHUDTag]) {
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = customProgressHUDTag;
    hud.mode=MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize textSize = [message boundingRectWithSize:CGSizeMake((self.view.frame.size.width - 60.0), MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 0;
    hud.customView= label;
    hud.margin = 12;
    hud.offset = CGPointMake(0, MainScreen_Size.height * 0.5 - textSize.height * 0.5 - DistanceInfoToBottom);
 
    [hud hideAnimated:YES afterDelay:1];
}

/**
 * @brief  只显示文字提示信息
 *
 */
- (void)showMessageText:(NSString *)message toView:(UIView *)view {
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = customProgressHUDTag;
    hud.mode=MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize textSize = [message boundingRectWithSize:CGSizeMake((self.view.frame.size.width - 60.0), MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 0;
    hud.customView= label;
    hud.margin = 12;
    
    [hud hideAnimated:YES afterDelay:1];
}

/**
 * @brief  只显示文字提示信息
 *
 */
- (void)showMessageText:(NSString *)message
{
    UIView * view = [[UIApplication sharedApplication].delegate window];
    
    if (nil != [view viewWithTag:customProgressHUDTag]) {
        return;
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = customProgressHUDTag;
    hud.mode=MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize textSize = [message boundingRectWithSize:CGSizeMake((self.view.frame.size.width - 60.0), MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 0;
    hud.customView= label;
    hud.margin = 12;
    
    [hud hideAnimated:YES afterDelay:1];
}

//自定义HUD
- (void)showMessageText:(NSString *)message TextSize:(CGFloat)size LabelColor:(UIColor *)labelColor Margin:(CGFloat)margin BackgroundColor:(UIColor *)color CornerRadius:(CGFloat)cornerRadius Square:(BOOL)isSquare HideTime:(CGFloat)hideTime Opacity:(CGFloat)opacity
{
    UIView * view       = [[UIApplication sharedApplication].delegate window];
    self.HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.HUD.mode            = MBProgressHUDModeText;
    self.HUD.userInteractionEnabled = NO;
    self.HUD.label.text       = message;
    self.HUD.label.font       = [UIFont systemFontOfSize:size];
    self.HUD.label.textColor      = labelColor;
    self.HUD.margin          = margin;
    self.HUD.bezelView.backgroundColor           = color;
//    self.HUD.cornerRadius    = cornerRadius;
    self.HUD.square          = isSquare;
//    self.HUD.opacity         = opacity;
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hideAnimated:YES afterDelay:hideTime];
}

//MARK: - 自定义成功失败
/**
 * @brief  显示成功提示
 *
 */
- (void)showSuccessMessage:(NSString *)message
{
    
    UIView * view       = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed: @"icon_consume_success"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.square = YES;
    hud.label.text = message;
    
    [hud hideAnimated:YES afterDelay:1.f];
 
}

// 显示图片和文字的HUD
- (void)showHUDWithSuccessText:(NSString *)message {
    
    UIView * view       = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed: @"icon_consume_success"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.square = YES;
    hud.label.text = message;
    
    [hud hideAnimated:YES afterDelay:1.f];
    
}

/**
 * @brief  显示失败提示
 */
- (void)showErrorMessage:(NSString *)message
{
    
    UIView * view       = [[UIApplication sharedApplication].delegate window];

    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed: @"icon_warning_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.square = YES;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:1.f];
    
}

- (void)showMessage:(NSString *)message icon:(NSString *)icon
{
    UIView * view       = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed: icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    hud.contentColor = [UIColor whiteColor];
    hud.square = YES;
    hud.label.text = message;
    
    [hud hideAnimated:YES afterDelay:1.f];
}
@end
