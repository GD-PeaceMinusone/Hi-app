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

-(UIButton *)leftBt {
    
    if (!_leftBt) {
        
        _leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _leftBt.frame = CGRectMake(0, 0, 23, 23);
        [_leftBt setImage:[UIImage imageNamed:@"返回 (3)"] forState:UIControlStateNormal];
        
    }
    
    return _leftBt;
}


-(UIBarButtonItem *)left {
    
    if (!_left) {
        
        _left = [[UIBarButtonItem alloc]initWithCustomView:self.leftBt];
        
    }
    
    return _left;
}

-(UIButton *)rightBt {
    
    if (!_rightBt) {
        
        _rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBt addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
        _rightBt.frame = CGRectMake(0, 0, 23, 23);
        [_rightBt setImage:[UIImage imageNamed:@"查看"] forState:UIControlStateNormal];
        
    }
    
    return _rightBt;
}


-(UIBarButtonItem *)right {
    
    if (!_right) {
        
        _right = [[UIBarButtonItem alloc]initWithCustomView:self.rightBt];
        
    }
    
    return _right;
    
}

-(void)back {
    
    [[UIViewController getNavi] popViewControllerAnimated:YES];
}

-(void)setting {
    
    [[UIViewController getNavi] pushViewController:self.personVc animated:YES];
}


-(void)setupNavi {
    
    self.navigationItem.leftBarButtonItem = self.left;
    self.navigationItem.rightBarButtonItem = self.right;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    self.conversationMessageCollectionView.backgroundColor = [UIColor whiteColor];
   
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self.navigationController.navigationBar.subviews firstObject] setHidden:YES];
}

@end
