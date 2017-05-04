//
//  WSICommentViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/3.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSICommentViewController.h"
#import "LYPhoto.h"
#import "LYPhotoBrowser.h"
#import <STPopup/STPopup.h>
#import "WSIMeDetailViewController.h"

@interface WSICommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIImageView *headerIv;
@property(nonatomic,strong)UILabel *nickName;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *shareBt;
@property(nonatomic,strong)UIButton *love;
@property(nonatomic,strong)UIButton *comment;
@property(nonatomic,strong)UILabel *loveCount;
@property(nonatomic,strong)UILabel *commentCount;
@property(nonatomic,strong)UIImageView *contentIv;
@property(nonatomic,strong)UILabel *contentlabel;
@property(nonatomic,strong) STPopupController *popupController;
@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIButton *detailBt;
@end

@implementation WSICommentViewController
static NSString *ID = @"commentCell";

#pragma mark - 懒加载

-(UIButton *)detailBt {

    if (!_detailBt) {
        
        _detailBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBt setTitle:@"心愿详情" forState:UIControlStateNormal];
        [_detailBt setTitleColor:[UIColor colorWithRed:251/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
        [_detailBt.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_detailBt setBackgroundColor:[UIColor clearColor]];
        [_detailBt.layer setBorderWidth:1.0f];
        [_detailBt.layer setCornerRadius:4.0f];
        [_detailBt.layer setBorderColor:[UIColor colorWithRed:252/255.0 green:144/255.0 blue:160/255.0 alpha:1.0f].CGColor];
    }
    
    return _detailBt;
}

-(UIImageView *)headerIv {

    if (!_headerIv) {
        
        _headerIv = [[UIImageView alloc] initWithRoundingRectImageView];
        [_headerIv setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
        [_headerIv addGestureRecognizer:tapGr2];
        
        [_avObj.user fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
            
            NSString *headStr = [object objectForKey:@"userHeader"];
            [_headerIv sd_setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
            
            [_nickName setText:[object objectForKey:@"nickName"]];
        } ];
        
    }
    
    return _headerIv;
}

-(UILabel *)nickName {

    if (!_nickName) {
        
        _nickName = [UILabel new];
        [_nickName setNumberOfLines:0];
        [_nickName setTextColor:[UIColor colorWithRed:0/255.0 green:114/255.0 blue:254/255.0 alpha:1.0f]];
        [_nickName setFont:[UIFont systemFontOfSize:13.0f]];
    }
    
    return _nickName;
}

-(UILabel *)time {

    if (!_time) {
        
        _time = [UILabel new];
        [_time setText:_avObj.createdAt];
        [_time setNumberOfLines:0];
        [_time setTextColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0f]];
        [_time setFont:[UIFont systemFontOfSize:12.0f]];
    }
    
    return _time;
}

-(UIView *)lineView {

    if (!_lineView) {
        
        _lineView = [UIView new];
        [_lineView setBackgroundColor:[UIColor colorWithRed:237/255.0 green:239/255.0 blue:241/255.0 alpha:1.0f]];
    }
    
    return _lineView;
}

-(UIButton *)shareBt {

    if (!_shareBt) {
        
        _shareBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBt setImage:[UIImage imageNamed:@"三个圆点"] forState:UIControlStateNormal];
    }
    
    return _shareBt;
}

-(UIButton *)love {

    if (!_love) {
        
        _love = [UIButton buttonWithType:UIButtonTypeCustom];
        [_love setImage:[UIImage imageNamed:@"爱心 (4)"] forState:UIControlStateNormal];
    }
    
    return _love;
}

-(UILabel *)loveCount {

    if (!_loveCount) {
        
        _loveCount = [UILabel new];
        [_loveCount setText:@"256"];
        [_loveCount setNumberOfLines:0];
        [_loveCount setTextColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0f]];
        [_loveCount setFont:[UIFont systemFontOfSize:10.0f]];;
    }
    
    return _loveCount;
}

-(UIButton *)comment {

    if (!_comment) {
        
        _comment = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comment setImage:[UIImage imageNamed:@"评论 (3)"] forState:UIControlStateNormal];
    }
    
    return _comment;
}

-(UILabel *)commentCount {

    if (!_commentCount) {
        
        _commentCount = [UILabel new];
        [_commentCount setText:@"226"];
        [_commentCount setNumberOfLines:0];
        [_commentCount setTextColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0f]];
        [_commentCount setFont:[UIFont systemFontOfSize:10.0f]];;
    }
    
    return _commentCount;
}

-(UILabel *)contentlabel {

    if (!_contentlabel) {
        
        _contentlabel = [UILabel new];
        [_contentlabel setText:_avObj.comment];
        [_contentlabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_contentlabel setNumberOfLines:0];
    }
    
    return _contentlabel;
}

