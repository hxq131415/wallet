//
//  NSData+Additions.h
//  TeaExpoentNet
//
//  Created by rttx on 2018/5/28.
//  Copyright © 2018年 rttx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)
- (NSString *)skContentTypeForImageData;
- (NSString *)fileExtensionForImageData;
- (NSString *)sha256String;
@end
