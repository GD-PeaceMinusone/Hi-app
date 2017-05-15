//
//  WSIRegisterViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/8.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIRegisterViewController.h"
#import <SVProgressHUD.h>
#import "HUDUtils.h"
#import "AFNetworking.h"
#import<CommonCrypto/CommonDigest.h>

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
/**邮箱*/
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
/**用户*/
@property(nonatomic,strong)BmobUser *bUser;
@end

@implementation WSIRegisterViewController

#pragma mark - 初始化操作
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConerRadius];
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
    
    UIImageView *imageIv3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"邮箱 (2)"]];
    imageIv3.frame = CGRectMake(0, 0, 29, 29);
    _emailTF.leftView = imageIv3;
    _emailTF.leftViewMode = UITextFieldViewModeAlways;
    
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
    
    if (_emailTF.text == nil) {
        
        [HUDUtils setupInfoWithStatus:@"请输入邮箱" WithDelay:1.5f completion:nil];
    }
    
    if([self validateEmail:_userNameTF.text]){//用户输入的为邮箱
     
     [HUDUtils setupInfoWithStatus:@"请输入用户名或手机号" WithDelay:1.5f completion:nil];
        
}else {
        
    
    _bUser = [[BmobUser alloc] init];
    
    [_bUser setUsername:_userNameTF.text]; // 设置用户名
    
    [_bUser setPassword:_codeTF.text]; // 设置密码
    
    [_bUser setEmail:_emailTF.text]; // 设置邮箱
    
    [_bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        
        if (isSuccessful) {
            
            NSLog(@"注册成功");
            
            [HUDUtils setupSuccessWithStatus:@"注册成功" WithDelay:1.5f completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
            [self getToken];
            
        } else {
            
            NSLog(@"注册失败---%@", error);
            
            [HUDUtils setupErrorWithStatus:@"注册失败" WithDelay:1.5f completion:nil];
        }
    }];
    

    }
   
}

/** 获取融云token */

- (void)getToken {
    
    NSString *userId = _userNameTF.text;
    NSString *userName = _userNameTF.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *params = @{@"userId":userId, @"name":userName, @"protraitUrl":@""};
 
    NSString *url = @"http://api.cn.ronghub.com/user/getToken.json";
    
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];  // 创建请求管理者
    
    NSString *nonce = [NSString stringWithFormat:@"%d", rand()];
    NSString *appKey = @"8luwapkv8txcl";
    NSString *appsecret = @"P8JFN2VmfC";
    long timestamp = (long)[[NSDate date] timeIntervalSince1970];
    
    NSString *unionString = [NSString stringWithFormat:@"%@%@%ld", appsecret, nonce, timestamp];
    const char *cstr = [unionString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:unionString.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
#ifdef ContentType
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
    
#endif
    
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    
    NSString *timestampStr = [NSString stringWithFormat:@"%ld", timestamp];
    [mgr.requestSerializer setValue:appKey forHTTPHeaderField:@"App-Key"];
    [mgr.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [mgr.requestSerializer setValue:timestampStr forHTTPHeaderField:@"Timestamp"];
    [mgr.requestSerializer setValue:output forHTTPHeaderField:@"Signature"];
   
    
    [mgr POST:url parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"成功获取token---%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        
        if (code.intValue == 200) {
            NSString *token = responseObject[@"token"];
            NSString *userId = responseObject[@"userId"];

            [_bUser setObject:token forKey:@"token"];
            [_bUser setObject:userId forKey:@"userId"];
            
            [_bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (isSuccessful) {
                    
                    NSLog(@"保存token成功");
                    
                }else {
                    
                    NSLog(@"保存token失败---%@", error);
                }
                
            }];
            
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取token失败---%@", error);
    }];
    
    
}



@end
