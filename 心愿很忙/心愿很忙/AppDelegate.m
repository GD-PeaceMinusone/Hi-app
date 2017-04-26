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
#import <BmobSDK/Bmob.h>
#import <UMSocialCore/UMSocialCore.h>
#import "REFrostedViewController.h"
#import "JCNavigationController.h"
@interface AppDelegate ()
@property(nonatomic,strong)REFrostedViewController *frostedViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupWindow];
    
    [self setupBmob];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    [self setupUshare];
    return YES;
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
 *  初始化Bmob
 */

-(void)setupBmob {

    [Bmob registerWithAppKey:@"1b06e7519038aac91f3ec8f8437034c9"];
}

/**
 *  初始化window
 */

-(void)setupWindow {

    WSIMeViewController *meVc = [[WSIMeViewController alloc]initWithNibName:@"WSIMeViewController" bundle:[NSBundle mainBundle]];
    
    WSIHomeTableViewController *mainVc = [WSIHomeTableViewController new];
    
    UINavigationController *navigationVc = [[UINavigationController alloc]initWithRootViewController:mainVc];

    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
    UITabBarController * tabbarVc = [[UITabBarController alloc]init];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
   
    [tabbarVc addChildViewController:navigationVc];
    
    self.frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:tabbarVc menuViewController:meVc];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    self.frostedViewController.panGestureEnabled = YES;
    self.frostedViewController.limitMenuViewSize = YES;
    self.frostedViewController.menuViewSize = CGSizeMake(meVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.frostedViewController.view addGestureRecognizer:pan];
    
    //注册通知 按钮点击时推出侧边栏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menu) name:@"clickButton" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(close) name:@"closeSlider" object:nil];
    
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
//
    
    
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"____"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
