//
//  HUDUtils.h
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/12.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD.h>

@interface HUDUtils : NSObject
#pragma mark - 设置SVProgressHUD

+(void)setupSuccessWithStatus:(NSString*)status WithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion;

+(void)setupErrorWithStatus:(NSString*)status WithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion;
@end
