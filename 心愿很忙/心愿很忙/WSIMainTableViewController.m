//
//  ViewController.m
//  CCFoldCellDemo
//
//  Created by eHome on 17/2/23.
//  Copyright © 2017年 Bref. All rights reserved.
//

#import "WSIMainTableViewController.h"
#import "WSILoginViewController.h"
#import "WSIMeViewController.h"
#import "CodeViewController.h"
#import <AFNetworking.h>
#import "WSIRefreshHeader.h"
#import "WSIRefreshFooter.h"
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"
#import "DemoCell.h"
#import "HUDUtils.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "ListObject.h"
#import "HomeTableViewCell.h"

@interface WSIMainTableViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *cellHeights;

@property(nonatomic,strong)NSArray *itObjs;

@end

@implementation WSIMainTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self createCellHeightsArray];
    [self setupNavigationBar];
    [self networkStatus];
    [self setupRefresh];
    
    NSLog(@"viewdidload");

}


/**设置刷新操作*/
-(void)setupRefresh {
    
    self.tableView.mj_header = [WSIRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [WSIRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}


#pragma mark - 数据加载

-(void)loadNewTopics {
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"ListObject"];
    
    query.limit = 10;
    
    [query orderByDescending:@"createdAt"];
    
        
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            self.itObjs = [ListObject ListObjcetArrayFromBmobObjectArray:array];
//            [self.tableView reloadData];
        
        
        }];
        

    //把数据保存
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.itObjs];
    
    [data writeToFile:kITObjsPath atomically:YES];
    
}


-(void)loadMoreTopics {
    
    
}



#pragma mark - Getter && Setter


- (NSMutableArray<NSNumber *> *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray array];
    }
    return _cellHeights;
}



//初始化SDK相关接口

-(void)setupAliSDK {


    [[AlibcTradeSDK sharedInstance]asyncInitWithSuccess:^{
        
        NSLog(@"----初始化成功----");
    } failure:^(NSError *error) {
        
        NSLog(@"----初始化失败----");
    }];
    
    
    id<AlibcTradePage> page = [AlibcTradePageFactory page: @"http://c.b6wq.com/h.UiY8Lg?cv=tNeaZt7PCTk&sm=df7021"];
    
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeAuto;
    
    AlibcTradeTaokeParams *taoke = [AlibcTradeTaokeParams new];
    taoke.pid = nil;

    [[AlibcTradeSDK sharedInstance].tradeService show:self page:page showParams:showParam taoKeParams:taoke trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        
        
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        
        
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    /* 老接口写法 已弃用，建议使用新接口
     if (![[AlibcTradeSDK sharedInstance] handleOpenURL:url]) {
     // 处理其他app跳转到自己的app
     }
     return YES;
     */
    
    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    /* 老接口写法 已弃用，建议使用新接口
     if (![[AlibcTradeSDK sharedInstance] handleOpenURL:url]) {
     // 处理其他app跳转到自己的app
     }
     return YES;
     */
    
    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                             options:options]) {
        //处理其他app跳转到自己的app，如果百川处理过会返回YES
    }
    return YES;
}

//判断网络状态
-(void)networkStatus {

    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                [HUDUtils setupInfoWithStatus:@"网络似乎有点问题" WithDelay:1.5f completion:nil];
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                
                [HUDUtils setupErrorWithStatus:@"网络未连接" WithDelay:1.5f completion:nil];
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                
                break;
                
            default:
                break;
        }
        
    }];
    
    [manager startMonitoring];
}

//设置导航栏样式
-(void)setupNavigationBar {
    
    UIImage *image = [UIImage imageNamed:@"头像"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage: image style:UIBarButtonItemStylePlain target:self action:@selector(goMe)];
    
    [self.navigationController.navigationBar.subviews firstObject].hidden = YES;
}

-(void)setupPublishButton {
    
    UIButton *publishButton = [UIButton new];
    [publishButton setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
    
    CGFloat buttonW = 75;
    CGFloat buttonH = 40;
    CGFloat buttonX = (self.view.xmg_width - buttonW)*0.5;
    CGFloat buttonY = self.view.xmg_height - WSIMargin - buttonH;
    
    publishButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [publishButton addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:publishButton];
}


//设置发布按钮
-(void)publish: (UIButton*)button {
    
    if ([BmobUser currentUser]) {
        
        CodeViewController *codeVc = [CodeViewController new];
        [self presentViewController:codeVc animated:YES completion:nil];
        
    }else {
        
        WSILoginViewController *loginVc = [WSILoginViewController new];
        [self presentViewController:loginVc animated:YES completion:nil];
        
    }
    
    //    WSILoginViewController *loginVc = [WSILoginViewController new];
    //    [self presentViewController:loginVc animated:YES completion:nil];
    
}

//监听按钮响应
-(void)goMe {
    
    [ShareApp.drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}


- (void)createCellHeightsArray
{
    for (int i = 0; i < kRowsCount; i ++) {
        [self.cellHeights addObject:@(kCloseCellHeight)];
    }
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.itObjs.count;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(DemoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willdisplaycell");
    
    if (![cell isKindOfClass:[DemoCell class]]) return;
    
    cell.backgroundColor = [UIColor clearColor];
    
    CGFloat cellHeight = self.cellHeights[indexPath.row].floatValue;
    
    if (cellHeight == kCloseCellHeight) {
        
        [cell selectedAnimationByIsSelected:NO animated:NO completion:nil];
        
    }else{
        
        [cell selectedAnimationByIsSelected:YES animated:NO completion:nil];
    }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrowatindexpath");
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell" forIndexPath:indexPath];
    
    ListObject *obj = self.itObjs[indexPath.row];
    
    cell.itObj = obj;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeights[indexPath.row].floatValue;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell isKindOfClass:[DemoCell class]]) return;
    
    if (cell.isAnimating) return;
    
    NSTimeInterval duration = 0.f;
    
    CGFloat cellHeight = self.cellHeights[indexPath.row].floatValue;
    
    if (cellHeight == kCloseCellHeight) {
        self.cellHeights[indexPath.row] = @(kOpenCellHeight);
        [cell selectedAnimationByIsSelected:YES animated:YES completion:nil];
        duration = 1.f;
    }else
    {
        self.cellHeights[indexPath.row] = @(kCloseCellHeight);
        [cell selectedAnimationByIsSelected:NO animated:YES completion:nil];
        duration = 1.f;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [tableView beginUpdates];
        [tableView endUpdates];
    } completion:nil];
    
}

@end
