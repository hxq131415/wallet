//
//  WBQRCodeVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 2018/2/8.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WBQRCodeRegizerFinishCallBack)(NSString *result);

@interface WBQRCodeVC : UIViewController

@property (nonatomic, copy) WBQRCodeRegizerFinishCallBack regizerFinishCallBack;

@property (nonatomic, copy) NSString * navTitle;
@property (nonatomic, copy) NSString * startingPrompt;

@end
