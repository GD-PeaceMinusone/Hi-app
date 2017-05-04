//
//  WSIHomeTableViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/21.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIHomeTableViewController.h"
#import "WSILoginViewController.h"
#import "WSIMeViewController.h"
#import <AFNetworking.h>
#import "WSIRefreshHeader.h"
#import "WSIRefreshFooter.h"
#import "HUDUtils.h"
#import "HomeTableViewCell.h"
#import "CodeViewController.h"
#import "AppDelegate.h"
#import "MJRefreshGifHeader+HeaderRefresh.h"
#import "UIScrollView+Refresh.h"
#import <AVOSCloud/AVOSCloud.h>
#import "STPopupController.h"
#import "WSIMeDetailViewController.h"
#import "WSICommentViewController.h"

@interface WSIHomeTableViewController ()
/**数据数组*/
@property(nonatomic,strong)NSMutableArray *itObjs;
/** window */
@property (nonatomic, strong) UIWindow *window;
/**数据数组*/
@property(nonatomic,strong)NSMutableArray *moreItobjs;

@property(nonatomic,strong) STPopupController *popupController;

@property (nonatomic,assign)NSInteger cellHeight;
@property(nonatomic,strong)NSString *thingPath;
@property(nonatomic,strong)NSString *thingContent;
@end

@implementation WSIHomeTableViewController
static NSString *notiName = @"pushVc";
static NSString *notiName2 = @"comment";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self networkStatus];
    [self registerCell];
    [self setupRefresh];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVc:) name:notiName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVc2:) name:notiName2 object:nil];
}

-(void)pushVc: (NSNotification*)noti {//接受传过来的Vc 通过tag给对应vc赋值
    
    NSInteger index = [noti.object[0] integerValue];
    WSIMeDetailViewController *detailVc = noti.object[1];
    detailVc.model = self.moreItobjs[index];
}

-(void)pushVc2: (NSNotification*)noti {//接受传过来的Vc 通过tag给对应vc赋值
    
    NSInteger index = [noti.object[0] integerValue];
    WSICommentViewController *commentVc = noti.object[1];
    commentVc.avObj = self.moreItobjs[index];
}

-(void)viewDidAppear:(BOOL)animated{//显示tabbar
    
    self.tabBarController.tabBar.hidden = NO;
   
}

-(void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showButton" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {//隐藏tabbar
   
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

/**
 *  懒加载
 */

-(NSMutableArray *)itObjs {

    if (!_itObjs) {
        
        _itObjs = [NSMutableArray array];
    }
    
    return _itObjs;
}

/**
 *  注册cell
 */
-(void)registerCell {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"HomeCell"];
}


/**
 *  设置刷新操作
 */
-(void)setupRefresh {
    
    WSIWeakSelf
    [self.tableView addHeaderRefresh:^{
        [weakSelf loadNewTopics];
    }];
    
    [weakSelf.tableView beginHeaderRefresh];
    
    [self.tableView addFooterRefresh:^{
        [weakSelf loadMoreTopics];
    }];
}


/**
 *  设置导航栏样式
 */
-(void)setupNavigationBar {
    
    UIImage *image1 = [UIImage imageNamed:@"列表 "];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *image2 = [UIImage imageNamed:@"发表"];
    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage: image1 style:UIBarButtonItemStylePlain target:self action:@selector(goMe)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage: image2 style:UIBarButtonItemStylePlain target:self action:@selector(publish:)];

    [self.navigationController.navigationBar.subviews firstObject].hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publish:) name:@"showPublish" object:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255 green:242/255.0 blue:245/255.0 alpha:1.0f]];
}


/**
 *  设置发布按钮
 */
-(void)publish: (UIButton*)button {
    
    
    if ([AVUser currentUser]) {
        
        CodeViewController *codeVc = [CodeViewController new];
        [self presentViewController:codeVc animated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideButton" object:nil];
    }else {
        
        WSILoginViewController *loginVc = [WSILoginViewController new];
        [self presentViewController:loginVc animated:YES completion:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideButton" object:nil];
    }
    
}



/**
 *  监听按钮响应
 */
-(void)goMe {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickButton" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideButton" object:nil];
}


#pragma mark - 数据加载

-(void)loadNewTopics {
    
    AVQuery *query = [AVQuery queryWithClassName:@"WishList"];
   
    query.limit = 10;
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        if (error) {
            NSLog(@"----%@---", error);
            
            [HUDUtils setupErrorWithStatus:@"加载失败" WithDelay:1.5f completion:^{
                
                WSIWeakSelf
                [weakSelf.tableView endHeaderRefresh];
                
            }];
        }{
                
            self.itObjs = [[WishModel wishObjectArrayFromAvobjectArrary:objects] mutableCopy];
            [self.tableView reloadData];
            self.moreItobjs = [[WishModel wishObjectArrayFromAvobjectArrary:objects] mutableCopy];
            
            WSIWeakSelf
            [weakSelf.tableView endHeaderRefresh];
            
        }
        
    }];


}


-(void)loadMoreTopics {
    
    AVQuery *query = [AVQuery queryWithClassName:@"WishList"];
    
    query.limit = 10;
    
    WishModel *model = self.moreItobjs[self.moreItobjs.count - 1];
    
    AVObject *obj = model.avObj;
    
    [query whereKey:@"createdAt" lessThan:obj.createdAt];
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            
            [HUDUtils setupErrorWithStatus:@"加载失败" WithDelay:1.5f completion:^{
                
                WSIWeakSelf
                [weakSelf.tableView endFooterRefresh];
                
            }];
        }{
            
            
            [self.itObjs addObjectsFromArray:[WishModel wishObjectArrayFromAvobjectArrary:objects]];
            [self.moreItobjs addObjectsFromArray:[WishModel wishObjectArrayFromAvobjectArrary:objects]];
            [self.tableView reloadData];
            
            WSIWeakSelf
            [weakSelf.tableView endFooterRefresh];
            
        }
        
    }];

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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.itObjs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *homeCell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    homeCell.avObj = self.itObjs[indexPath.row];
    homeCell.headerIv.tag = indexPath.row;
    
    return homeCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    WishModel *model = self.itObjs[indexPath.row];
    return model.cellHeight;

}

/**
 *  设置bar随滚动隐藏和显示
 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:1 animations:^{
        
        self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, 49);
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -49);

    }];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    [UIView animateWithDuration:1 animations:^{
        
        self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, 0);
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, 0);

    }];
}


@end
