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
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"
#import "DemoCell.h"

@interface WSIMainTableViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *cellHeights;

@end

@implementation WSIMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self createCellHeightsArray];
    
    [self setupTableView];
    [self setupNavigationBar];
    [self setupPublishButton];
    
}

//设置view
-(void)setupTableView {
    
   self.tableView.backgroundColor = [UIColor colorWithRed:237.0/255 green:239.0/255 blue:241.0/255 alpha:0.7];
    
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
    CGFloat buttonY = self.view.xmg_height - XMGMargin - buttonH;
    
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
    return kRowsCount;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(DemoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![cell isKindOfClass:[DemoCell class]]) return;
    
    cell.backgroundColor = [UIColor clearColor];
    
    CGFloat cellHeight = self.cellHeights[indexPath.row].floatValue;
    if (cellHeight == kCloseCellHeight) {
        [cell selectedAnimationByIsSelected:NO animated:NO completion:nil];
    }else
    {
        [cell selectedAnimationByIsSelected:YES animated:NO completion:nil];
    }
    
    [cell setNumber:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell" forIndexPath:indexPath];
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

#pragma mark - Getter && Setter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerNib:[UINib nibWithNibName:@"DemoCell" bundle:nil] forCellReuseIdentifier:@"DemoCell"];
    }
    return _tableView;
}

- (NSMutableArray<NSNumber *> *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray array];
    }
    return _cellHeights;
}
@end
