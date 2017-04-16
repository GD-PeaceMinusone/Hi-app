//
//  WSIMainViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/6.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIMainViewController.h"
#import "WSISmallTableViewController.h"
#import "WSIBigTableViewController.h"
#import "WSILoginViewController.h"
#import "WSIMeViewController.h"
#import "CodeViewController.h"
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"
#import "DemoCell.h"


@interface WSIMainViewController () <UIScrollViewDelegate>
@property(nonatomic,weak)UIView *navLine;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UISegmentedControl *segment;
@end

@implementation WSIMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupChildViewControllers];
    [self setScrollView];
    [self setupNavigationBar];
    [self setupSegment];
    [self setupPublishButton];
    
    [self addChildVcView];
    
}

-(void)setupView {

    self.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:242.0/255 blue:244.0/255 alpha:1];

}

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
    CGFloat buttonY = self.view.xmg_height - XMGMargin - buttonH;
    
    publishButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [publishButton addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:publishButton];
}

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

-(void)goMe {
    
    [ShareApp.drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

-(void)setupSegment {

    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"小心愿",@"大心愿"]];
    self.segment.selectedSegmentIndex = self.scrollView.contentOffset.x / self.scrollView.xmg_width;
    self.segment.tintColor = [UIColor blackColor];
    [self.segment addTarget:self action:@selector(changeVc:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
}

-(void)changeVc: (UISegmentedControl*)segment {

    CGPoint offset = self.scrollView.contentOffset;
    offset.x = segment.selectedSegmentIndex * self.scrollView.xmg_width;
    [self.scrollView setContentOffset:offset animated:YES];
    
}


-(void)setupChildViewControllers {

    WSISmallTableViewController *smallVc = [WSISmallTableViewController new];
    WSIBigTableViewController *bigVc = [WSIBigTableViewController new];
    
    [self addChildViewController:smallVc];
    [self addChildViewController:bigVc];
}

-(void)setScrollView {

    self.scrollView = [[UIScrollView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.bounces = NO;
    self.scrollView.frame = self.view.bounds;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.xmg_width, 0);
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    
}

-(void)addChildVcView {

    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.xmg_width;
    
    UIViewController *childVc = self.childViewControllers[index];
    //判断当前view是否正在显示
    if([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;

    [self.scrollView addSubview:childVc.view];
}


#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
        [self addChildVcView];
 
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.xmg_width;
    self.segment.selectedSegmentIndex = index;

        
    [self addChildVcView];

}


@end
