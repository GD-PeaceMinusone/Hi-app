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
#import "CommentTableViewCell.h"
#import "ContentTableViewCell.h"
#import "MJRefreshGifHeader+HeaderRefresh.h"
#import "WSIRefreshHeader.h"
#import "WSIRefreshFooter.h"
#import "UIScrollView+Refresh.h"

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
@property(nonatomic,strong)NSMutableArray *moreComArr;
@property(nonatomic,strong)UILabel *comNick;
@property(nonatomic,strong)UIView *comView;
@property (nonatomic,assign) BOOL isScroll;
@end

@implementation WSICommentViewController
static NSString *ID = @"commentCell";
static NSString *notiName = @"pushVc";

#pragma mark - 懒加载

-(BOOL)isScroll {

    if (!_isScroll) {
        
        _isScroll = NO;
    }
    
    return  _isScroll;
}

-(NSMutableArray *)comArr {

    if (!_comArr) {
        
        _comArr = [NSMutableArray array];
    }
    
    return _comArr;
}

-(NSMutableArray *)moreComArr {

    if (!_moreComArr) {
        
        _moreComArr = [NSMutableArray array];
    }
    
    return _moreComArr;
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

#pragma mark - 加载数据相关

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSectionHeight];
    [self setupInput];
    [self registerCell];
    [self setupRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVc:) name:notiName object:nil];

}

-(void)pushVc: (NSNotification*)noti { //接受传过来的Vc 通过tag给对应vc赋值
    
    NSInteger index = [noti.object[0] integerValue];
    WSIMeDetailViewController *detailVc = noti.object[1];
    detailVc.model = _comArr[index];
}


-(void)viewWillAppear:(BOOL)animated { //view即将显示时先将评论数组置空 防止评论页面混乱
    
     _comArr = nil;
    [self loadNewTopics];
    [self.tableView reloadData];
  
    NSLog(@"---comarr:%ld", _comArr.count);
}

-(void)setupRefresh {
    
    WSIWeakSelf
    [self.tableView addHeaderRefresh:^{
        [weakSelf loadNewTopics];
    }];
    
    [weakSelf.tableView beginHeaderRefresh];
    
    [self.tableView addFooterRefresh:^{
        [weakSelf loadMoreTopics];
    }];
}

-(void)loadNewTopics {
    
    [_tableView.mj_footer resetNoMoreData]; // 重置没有加载完毕状态
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    
    [query whereKey:@"comment" equalTo:_avObj.avObj];
    
    query.limit = 20;
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"----%@---", error);
            
            [HUDUtils setupErrorWithStatus:@"加载评论失败" WithDelay:1.5f completion:^{
               
            WSIWeakSelf
            [weakSelf.tableView endHeaderRefresh];
                
            }];
        }{
            
            if (_comArr.count != objects.count) {
                
                _comArr = nil;
            }
            
            NSLog(@"---objects:%ld", objects.count);
  
            if (objects.count == 0) {
                
                [_tableView.mj_footer endRefreshingWithNoMoreData]; //当没有数据返回时 显示加载完毕状态
                
                WSIWeakSelf
                [weakSelf.tableView endHeaderRefresh];
                
                return;
            }
          
            _comArr = [[commentModel commentObjectArrayFromBmobObjArrary:objects]mutableCopy];
            
            _moreComArr = [[commentModel commentObjectArrayFromBmobObjArrary:objects]mutableCopy];
            
            WSIWeakSelf
            [weakSelf.tableView endHeaderRefresh];
            [self.tableView reloadData];
        }
    }];
  
}

-(void)loadMoreTopics {
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    
    [query whereKey:@"comment" equalTo:_avObj.avObj];
    
    query.limit = 20;
    
    commentModel *model = _moreComArr[_moreComArr.count - 1];
    
    BmobObject *obj = model.comObj;
    
    [query whereKey:@"createdAt" lessThan:obj.createdAt];
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            
            [HUDUtils setupErrorWithStatus:@"加载失败" WithDelay:1.5f completion:^{
                
                WSIWeakSelf
                [weakSelf.tableView endFooterRefresh];
                
            }];
        }{
            if (objects.count == 0) {
                
                [_tableView.mj_footer endRefreshingWithNoMoreData]; //当没有数据返回时 显示加载完毕状态
                
                return;
            }
            
            [_comArr addObjectsFromArray:[commentModel commentObjectArrayFromBmobObjArrary:objects]];
            [_moreComArr addObjectsFromArray:[commentModel commentObjectArrayFromBmobObjArrary:objects]];

            [self.tableView reloadData];
            
            WSIWeakSelf
            [weakSelf.tableView endFooterRefresh];
            
        }
        
    }];

    
}


-(void)setupInput {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [_inputView setPlaceholder:@"来,说两句"];
    
    [_inputView setPlaceholderColor:[UIColor grayColor]];
    
    _inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        
        _bottomHCons.constant = textHeight + 10;
    };
    
    _inputView.maxNumberOfLines = 4;
}

-(void)registerCell {
    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"comment"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ContentTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"content"];
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
  
            [self loadNewTopics];
            [_tableView setContentOffset:CGPointMake(0, _avObj.cellHeight - 130) animated:YES];
            _bottomHCons.constant = 43.0f;
            _bottomCons.constant = 0;
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
    
    if (self.isScroll == NO) {
        
        //让页面加载时 直接到评论界面
        
        [_tableView setContentOffset:CGPointMake(0, _avObj.cellHeight - 130) animated:YES];
        _isScroll = YES;
    }

    if (section == 0) {
        
        return 1;
    }
    
    return _comArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {

        ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content"];
        
        cell.avObj = _avObj;
  
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
      
    }else {

        CommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell= (CommentTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"CommentTableViewCell" owner:self options:nil]  lastObject];
        }
  
        cell.comModel = _comArr[indexPath.row];
        
        cell.headerIv.tag = indexPath.row;

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return _avObj.comCellHeight;
        
    }else {
    
    commentModel *model = _comArr[indexPath.row];
    
    return model.cellHeight;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.view endEditing:YES];
    
}



@end
