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

    if ([AVUser currentUser] == nil) {
        
        UIImage *image = [UIImage imageNamed:@"笑脸 (11)"];
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
    
    /**
    _headerIv.layer.borderWidth = 1.5f;
    _headerIv.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerIv.layer.shadowColor = [UIColor colorWithRed:237.0/255 green:239.0/255 blue:241.0/255 alpha:1.0].CGColor;
    _headerIv.layer.shadowOpacity = 1.0;
    _headerIv.layer.shadowOffset = CGSizeMake(0, 0);
    _headerIv.layer.shadowRadius = 3.f;
     */
    
    _headerIv.userInteractionEnabled = YES;
    _bgIv.userInteractionEnabled = YES;
    
    [[AVUser currentUser] fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        
        NSString *headerStr = [object objectForKey:@"squareUserHeader"];
        
        NSURL *headerUrl = [NSURL URLWithString:headerStr];
        
        [_headerIv sd_setImageWithURL:headerUrl placeholderImage:[UIImage imageNamed:@"笑脸 (11)"]];
        
        NSString *nameStr = [object objectForKey:@"nickName"];
        [_nickName setText:nameStr];
        
        NSString *signStr = [object objectForKey:@"sign"];
        [_sign setText:signStr];
        
        NSString *bgStr = [object objectForKey:@"bgUrl"];
        NSURL *bgUrl = [NSURL URLWithString:bgStr];
        
        [_bgIv sd_setImageWithURL:bgUrl placeholderImage:nil];
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
