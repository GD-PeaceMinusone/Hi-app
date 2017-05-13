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
#import "STPopupController.h"
#import "AFNetworking.h"
#import<CommonCrypto/CommonDigest.h>

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

@property(nonatomic,strong)BmobUser *bUser;

@property(nonatomic,strong)NSString *userId;

@property(nonatomic,strong)NSString *userName;
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
    
    
    [BmobUser loginInbackgroundWithAccount:_usernameTF.text andPassword:_passwdTF.text block:^(BmobUser *user, NSError *error) {
        
        if (user != nil) {
            
            NSLog(@"登录成功");
            
            _bUser = user;
            
            [HUDUtils setupSuccessWithStatus:@"登录成功" WithDelay:1.5f completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissToRootViewController];
                
            });
            
            
            BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
            
            [query getObjectInBackgroundWithId:user.objectId block:^(BmobObject *object, NSError *error) {
                
                [[RCIM sharedRCIM] connectWithToken:[object objectForKey:@"token"]
                 
                                            success:^(NSString *userId) {
                    
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                    
                } error:^(RCConnectErrorCode status) {
                    
                    NSLog(@"登陆的错误码为:%ld", status);
                    
                } tokenIncorrect:^{
                    //token过期或者不正确。
                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                    NSLog(@"token错误");

                    [self getToken]; //token错误 再次请求服务器重新获取token 并尝试连接
                    
                    
                }];
                
            }];
            
  
            
        } else {
            
            NSLog(@"登录失败---%@", error);
            
            [HUDUtils setupErrorWithStatus:@"登录失败" WithDelay:1.5f completion:nil];
        }
        
    }];
    
    
}


/** 获取融云token */

- (void)getToken {
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:_bUser.objectId block:^(BmobObject *object, NSError *error) {
        
        
       _userId = [object objectForKey:@"userId"];
       _userName = [object objectForKey:@"userId"];;
        
    }];
   
    
    [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:_userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *params = @{@"userId":_userId, @"name":_userName, @"protraitUrl":@""};
    
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
