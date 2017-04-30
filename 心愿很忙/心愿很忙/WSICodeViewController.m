//
//  WSICodeViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/29.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSICodeViewController.h"
#import "WSIRegisterViewController.h"
#import "WSIResetViewController.h"
#import <STPopupController.h>

@interface WSICodeViewController ()
/**用户名或手机号*/
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
/**密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwdTF;
/**忘记密码*/
@property (weak, nonatomic) IBOutlet UIButton *forgotBt;
/**登录按钮*/
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
/**重置密码*/
@property(nonatomic,strong)STPopupController *popVc;
@end

@implementation WSICodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConerRadius];
    [self setupTF];
}

-(void)setupConerRadius {
    
    
    [_loginBt.layer setCornerRadius:3.0f];
    [_forgotBt.layer setCornerRadius:2.0f];
    
}

/**设置输入框的头像*/

-(void)setupTF {
    
    UIImageView *imageIv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"笑脸2"]];
    imageIv.frame = CGRectMake(0, 0, 25, 25);
    _usernameTF.leftView = imageIv;
    _usernameTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageIv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码"]];
    imageIv2.frame = CGRectMake(0, 0, 29, 29);
    _passwdTF.leftView = imageIv2;
    _passwdTF.leftViewMode = UITextFieldViewModeAlways;
    
}


#pragma mark - 按钮事件监听

- (IBAction)Register:(UIButton *)sender {
    
    WSIRegisterViewController *registerVc = [[WSIRegisterViewController alloc]initWithNibName:@"WSIRegisterViewController" bundle:[NSBundle mainBundle]];
    
    [self presentViewController:registerVc animated:YES completion:nil];
}


- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)forgotBt:(id)sender {
    
    [STPopupNavigationBar appearance].barTintColor = [UIColor colorWithRed:0/255.0
                                                                    green:0/255.0
                                                                    blue:0/255.0
                                                                    alpha:1.0];
    
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName:
                                                               [UIFont fontWithName:nil size:15],
                                                                NSForegroundColorAttributeName:
                                                               [UIColor whiteColor] };
    
    
    WSIResetViewController *meVc = [WSIResetViewController new];
    _popVc = [[STPopupController alloc] initWithRootViewController:meVc];
    _popVc.containerView.layer.cornerRadius = 4.0f;
    
    
    [_popVc presentInViewController:self];
    
    [_popVc.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(backgroundViewDidTap)]];

}


-(void)backgroundViewDidTap {
    
    [_popVc dismiss];
    
}


- (IBAction)login:(id)sender {
    
    [self.view endEditing:YES];
    
    [AVUser logInWithUsernameInBackground:_usernameTF.text password:_passwdTF.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            
            NSLog(@"登录成功");
            
            [HUDUtils setupSuccessWithStatus:@"登录成功" WithDelay:1.5f completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissToRootViewController];
                
            });
            
        } else {
            
            NSLog(@"登录失败---%@", error);
            
            [HUDUtils setupErrorWithStatus:@"登录失败" WithDelay:1.5f completion:nil];
        }
    }];
    
}

/**直接dismiss到主界面*/

-(void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
