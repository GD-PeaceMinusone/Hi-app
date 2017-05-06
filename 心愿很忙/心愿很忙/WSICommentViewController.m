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
#import "YZInputView.h"

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
@property (weak, nonatomic) IBOutlet UIButton *sendBt;
@property (weak, nonatomic) IBOutlet UIButton *emojiBt;
@property (weak, nonatomic) IBOutlet YZInputView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property(nonatomic,strong)UIImageView *comHead;
@property(nonatomic,strong)UILabel *comLabel;
@property(nonatomic,strong)UILabel *comTime;
@property(nonatomic,strong)UIButton *revertBt;
@property(nonatomic,strong)UIButton *likeBt;
@property(nonatomic,strong)NSMutableArray *comArr;
@property(nonatomic,strong)UILabel *comNick;
@property(nonatomic,strong)UIView *comView;
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
        
        BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
        
        [query getObjectInBackgroundWithId:_avObj.user.objectId block:^(BmobObject *object, NSError *error) {
            
            NSString *headStr = [object objectForKey:@"userHeader"];
            
            [_headerIv sd_setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
            
            [_nickName setText:[object objectForKey:@"nickName"]];
        }];
        
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

-(UIImageView *)comHead {

    if (!_comHead) {
        
        _comHead = [[UIImageView alloc] initWithRoundingRectImageView];
        
        [_comHead setImage:[UIImage imageNamed:@"header"]];
        
        [_comHead setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
        
        [_comHead addGestureRecognizer:tapGr];
 
       
    }
    
    return _comHead;
}


-(UILabel *)comLabel {

    if (!_comLabel) {
        
        _comLabel = [UILabel new];
        _comLabel.text = @"zandfsdfdsfsdf";
        [_comLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_comLabel setNumberOfLines:0];
    }
    
    return _comLabel;
}


-(UILabel *)comTime {

    if (!_comTime) {
        
        _comTime = [UILabel new];
        [_comTime setText:@"2小时前"];
        [_comTime setTextColor:[UIColor grayColor]];
        [_comTime setFont:[UIFont systemFontOfSize:12.0f]];
    }
    
    return _comTime;
}

-(UILabel *)comNick {

    if (!_comNick) {
        
        _comNick = [UILabel new];
        [_comNick setText:@"你好啊蟹蟹"];
        [_comNick setNumberOfLines:0];
        [_comNick setTextColor:[UIColor colorWithRed:0/255.0 green:114/255.0 blue:254/255.0 alpha:1.0f]];
        [_comNick setFont:[UIFont systemFontOfSize:13.0f]];
    }
    
    return _comNick;
}

-(UIButton *)revertBt {

    if (!_revertBt) {
        
        _revertBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_revertBt setTitle:@"回复" forState:UIControlStateNormal];
        [_revertBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_revertBt.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    
    return _revertBt;
}

-(UIButton *)likeBt {

    if (!_likeBt) {
        
        _likeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBt setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    }
    
    return _likeBt;
}

#pragma mark - 手势相关

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

#pragma mark - 键盘相关

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSectionHeight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [_inputView setPlaceholder:@"来,说两句"];
    [_inputView setPlaceholderColor:[UIColor grayColor]];

    _inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){

       _bottomHCons.constant = textHeight + 10;
    };
 
    _inputView.maxNumberOfLines = 4;
    
 
    
}

// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 修改底部视图距离底部的间距
    _bottomCons.constant = endFrame.origin.y != screenH?endFrame.size.height:0;
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}



-(void)setupSectionHeight {

    [_tableView setSectionHeaderHeight:5.0f];
    [_tableView setSectionFooterHeight:5.0f];
}

- (IBAction)sendBt:(id)sender {
    
    BmobObject *wishObj = [[BmobObject alloc] initWithClassName:@"Comment"]; //建表
    [wishObj setObject:_inputView.text forKey:@"content"]; //评论内容
    [wishObj setObject:_avObj.avObj forKey:@"comment"]; //评论的对应的状态
    [wishObj setObject:[BmobUser currentUser] forKey:@"wishUser"]; //评论人
    
    [wishObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            NSLog(@"评论成功");
           
            NSInteger height = [SizeUtils stringSizeWithString:_inputView.text].height;
            _bottomHCons.constant = height + 10;
            [_inputView setText:nil];
            [self.view endEditing:YES];
            
        }else {
            
            NSLog(@"评论失败");
        }
        
    }];
 
    
}


#pragma mark - 代理相关

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    if (section == 0) {
        
        return 1;
    }
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        if (indexPath.section == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if (!cell) {
      
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
                make.right.mas_equalTo(cell.mas_right).with.offset(-15);
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
        
        return cell;
    }
    
    
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"id"];
    
    if (!cell2) {
        
            cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"];
        
            //头像
        
            [cell2 addSubview:self.comHead];
        
            [_comHead mas_makeConstraints:^(MASConstraintMaker *make) {
            
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.left.mas_equalTo(cell2.mas_left).with.offset(10);
                make.top.mas_equalTo(cell2.mas_top).with.offset(10);
            }];
        
            //昵称
        
            [cell2 addSubview:self.comNick];
        
            [_comNick mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(20);
                make.top.mas_equalTo(_comHead.mas_top);
                make.left.mas_equalTo(_comHead.mas_right).with.offset(5);
                make.right.mas_equalTo(cell2.mas_right).with.offset(-15);

            }];
        
            //评论时间
        
            [cell2 addSubview:self.comTime];
        
            [_comTime mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(50, 20));
                make.leading.mas_equalTo(_comNick.mas_leading);
                make.bottom.mas_equalTo(cell2.mas_bottom).with.offset(-10);
          
            }];

            //评论内容1
        
            [cell2 addSubview:self.comLabel];
        
            [_comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
                make.leading.mas_equalTo(_comNick.mas_leading);
                make.right.mas_equalTo(cell2.mas_right).with.offset(-15);
                make.top.mas_equalTo(_comNick.mas_bottom).with.offset(10);
                make.bottom.mas_equalTo(_comTime.mas_top).with.offset(-30);
            }];
        
        
            //点赞按钮
        
            [cell2 addSubview:self.likeBt];
        
            [_likeBt mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.top.mas_equalTo(cell2.mas_top).with.offset(13);
                make.right.mas_equalTo(cell2.mas_right).with.offset(-15);
            }];
        
            //回复按钮
        
            [cell2 addSubview:self.revertBt];
        
            [_revertBt mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.size.mas_equalTo(CGSizeMake(40, 20));
                make.left.mas_equalTo(cell2.mas_left).with.offset(110);
                make.bottom.mas_equalTo(cell2.mas_bottom).with.offset(-10);
                
            }];
        
        
        
        //在cell加载时查询到该条状态的所有评论
        
        BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
        
        [query whereKey:@"comment" equalTo:_avObj.avObj];
        
        [query orderByAscending:@"createdAt"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            _comArr = [[commentModel commentObjectArrayFromBmobObjArrary:array] mutableCopy];
            
            commentModel *comModel = _comArr[indexPath.row];
            
            [_comLabel setText:comModel.content];
            
            BmobQuery *q = [BmobQuery queryWithClassName:@"_User"];
            
            [q getObjectInBackgroundWithId:comModel.user.objectId block:^(BmobObject *object, NSError *error) {
                
                [_comNick setText:[object objectForKey:@"nickName"]];
                
                NSString *str = [object objectForKey:@"userHeader"];
                
                [_comHead sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
            }];
        }];
        
    }


    return cell2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return _avObj.cellHeight;
    }
    
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.view endEditing:YES];
}





@end
