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


@interface WSIMeDetailViewController () 
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;

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
    
    [self.popView.layer setCornerRadius:4.0f];
    [self.headerIv circleHeader:self.headerIv withBorderWidth:0 andBorderColor:nil];
    
}


-(void)setAvObj:(AVObject *)avObj {

    _avObj = avObj;
    
    AVUser *user = [_avObj objectForKey:@"wishUser"];
        
        [user fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
            
            NSString *headerStr = [object objectForKey:@"userHeader"];
            
            NSURL *headerUrl = [NSURL URLWithString:headerStr];
            
            [_headerIv sd_setImageWithURL:headerUrl];
            
        }];
    
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
