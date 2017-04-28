//
//  HUDUtils.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/12.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "HUDUtils.h"

@implementation HUDUtils

+(void)setupSuccessWithStatus:(NSString*)status WithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:13]];
    [SVProgressHUD dismissWithDelay:delay completion:completion];
    
}

+(void)setupErrorWithStatus:(NSString*)status WithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion{

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:13]];
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

+(void)setupInfoWithStatus:(NSString*)status WithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion {

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showInfoWithStatus:status];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:13]];
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

+(void)uploadImgWithProgress:(CGFloat)progress status:(NSString*)status completion:(SVProgressHUDDismissCompletion)completion{

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setCornerRadius:8];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showProgress:progress status:status];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:13]];
    
}

@end
