//
//  WSIPerosonalViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/22.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIPerosonalViewController.h"
#import <Masonry.h>
#import "UIImage+WSIExtension.h"
#import "PersonalTableViewCell.h"

@interface WSIPerosonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIImageView *headerIv2;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation WSIPerosonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self registerCell];
    [self.view addSubview:self.tableView];
}

/**
 *  注册cell
 */
-(void)registerCell {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"personalCell"];
    
   }


#pragma mark - 懒加载

-(UIImageView *)headerIv2 {

    if (!_headerIv2) {
        
       UIImage *image = [UIImage imageWithIconName:@"header" borderImage:nil border:0];
        
        _headerIv2 = [[UIImageView alloc]initWithImage:image];
        
    }
    
    return _headerIv2;
}


-(UITableView *)tableView {

    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        _tableView.separatorStyle =                                         UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    
    return _tableView;
}

#pragma mark - delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        
    }
    PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView *BgIv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IMG_1962"]];
    
    BgIv.frame = CGRectMake(0, 0, self.view.xmg_width, 200);
    
    
    /**
     *  此时添加头像 保证不会被tableHeaderView覆盖
     */
    
    [self.tableView addSubview:self.headerIv2];
    
    [_headerIv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(79, 79));
        make.right.mas_equalTo(self.tableView.mas_right).with.offset(360);
        make.top.mas_equalTo(self.tableView.mas_top).with.offset(250);
    
    }];
    
    

    return BgIv;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath == 0) {
        
        return 10;
        
    }else {
    
        return 600;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 300;
}

@end
