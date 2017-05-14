//
//  AppDelegate.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/6.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "AppDelegate.h"
#import "WSIMeViewController.h"
#import "WSIHomeTableViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "REFrostedViewController.h"
#import <Masonry.h>
#import "WSIChattingViewController.h"
#import "WSIHomePageViewController.h"

@interface AppDelegate ()<RCIMUserInfoDataSource>
@property(nonatomic,strong)REFrostedViewController *frostedViewController;
@property(nonatomic, weak) id<RCIMReceiveMessageDelegate> receiveMessageDelegate;
@property(nonatomic,strong)NSString *nickName;
@end

@implementation AppDelegate
static NSString *notiName = @"passUser";
static NSString *dbName = @"list_Info.sqlite";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupWindow];
    
    [self setupBmob];
 
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    [self setupUshare];
    
    [self setupRongyun];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passUser:) name:notiName object:nil];
    
    return YES;
}

-(void)passUser:(NSNotification*)notification {

    WishModel *model = notification.object;
    
    BmobQuery *q = [BmobQuery queryWithClassName:@"_User"];
    
    [q getObjectInBackgroundWithId:model.user.objectId block:^(BmobObject *object, NSError *error) {
        
        _nickName = [object objectForKey:@"nickName"];
        
    }];
}

-(void)setupRongyun {
    
    BmobUser *user = [BmobUser currentUser];
    
    NSString *token = [user objectForKey:@"token"];

    [[RCIM sharedRCIM] initWithAppKey:@"8luwapkv8txcl"];
    
    [[RCIM sharedRCIM] connectWithToken: token success:^(NSString *userId) {
        
        NSLog(@"融云链接成功");
        
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        
    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"融云链接失败---%ld",(long)(long)status);
        
    } tokenIncorrect:^{
        
        NSLog(@"tokenIncorrect");
    }];
    
    
}


-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {

    RCUserInfo *info = [[RCUserInfo alloc]init];
    
    //1.获得数据库文件的路径
    NSString *fmdbPath = DocumentPath;
    
    NSString *fileName = [fmdbPath stringByAppendingPathComponent: dbName];
    
    NSLog(@"path:  %@", fileName);
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    if ([db open]) {
        
        NSLog(@"数据库已打开");
        
        //根据条件查询
        FMResultSet *resultSet = [db executeQuery:@"select * from list_Info where userId=?;",userId];
        
        while ([resultSet next]) {
            
            info.userId = userId;
            info.name = [resultSet stringForColumn:@"name"];
            info.portraitUri = [resultSet stringForColumn:@"headUrl"];
            
            NSLog(@"userId: %@ name: %@ protraitUri: %@", info.userId,info.name,info.portraitUri);
        }
        
    }else {
    
        NSLog(@"数据库未打开");
    }

    return completion(info);
}


/**
 *  初始化ALiSDK
 */

-(void)setupUshare {

    
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58fb6970cae7e733260006b5"];
    
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106117908 "/*设置QQ平台的appID*/  appSecret:@"kjoalSooWXzsIMrt" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"761373709"  appSecret:@"702d6b78b83c5fdf64e4a53548e4306b" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

}


/**
 *  支持所有iOS系统
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


/**
 *  初始化AV
 */

-(void)setupBmob {

    [Bmob registerWithAppKey:@"1b06e7519038aac91f3ec8f8437034c9"];
   
}



/**
 *  初始化window
 */

-(void)setupWindow {

    WSIMeViewController *meVc = [[WSIMeViewController alloc]initWithNibName:@"WSIMeViewController" bundle:[NSBundle mainBundle]];
    
    UITabBarController *tabBarVc = [UITabBarController new];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    WSIHomeTableViewController *mainVc = [WSIHomeTableViewController new];
    UINavigationController *navi1 = [[UINavigationController alloc]initWithRootViewController:mainVc];
    mainVc.tabBarItem.image = [UIImage loadImageWithImgName:@"星球 (7)"];
    mainVc.tabBarItem.selectedImage = [UIImage loadImageWithImgName:@"星球 (8)"];
    mainVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    WSIChattingViewController *chatVc  = [WSIChattingViewController new];
    UINavigationController *navi2 = [[UINavigationController alloc]initWithRootViewController:chatVc];
    chatVc.tabBarItem.image = [UIImage loadImageWithImgName:@"hi 聊天"];
    chatVc.tabBarItem.selectedImage = [UIImage loadImageWithImgName:@"hi 聊天 (1)"];
    chatVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    WSIHomePageViewController *homeVc = [WSIHomePageViewController new];
    UINavigationController *navi3 = [[UINavigationController alloc]initWithRootViewController:homeVc];
    homeVc.tabBarItem.image = [UIImage loadImageWithImgName:@"笑脸 (13)"];
    homeVc.tabBarItem.selectedImage = [UIImage loadImageWithImgName:@"笑脸 (14)"];
    homeVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    [tabBarVc addChildViewController:navi1];
    [tabBarVc addChildViewController:navi2];
    [tabBarVc addChildViewController:navi3];
    

    _frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:tabBarVc menuViewController:meVc];
    
    _frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    _frostedViewController.panGestureEnabled = YES;
    _frostedViewController.limitMenuViewSize = YES;
    _frostedViewController.menuViewSize = CGSizeMake(meVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);

//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognized:)];
//    [self.frostedViewController.view addGestureRecognizer:pan];
    
    //注册通知 按钮点击时推出侧边栏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menu) name:@"clickButton" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(close) name:@"closeSlider" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeNavi) name:@"removeNavi" object:nil];

 
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = self.frostedViewController;
    
    self.window.backgroundColor = [UIColor colorWithRed:241.0/255 green:242.0/255 blue:244.0/255 alpha:1];
    
    [self.window makeKeyAndVisible];

}

/**
 *  移除通知
 */
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  初始化侧边栏
 */

-(void)menu {
 
    [self.frostedViewController presentMenuViewController];
}

-(void)cilckButton {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPublish" object:nil];
}


/**
 *  通知方法
 */

-(void)close {
    
    [self.frostedViewController hideMenuViewController];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
}

-(void)removeButton {
 
        _publishButton.hidden = YES;

}

-(void)showButton {

        _publishButton.hidden = NO;
  
}


-(void)removeNavi {}

@end
