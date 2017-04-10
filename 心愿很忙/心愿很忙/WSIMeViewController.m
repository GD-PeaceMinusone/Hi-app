//
//  WSIMeViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/9.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIMeViewController.h"

@interface WSIMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WSIMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
