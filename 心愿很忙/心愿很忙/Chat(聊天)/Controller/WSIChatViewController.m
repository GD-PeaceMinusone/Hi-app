//
//  WSIChatViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/12.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIChatViewController.h"
#import "WSIPerosonalViewController.h"

@interface WSIChatViewController ()
@property(nonatomic,strong)UIButton *leftBt;
@property(nonatomic,strong)UIBarButtonItem *left;
@property(nonatomic,strong)UIButton *rightBt;
@property(nonatomic,strong)UIBarButtonItem *right;
@property(nonatomic,strong)WSIPerosonalViewController *personVc;
@end

@implementation WSIChatViewController

-(WSIPerosonalViewController *)personVc {
    
    if (!_personVc) {
        
        _personVc = [WSIPerosonalViewController new];
    }
    
    return _personVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.conversationMessageCollectionView.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回 (3)"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
   
    self.navigationItem.leftBarButtonItem = item;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self.navigationController.navigationBar.subviews firstObject] setHidden:YES];
    self.tabBarController.tabBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated { //隐藏tabbar
    
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell isKindOfClass:[RCMessageCell class]]) {
        
        RCMessageCell *messageCell = (RCMessageCell *)cell;

        //messageCell.portraitImageView
        
        UIImageView *portraitImageView= (UIImageView *)messageCell.portraitImageView;
  
        portraitImageView.layer.cornerRadius = portraitImageView.xmg_width/2;
        
    }
   
}

@end
