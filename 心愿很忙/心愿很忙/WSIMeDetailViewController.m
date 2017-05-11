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

@interface WSIMeDetailViewController () 
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@end

@implementation WSIMeDetailViewController

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

/**
 *  推出个人详情页面
 */

-(void)nextBtnDidTap {
   
    WSIPerosonalViewController *personal = [WSIPerosonalViewController new];

  
    [[UIViewController getNavi]  pushViewController:personal animated:YES];
    
   
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
