//
//  WSIResetViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/30.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIResetViewController.h"

@interface WSIResetViewController ()

@property (weak, nonatomic) IBOutlet UIButton *commitBt;

@property (weak, nonatomic) IBOutlet UITextField *emialTF;

@end

@implementation WSIResetViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"重置密码";
    
        self.contentSizeInPopup = CGSizeMake(300, 300);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad {
 
    [self setupConerRadius];
}

-(void)setupConerRadius {
    
    [_commitBt.layer setCornerRadius:3.0f];
    
}

- (IBAction)commitBt:(id)sender {
    
    [AVUser requestPasswordResetForEmailInBackground:_emialTF.text  block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [HUDUtils setupSuccessWithStatus:@"重置邮件已发送" WithDelay:1.5f completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        } else {
            
            [HUDUtils setupInfoWithStatus:@"请输入正确的邮箱地址" WithDelay:1.5f completion:nil];
        }
    }];
}

@end