-(UIImageView *)contentIv {

    if (!_contentIv) {
        
        _contentIv = [UIImageView new];
        [_contentIv setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [_contentIv addGestureRecognizer:tapGr];
        [_contentIv setContentMode:UIViewContentModeScaleAspectFit];
        [_contentIv sd_setImageWithURL:[NSURL URLWithString:_avObj.picUrl] placeholderImage:nil options:0 progress:nil completed:nil];
    }
    
    return _contentIv;
}

-(void)tap{
    
    LYPhoto *photo = [LYPhoto photoWithImageView:_contentIv placeHold:_contentIv.image photoUrl:nil];
    [LYPhotoBrowser showPhotos:@[photo] currentPhotoIndex:0 countType:LYPhotoBrowserCountTypeNone];
}

-(void)tap2 {
    
    [STPopupNavigationBar appearance].barTintColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:nil size:15], NSForegroundColorAttributeName: [UIColor whiteColor] };
    WSIMeDetailViewController *meVc = [WSIMeDetailViewController new];
    
    NSString *notiName = @"pushVc";
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:@[@(_headerIv.tag),meVc]];
    
    _popupController = [[STPopupController alloc]initWithRootViewController:meVc];
    _popupController.containerView.layer.cornerRadius = 4.0f;
    [_popupController presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    [_popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
}

-(void)backgroundViewDidTap {
    
    [_popupController dismiss];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSectionHeight];
}

-(void)setupSectionHeight {

    [_tableView setSectionHeaderHeight:5.0f];
    [_tableView setSectionFooterHeight:5.0f];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    if (section == 0) {
        
        return 1;
    }
    
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.section == 0) {
            
            //头像
            
            [cell addSubview:self.headerIv];
            
            [_headerIv mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(49, 49));
                make.left.mas_equalTo(cell.mas_left).with.offset(15);
                make.top.mas_equalTo(cell.mas_top).with.offset(15);
            }];
            
            //昵称
            
            [cell addSubview:self.nickName];
            
            [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(_headerIv.mas_top);
                make.left.mas_equalTo(_headerIv.mas_right).with.offset(10);
                make.right.mas_equalTo(cell.mas_right).with.offset(15);
            }];
            
            //时间
            
            [cell addSubview:self.time];
            
            [_time mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(_nickName.mas_bottom).with.offset(5);
                make.leading.mas_equalTo(_nickName.mas_leading);
                make.right.mas_equalTo(cell.mas_right).with.offset(15);
            }];
            
            //分割线
            
            [cell addSubview:self.lineView];
            
            [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(0.33);
                make.top.mas_equalTo(_headerIv.mas_bottom).with.offset(20);
                make.left.mas_equalTo(cell.mas_left).with.offset(0);
                make.right.mas_equalTo(cell.mas_right).with.offset(0);
            }];
            
            //分享bt
            
            [cell addSubview:self.shareBt];
            
            [_shareBt mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(29, 29));
                make.top.mas_equalTo(cell.mas_top).with.offset(16);
                make.right.mas_equalTo(cell.mas_right).with.offset(-12);
                
                
            }];
            
            //赞bt
            
            [cell addSubview:self.love];
            
            [_love mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(15, 15));
                make.left.mas_equalTo(cell.mas_left).with.offset(15);
                make.bottom.mas_equalTo(cell.mas_bottom).with.offset(-15);
            }];
            
            //赞label
            
            [cell addSubview:self.loveCount];
            
            [_loveCount mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(15);
                make.left.mas_equalTo(_love.mas_right).with.offset(3);
                make.bottom.mas_equalTo(_love.mas_bottom);
                
            }];
            
            //评论bt
            
            [cell addSubview:self.comment];
            
            [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(13, 13));
                make.left.mas_equalTo(_loveCount.mas_right).with.offset(10);
                make.bottom.mas_equalTo(cell.mas_bottom).with.offset(-15);
            }];
            
            //评论label
            
            [cell addSubview:self.commentCount];
            
            [_commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(15);
                make.left.mas_equalTo(_comment.mas_right).with.offset(3);
                make.bottom.mas_equalTo(_comment.mas_bottom);
                
            }];
            
            //配图文字
            
            [cell addSubview:self.contentlabel];
            
            [_contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(cell.mas_left).with.offset(15);
                make.right.mas_equalTo(cell.mas_right).with.offset(-15);
                make.bottom.mas_equalTo(_commentCount.mas_top).with.offset(-20);
            }];
            
            //配图iv
            
            [cell addSubview:self.contentIv];
            
            [_contentIv mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(_lineView.mas_bottom).with.offset(0);
                make.left.mas_equalTo(cell.mas_left).with.offset(0);
                make.right.mas_equalTo(cell.mas_right).with.offset(0);
                make.bottom.mas_equalTo(_contentlabel.mas_top).with.offset(-10);
            }];
            
            //心愿详情
            
            [cell addSubview:self.detailBt];
            
            [_detailBt mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(65, 30));
                make.right.mas_equalTo(cell.mas_right).with.offset(-15);
                make.bottom.mas_equalTo(cell.mas_bottom).with.offset(-15);
            }];
        }
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
            
        case 0:
            
        {
            return _avObj.cellHeight;
            
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







@end
