//
//  WSIMeViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/9.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIMeViewController.h"
#import "WSIEditViewController.h"
#import <UIImageView+WebCache.h>


@interface WSIMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
@property(nonatomic,strong)WSIEditViewController *editVc;
@end

@implementation WSIMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setupHeaderIv];
}

-(void)viewWillAppear:(BOOL)animated {

    [_headerIv sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"headerPath"]] placeholderImage:nil];
}

#pragma mark - 懒加载

- (WSIEditViewController *)editVc {

    if (!_editVc) {
        
        _editVc = [WSIEditViewController new];
    }
    
    return _editVc;
}

/**
 *  初始化
 */

-(void)setupHeaderIv {

    _headerIv.layer.borderWidth = 1.5f;
    _headerIv.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerIv.layer.shadowColor = [UIColor colorWithRed:237.0/255 green:239.0/255 blue:241.0/255 alpha:1.0].CGColor;
    _headerIv.layer.shadowOpacity = 1.0;
    _headerIv.layer.shadowOffset = CGSizeMake(0, 0);
    _headerIv.layer.shadowRadius = 3.f;
    _headerIv.userInteractionEnabled = YES;
    [_headerIv sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"headerPath"]] placeholderImage:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_headerIv addGestureRecognizer:tap];
}


/**
 *  跳转到个人信息页面
 */

-(void)tap {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSlider" object:nil];
    [[UIViewController getNavi] pushViewController:self.editVc animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeNavi" object:nil];
}


#pragma mark - delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSArray *images = @[@"纸",@"爱心-1",@"版本"];
    NSArray *titles = @[@"心愿清单",@"打小报告",@"版本信息"];
        
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}

@end
