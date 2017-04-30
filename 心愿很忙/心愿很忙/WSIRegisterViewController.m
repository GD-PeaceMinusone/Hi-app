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
/**重置密码*/
@property (weak, nonatomic) IBOutlet UIButton *resetBt;
@end

@implementation WSIRegisterViewController

#pragma mark - 初始化操作
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConerRadius];
    [self setupImageView];
    [self setupTF];
}

-(void)setupConerRadius {

    [self.registerView.layer setCornerRadius:4.0f];
    [self.registerButton.layer setCornerRadius:3.0f];
    [self.resetBt.layer setCornerRadius:2.0f];
}

/**设置输入框的头像*/

-(void)setupTF {

    UIImageView *imageIv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"笑脸2"]];
    imageIv.frame = CGRectMake(0, 0, 25, 25);
    _userNameTF.leftView = imageIv;
    _userNameTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageIv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码"]];
    imageIv2.frame = CGRectMake(0, 0, 29, 29);
    _codeTF.leftView = imageIv2;
    _codeTF.leftViewMode = UITextFieldViewModeAlways;
  
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

#pragma mark - 收起键盘

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
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



- (IBAction)registerButton:(id)sender {
    
    [self.registerView endEditing:YES];
    
 if([self validateEmail:self.userNameTF.text]){//用户输入的为邮箱
     
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
       
        
    }else {
    

    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    [user setUsername:_userNameTF.text];// 设置用户名
    [user setPassword:_codeTF.text];// 设置密码
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            NSLog(@"注册成功");
            
            [HUDUtils setupSuccessWithStatus:@"注册成功" WithDelay:1.5f completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
        } else {
            
            NSLog(@"注册失败");
            
            [HUDUtils setupErrorWithStatus:@"用户名或手机号已被注册" WithDelay:1.5f completion:nil];
        }
        
         }];
    }
}




         
         
         
         
         
         
         
         

@end
