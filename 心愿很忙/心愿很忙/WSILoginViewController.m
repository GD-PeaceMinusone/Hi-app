//
//  WSILoginViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/8.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSILoginViewController.h"
#import "WSIRegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import <Masonry.h>
#import "HUDUtils.h"

@interface WSILoginViewController ()
/**关闭按钮*/
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
/**背景图*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**登录视图*/
@property (weak, nonatomic) IBOutlet UIView *loginView;
/**登录按钮*/
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/**忘记密码*/
@property (weak, nonatomic) IBOutlet UIButton *forgot;
/**输入用户名*/
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
/**输入密码*/
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;

@end

@implementation WSILoginViewController

#pragma mark - 一些初始化操作
- (void)viewDidLoad {
    
    [self setupImageView];
    [self setupConerRadius];
}

-(void)setupConerRadius {

    [self.loginView.layer setCornerRadius:4.0f];
    [self.loginButton.layer setCornerRadius:3.0f];
    [self.forgot.layer setCornerRadius:2.0f];
}


/*对imageView进行半透明处理**/

-(void)setupImageView {

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = [UIScreen mainScreen].bounds;
    [self.imageView addSubview:effectView];
    
    UIVibrancyEffect *vibrancyView = [UIVibrancyEffect effectForBlurEffect:effect];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyView];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [effectView.contentView addSubview:visualEffectView];
}

#pragma mark - 对view添加手势

-(void)addGesture {
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.loginView addGestureRecognizer:tap];
}

-(void)tap {
    
    [self.loginView endEditing:YES];
}

#pragma mark - 按钮事件监听

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)Register:(UIButton *)sender {
    
    WSIRegisterViewController *registerVc = [[WSIRegisterViewController alloc]initWithNibName:@"WSIRegisterViewController" bundle:[NSBundle mainBundle]];
    
    [self presentViewController:registerVc animated:YES completion:nil];
}


- (IBAction)loginButton:(id)sender {
    
    [BmobUser loginInbackgroundWithAccount:self.usernameTF.text andPassword:self.passWordTF.text block:^(BmobUser *user, NSError *error) {
        
        if (error) {
            
            NSLog(@"登录出错---%@",error);
            
            [HUDUtils setupErrorWithStatus:@"登录失败" WithDelay:1.8f completion:nil];
        }else {
        
            NSLog(@"登录成功---%@",user);
            
            [HUDUtils setupSuccessWithStatus:@"登录成功" WithDelay:1.8f completion:^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        
    }];
}


- (IBAction)forgotButton:(id)sender {
    
    
}



@end
