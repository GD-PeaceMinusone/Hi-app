//
//  WSIMeDetailViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/21.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIMeDetailViewController.h"
#import "WSIPerosonalViewController.h"
#import <REFrostedViewController.h>
#import <UIImageView+WebCache.h>
#import "SCAvatarBrowser.h"
#import "WSILoginViewController.h"
#import "WSIChatViewController.h"
#import "AXWireButton.h"
#import "WSIChattingViewController.h"
#import "WSIHomeTableViewController.h"
#import "WSICommentViewController.h"

@interface WSIMeDetailViewController () 
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property(nonatomic,strong)WSIChatViewController *chatVc;
@property(nonatomic,strong)JCAlertController *alertVc;
@property (weak, nonatomic) IBOutlet AXWireButton *chatBt;

@end

@implementation WSIMeDetailViewController
static NSString *notiName = @"hiddenPop";
static NSString *notiName2 = @"passUser";
static NSString *dbName = @"list_Info.sqlite";

-(JCAlertController *)alertVc {
    
    if (!_alertVc) {
        
        _alertVc = [JCAlertController alertWithTitle:@"提示" message:@"聊天功能开启失败 将在下次应用开启时自动进行处理" type:JCAlertTypeNormal];
        
        [_alertVc addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:nil];
        
    }
    
    return _alertVc;
}

-(WSIChatViewController *)chatVc {
    
    if (!_chatVc) {
        
        _chatVc = [[WSIChatViewController alloc]init];
        
        [_chatVc setConversationType:ConversationType_PRIVATE];
        
        BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
        
        [query getObjectInBackgroundWithId:_model.user.objectId block:^(BmobObject *object, NSError *error) {
            
            [_chatVc setTitle:[object objectForKey:@"nickName"]];
            
            [_chatVc setTargetId:[object objectForKey:@"userId"]];

            
        }];
        
        
    }
    
    return _chatVc;
}



- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"许愿人";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
        self.contentSizeInPopup = CGSizeMake(300, 300);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
 
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeaderIv];
    [self.popView.layer setCornerRadius:4.0f];
    [self.headerIv circleHeader:self.headerIv withBorderWidth:0 andBorderColor:nil];
    

    if ([[BmobUser currentUser].objectId isEqualToString:_model.user.objectId]) {
        
        _chatBt.hidden = YES;
    }

}


-(void)setModel:(WishModel *)model {

    _model = model;
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:model.user.objectId block:^(BmobObject *object, NSError *error) {
        
        NSString *head = [object objectForKey:@"userHeader"];

        [_headerIv sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
        
        [_nickLabel setText:[object objectForKey:@"nickName"]];
        
    }];

}

-(void)setComModel:(commentModel *)comModel {

    _comModel = comModel;
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:comModel.user.objectId block:^(BmobObject *object, NSError *error) {
        
        NSString *head = [object objectForKey:@"userHeader"];
        
        [_headerIv sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
        
        [_nickLabel setText:[object objectForKey:@"nickName"]];
        
    }];
}

-(void)setupHeaderIv {
    
    [_headerIv circleHeader:_headerIv withBorderWidth:1.5f andBorderColor:[UIColor whiteColor]];
    _headerIv.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkHead)];
    [_headerIv addGestureRecognizer:tap];
}

-(void)checkHead {
    
    [SCAvatarBrowser showImageView:_headerIv];
    
}


- (IBAction)chatBt:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:nil];

    //如果当前没有用户 调到登录界面
    
    if ([BmobUser currentUser] == nil) {
        
        WSILoginViewController *loginVc = [WSILoginViewController new];
        
        REFrostedViewController *vc = (REFrostedViewController*) [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [vc presentViewController:loginVc animated:YES completion:nil];
        
        
        
    }else if([[BmobUser currentUser]objectForKey:@"isToken"]) { //如果当前用户聊天功能没开通 进行弹框提示
        
        REFrostedViewController *vc = (REFrostedViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        UITabBarController *tabBarVc =(UITabBarController*)vc.contentViewController;
        
        
        [tabBarVc jc_presentViewController:self.alertVc presentType:JCPresentTypeLIFO presentCompletion:nil dismissCompletion:nil];
        
    } else {
   
        [[UINavigationController getNavi] pushViewController:self.chatVc animated:YES];
     
        /** 给某人发消息时 将消息人数据存入数据库 以便融云会话列表加载*/
        
        BmobQuery *q = [BmobQuery queryWithClassName:@"_User"];
        
        [q getObjectInBackgroundWithId:_model.user.objectId block:^(BmobObject *object, NSError *error) {
            
            NSString *userId = [object objectForKey:@"userId"];
            NSString *name = [object objectForKey:@"nickName"];
            NSString *headUrl = [object objectForKey:@"userHeader"];
            
            
            //1.获得数据库文件的路径
            NSString *fmdbPath = DocumentPath;
            
            NSString *fileName = [fmdbPath stringByAppendingPathComponent: dbName];
            
            NSLog(@"path:  %@", fileName);
            
            //2.获得数据库
            FMDatabase *db = [FMDatabase databaseWithPath:fileName];
            
            if ([db open]) {
                
                //4.创表
                BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS list_Info (id integer PRIMARY KEY,userId text,name text, headUrl text);"];
                
                if (result)
                {
                    NSLog(@"创建表成功");
                    
                    [db executeUpdate:@"INSERT INTO list_Info (userId,name,headUrl) VALUES (?,?,?);",userId,name,headUrl];
                    
                    //查询整个表
                    FMResultSet *resultSet = [db executeQuery:@"select * from list_Info;"];
                    
                    NSLog(@"---%@---", resultSet);
                    
                    [db close];
                    
                }else {
                
                    NSLog(@"创建表失败");
                }
            }
            
            
        }];
    }
    
    
}




/**
 *  推出个人详情页面
 */

-(void)nextBtnDidTap {
   
    WSIPerosonalViewController *personal = [WSIPerosonalViewController new];
    
    REFrostedViewController *vc = (REFrostedViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UITabBarController *tabBarVc =(UITabBarController*)vc.contentViewController;
    
    UINavigationController *navi =  (UINavigationController*) tabBarVc.selectedViewController;

    /** 判断navi的顶部控制器 分别用不同的navi进行push */
    
    if ([navi.topViewController isKindOfClass:[WSIHomeTableViewController class]]) {
        
         [[UIViewController getNavi]  pushViewController:personal animated:YES];
        
    } else {
    
         [[UIViewController getNaviLast]  pushViewController:personal animated:YES];
    }

   
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
