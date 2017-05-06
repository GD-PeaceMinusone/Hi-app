//
//  WSIMeViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/9.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIMeViewController.h"
#import "WSIHomePageViewController.h"
#import <UIImageView+WebCache.h>


@interface WSIMeViewController ()<UITableViewDataSource,UITableViewDelegate>
/**vc*/
@property(nonatomic,strong)WSIHomePageViewController *editVc;
/**tableView*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
/**签名*/
@property (weak, nonatomic) IBOutlet UILabel *sign;
/**昵称*/
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/**背景*/
@property (weak, nonatomic) IBOutlet UIImageView *bgIv;

@end

@implementation WSIMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)viewWillAppear:(BOOL)animated {

    if ([BmobUser currentUser] == nil) {
        
        UIImage *image = [UIImage imageNamed:@"笑脸 (22)"];
        _headerIv.image = image;
        
    }else {
        
        [self setupHeaderIv];
    }
    
}

#pragma mark - 懒加载

- (WSIHomePageViewController *)editVc {

    if (!_editVc) {
        
        _editVc = [WSIHomePageViewController new];
    }
    
    return _editVc;
}

/**
 *  初始化
 */

-(void)setupHeaderIv {

    _headerIv.userInteractionEnabled = YES;
    _bgIv.userInteractionEnabled = YES;

    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:[BmobUser currentUser].objectId block:^(BmobObject *object, NSError *error) {
        
        NSString *headStr = [object objectForKey:@"userHeader"];
        
        [_headerIv sd_setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
        
        [_nickName setText:[object objectForKey:@"nickName"]];
        
        NSString *signStr = [object objectForKey:@"sign"];
        
        [_sign setText:signStr];
        
        NSString *bgStr = [object objectForKey:@"bgUrl"];
    
        [_bgIv sd_setImageWithURL:[NSURL URLWithString:bgStr] placeholderImage:nil];
        
    }];


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_headerIv addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_bgIv addGestureRecognizer:tap2];
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
