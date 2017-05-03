//
//  WSICommentViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/3.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSICommentViewController.h"


@interface WSICommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *headerIv;
@end

@implementation WSICommentViewController
static NSString *ID = @"commentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)awakeFromNib {

    [super awakeFromNib];
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    switch (section) {
            
        case 0:
            
            return 1;
            
            break;
            
        case 1:
            
            return 1;
            
            break;
   
        default:
            break;
    }
    
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
       
        
        switch (indexPath.section) {
                
            case 0:
            {
                //头像
               _headerIv = [[UIImageView alloc] initWithRoundingRectImageView];
                _headerIv.image = [UIImage imageNamed:@"header"];
                [cell addSubview:_headerIv];
                
                [_headerIv mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.size.mas_equalTo(CGSizeMake(49, 49));
                    make.left.mas_equalTo(cell.mas_left).with.offset(15);
                    make.top.mas_equalTo(cell.mas_top).with.offset(15);
                }];
                
                
                
                
                
                
            }
                break;
                
            case 1:
                
                
                break;
            case 2:
                
                
                break;
                
            default:
                break;
        }
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
            
        case 0:
            
        {
            return 400;
            
        }
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        default:
            break;
    }
    
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 20;
}










@end
