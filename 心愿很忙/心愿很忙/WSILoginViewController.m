//
//  WSILoginViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/8.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSILoginViewController.h"
#import "WSIRegisterViewController.h"
#import "WSICodeViewController.h"
#import <BmobSDK/Bmob.h>
#import <Masonry.h>
#import "HUDUtils.h"

@interface WSILoginViewController ()
/**登录按钮*/
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *smsCode;
/**vc*/
@property(nonatomic,strong)WSIRegisterViewController *registerVc;
/**vc*/
@property(nonatomic,strong)WSICodeViewController *codeVc;
@end

@implementation WSILoginViewController

#pragma mark - 一些初始化操作

-(WSIRegisterViewController *)registerVc {
    
    if (_registerVc) {
        
        _registerVc = [[WSIRegisterViewController alloc]initWithNibName:NSStringFromClass([WSIRegisterViewController class]) bundle:[NSBundle mainBundle]];
        
    }
    
    return _registerVc;
    
}

-(WSICodeViewController *)codeVc {

    if (!_codeVc) {
        
        _codeVc = [[WSICodeViewController alloc]initWithNibName:NSStringFromClass([WSICodeViewController class]) bundle:[NSBundle mainBundle]];
        
    }
    
    return _codeVc;
}

- (void)viewDidLoad {
    
    [self setupTF];
    [self setupConerRadius];
}

-(void)setupConerRadius {

   
    [self.loginButton.layer setCornerRadius:3.0f];
    
}

/**设置输入框的头像*/

-(void)setupTF {
    
    UIImageView *imageIv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"手机号"]];
    imageIv.frame = CGRectMake(0, 0, 29, 29);
    _numberTF.leftView = imageIv;
    _numberTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageIv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"信息"]];
    imageIv2.frame = CGRectMake(0, 0, 29, 29);
    _smsCode.leftView = imageIv2;
    _smsCode.leftViewMode = UITextFieldViewModeAlways;
 
}


#pragma mark - 按钮事件监听

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)Register:(UIButton *)sender {
    
    _registerVc = [[WSIRegisterViewController alloc]initWithNibName:NSStringFromClass([WSIRegisterViewController class]) bundle:[NSBundle mainBundle]];
    [self presentViewController:self.registerVc animated:YES completion:nil];
    
}


- (IBAction)userPw:(id)sender {
    
    [self presentViewController:self.codeVc animated:YES completion:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}


- (IBAction)loginButton:(id)sender {
    
    [self.view endEditing:YES];
    
    [AVUser logInWithMobilePhoneNumberInBackground:_numberTF.text smsCode:_smsCode.text block:^(AVUser *user, NSError *error) {
        
        if (error) {
            
            NSLog(@"登录失败---%@", error);
            
            [HUDUtils setupErrorWithStatus:@"登录失败" WithDelay:1.5f completion:nil];
            
        }else {
        
            NSLog(@"登录成功");
            
            [HUDUtils setupSuccessWithStatus:@"登录成功" WithDelay:1.5f completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
        
    }];
   
}


- (IBAction)getCode:(id)sender {
    
    [AVUser requestLoginSmsCode:_numberTF.text withBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            NSLog(@"验证码发送成功");
            [HUDUtils setupSuccessWithStatus:@"验证码已发送" WithDelay:1.8f completion:nil];
            
        }else {
        
            NSLog(@"验证码发送失败---%@", error);
            [HUDUtils setupErrorWithStatus:@"验证码发送失败" WithDelay:1.8f completion:nil];
        }
        
    }];
}
@end
