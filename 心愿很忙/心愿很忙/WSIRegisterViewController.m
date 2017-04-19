//
//  WSIRegisterViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/8.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIRegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import <SVProgressHUD.h>
#import "HUDUtils.h"

@interface WSIRegisterViewController ()
/**注册按钮*/
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
/**注册视图*/
@property (weak, nonatomic) IBOutlet UIView *registerView;
/**背景图*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**输入用户名*/
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
/**输入密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
/**输入验证码*/
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
/**验证码*/
@property (nonatomic,assign) NSInteger smsCode;

@end

@implementation WSIRegisterViewController

#pragma mark - 初始化操作
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConerRadius];
    [self setupImageView];
    [self addGesture];
}

-(void)setupConerRadius {

    [self.registerView.layer setCornerRadius:4.0f];
    
    [self.registerButton.layer setCornerRadius:3.0f];
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
    [self.registerView addGestureRecognizer:tap];
}

-(void)tap {

    [self.registerView endEditing:YES];

}

#pragma mark - 正则表达式注册判断

/**手机号判断*/
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13,14,15,18,17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-345-9]|7[013678])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**判断邮箱是否正确*/
- (BOOL) validateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - 监听按钮事件

- (IBAction)closeButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送验证码
- (IBAction)codeButton:(id)sender {
    
    [self.registerView endEditing:YES];
    
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.userNameTF.text andTemplate:@"test" resultBlock:^(int number, NSError *error) {
        
        if (error) {
            
            NSLog(@"获取验证码失败.%@",error);
            
            [HUDUtils setupErrorWithStatus:@"验证码发送失败" WithDelay:2.0f completion:nil];
            
        } else {
            //获得smsID
            NSLog(@"验证码已发送.sms ID：%d",number);
            
            [HUDUtils setupSuccessWithStatus:@"验证码已发送" WithDelay:2.0f completion:nil];
        }
        
    }];
}


- (IBAction)registerButton:(id)sender {
    
    [self.registerView endEditing:YES];
    
    if ([self validateMobile:self.userNameTF.text]) {//用户输入为手机号
        
        BmobUser *buser = [[BmobUser alloc] init];
        buser.mobilePhoneNumber = self.userNameTF.text;
        buser.password = self.passwordTF.text;
        
        [buser signUpOrLoginInbackgroundWithSMSCode:self.codeTF.text block:^(BOOL isSuccessful, NSError *error) {
            
            if (error) {
                
                [HUDUtils setupErrorWithStatus:@"注册失败" WithDelay:1.5f completion:nil];
                
            } else {
          
                [HUDUtils setupSuccessWithStatus:@"注册成功" WithDelay:1.5f completion:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    
    }else if([self validateEmail:self.userNameTF.text]){//用户输入的为邮箱
        
        BmobUser *bUser = [[BmobUser alloc] init];
        [bUser setUsername:self.userNameTF.text];
        [bUser setEmail:self.userNameTF.text];
        [bUser setPassword:self.passwordTF.text];

        [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
            
            if (isSuccessful){
                
                NSLog(@"邮件发送成功");
                
                [HUDUtils setupSuccessWithStatus:@"邮件已发送" WithDelay:1.5f completion:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                     [self dismissViewControllerAnimated:YES completion:nil];
                });;
               
                
                BmobUser *user = [BmobUser currentUser];
                //应用开启了邮箱验证功能
                if ([user objectForKey:@"emailVerified"]) {
                    //用户没验证过邮箱
                    if (![[user objectForKey:@"emailVerified"] boolValue]) {
                        [user verifyEmailInBackgroundWithEmailAddress:self.userNameTF.text];
                        
                    }
                    
                }
                
            } else {
                NSLog(@"邮件发送失败--%@",error);
                
                [HUDUtils setupErrorWithStatus:@"邮件发送失败" WithDelay:1.5f completion:nil];
            }
        }];
        
        
    }else {//用户输入的为用户名
    
        BmobUser *bUser = [[BmobUser alloc] init];
        [bUser setUsername:self.userNameTF.text];
        [bUser setPassword:self.passwordTF.text];
        
        [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        
            if (isSuccessful) {
                
                NSLog(@"用户名注册成功");
                [HUDUtils setupSuccessWithStatus:@"注册成功" WithDelay:1.5f completion:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                
            }else {
            
                NSLog(@"用户名注册失败--%@",error);
                [HUDUtils setupErrorWithStatus:@"注册失败" WithDelay:1.5f completion:nil];
            }
            
        }];
        
    }
    
}





         
         
         
         
         
         
         
         

@end
