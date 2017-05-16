//
//  WSIHomePageViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/1.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSIHomePageViewController.h"
#import "UIViewController+SelectPhotoIcon.m"
#import "WMPanGestureRecognizer.h"
#import "SCAvatarBrowser.h"
#import "SRActionSheet.h"
#import <UIImageView+WebCache.h>
#import "WSIChattingViewController.h"
#import "WSIWishListTableViewController.h"
#import "WSICommentTableViewController.h"
#import "SGPageView.h"
#import "WSISettingViewController.h"


@interface WSIHomePageViewController () <SGPageTitleViewDelegate, SGPageContentViewDelegare>
/**背景*/
@property (weak, nonatomic) IBOutlet UIImageView *bgIv;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
/**心愿数量*/
@property (weak, nonatomic) IBOutlet UILabel *wishCount;
/**赞数量*/
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
/**昵称*/
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/**title*/
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
/**page*/
@property (nonatomic, strong) SGPageContentView *pageContentView;

@property(nonatomic,strong)UIButton *leftBt;

@property(nonatomic,strong)UIButton *rightBt;

@property(nonatomic,strong)UIBarButtonItem *left;

@property(nonatomic,strong)UIBarButtonItem *right;

@property(nonatomic,strong)WSISettingViewController *setVc;

@property(nonatomic,strong)WSIChattingViewController *chatVc;

@property(nonatomic,strong)WSIWishListTableViewController *wishVc;

@property(nonatomic,strong)WSICommentTableViewController *commentVc;
@end

@implementation WSIHomePageViewController

-(WSISettingViewController *)setVc {

    if (!_setVc) {
        
        _setVc = [WSISettingViewController new];
    }
    
    return _setVc;
}

-(UIButton *)leftBt {

    if (!_leftBt) {
        
        _leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _leftBt.frame = CGRectMake(0, 0, 25, 25);
        [_leftBt setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
 
    }
    
    return _leftBt;
}

-(UIButton *)rightBt {

    if (!_rightBt) {
        
        _rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBt addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
        _rightBt.frame = CGRectMake(0, 0, 25, 25);
        [_rightBt setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
 
    }
    
    return _rightBt;
}

-(UIBarButtonItem *)left {

    if (!_left) {
        
        _left = [[UIBarButtonItem alloc]initWithCustomView:self.leftBt];
       
  
    }
    
    return _left;
}

-(UIBarButtonItem *)right {

    if (!_right) {
        
       _right = [[UIBarButtonItem alloc]initWithCustomView:self.rightBt];
        
    }
    
    return _right;
}

-(WSIChattingViewController *)chatVc {

    if (!_chatVc) {
        
        _chatVc = [[WSIChattingViewController alloc]init];
    
    }
    
    return _chatVc;
}


-(WSIWishListTableViewController *)wishVc {

    if (!_wishVc) {
        
        _wishVc = [WSIWishListTableViewController new];
    }
    
    return _wishVc;
}

-(WSICommentTableViewController *)commentVc {

    if (!_commentVc) {
        
        _commentVc = [WSICommentTableViewController new];
        
    }
    
    return _commentVc;
}

-(SGPageContentView *)pageContentView {

    if (!_pageContentView) {

        NSArray *childArr = @[self.wishVc,self.commentVc];
        
        _pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 345, SCREEN_WIDTH, SCREEN_HEIGHT) parentVC:self childVCs:childArr];
        _pageContentView.delegatePageContentView = self;
    }

    return _pageContentView;
}



-(SGPageTitleView *)pageTitleView {
    
    if (!_pageTitleView) {
        
        NSArray *titleArr = @[@"心愿清单",@"评论与喜欢"];
        
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 305,SCREEN_WIDTH, 40) delegate:self titleNames:titleArr];
        _pageTitleView.selectedIndex = 0;
        [_pageTitleView setTitleColorStateNormal:[UIColor grayColor]];
        [_pageTitleView setTitleColorStateSelected:HiBlueColor];
        [_pageTitleView setIndicatorColor:HiBlueColor];
        [_pageTitleView setIndicatorStyle:SGIndicatorTypeEqual];
    }
    
    return _pageTitleView;
    
}


#pragma mark - 视图代理

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupHeaderIv];
    [self setupBgIv];
    
    [self.view addSubview:self.pageContentView];
    [self.view addSubview:self.pageTitleView];

  }

-(void)viewWillAppear:(BOOL)animated {

    [[self.navigationController.navigationBar.subviews firstObject] setHidden:YES];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:[BmobUser currentUser].objectId block:^(BmobObject *object, NSError *error) {
        
        
            NSString *bgStr = [object objectForKey:@"bgUrl"];
            NSURL *url = [NSURL URLWithString:bgStr];
                [_bgIv sd_setImageWithURL:url];
        
            NSString *headStr = [object objectForKey:@"userHeader"];
            NSURL *headUrl = [NSURL URLWithString:headStr];
            [_headerIv sd_setImageWithURL:headUrl];
        
            NSString *nickStr = [object objectForKey:@"nickName"];
            [_nickName setText:nickStr];
        
    }];
    
}

-(void)setupNavi {
    
     self.navigationItem.leftBarButtonItem = self.left;
     self.navigationItem.rightBarButtonItem = self.right;
}

-(void)back {

    [[UIViewController getNavi] popViewControllerAnimated:YES];
}

-(void)setting {

    [[UIViewController getNavi] pushViewController:self.setVc animated:YES];
}

-(void)setupHeaderIv {

     [_headerIv circleHeader:_headerIv withBorderWidth:1.5f andBorderColor:[UIColor whiteColor]];
     _headerIv.userInteractionEnabled = YES;
    
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkHead)];
     [_headerIv addGestureRecognizer:tap];
}

-(void)checkHead {
    
    [SCAvatarBrowser showImageView:_headerIv];
    
}

-(void)setupBgIv {

    _bgIv.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBg)];
    [_bgIv addGestureRecognizer:tap];
}

-(void)changeBg {

    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:@"更改背景"
                                                                cancelTitle:@"取消"
                                                           destructiveTitle:nil
                                                                otherTitles:@[@"相机",@"从手机相册选择",@"查看背景"]
                                                                otherImages:nil
                                                           selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                                                               
                                                               if (index == 0) {
                                                                   
                                                                   
                                                                   [self useCamera];
                                                                   
                                                               }else if(index == 1) {
                                                                   
                                                                   [self useAlbum];
                                                                   
                                                               }else {
                                                               
                                                                   [SCAvatarBrowser showImageView:_bgIv];
                                                               }
                                                               
                                                           }];
    
    [actionSheet show];
}


/**
 *  修改背景
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;{
    
    //获得编辑后的图片
    UIImage *editedImage = (UIImage *)info[UIImagePickerControllerEditedImage];
    NSURL *url = info[@"UIImagePickerControllerReferenceURL"];
    NSData *imgData = nil;
    
     [_bgIv setImage:editedImage];
    
    if ([[url description] hasSuffix:@"PNG"]) {
        
        imgData = UIImagePNGRepresentation(editedImage);
        
    }else {
        
        imgData = UIImageJPEGRepresentation(editedImage, 1.0);
    }
    
    
    BmobFile *file = [[BmobFile alloc]initWithFileName:@"bg.jpg" withFileData:imgData];
    
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            NSLog(@"更改背景成功");
            
            NSLog(@"%@",file.url);
            
            
            BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
            
            [query getObjectInBackgroundWithId:[BmobUser currentUser].objectId block:^(BmobObject *object, NSError *error) {
                
                [object setObject:file.url forKey:@"bgUrl"];
                
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        
                        NSLog(@"背景更新成功");
                        
                        [HUDUtils setupSuccessWithStatus:@"背景已更改" WithDelay:1.8f completion:nil];
                        
                    }else {
                        
                        [HUDUtils setupErrorWithStatus:@"背景设置失败" WithDelay:1.5f completion:nil];
                    }
                    
                    
                }];
                
            }];

            
        }else {
            
            NSLog(@"更改背景失败: ---- %@", error);
            
            [HUDUtils setupErrorWithStatus:@"背景设置失败" WithDelay:1.5f completion:nil];
        }
        
        
    } withProgressBlock:^(CGFloat progress) {
        
        NSLog(@"%lf",progress);
        
        [HUDUtils uploadImgWithProgress:progress status:@"正在设置背景" completion:^{
           
            
        }];
        
    }];

   
    [picker dismissViewControllerAnimated:YES completion:nil];
}



/**
 *  使用相册
 */

-(void)useAlbum {
    
    UIImagePickerController *imagePicker =self.imagePickerController;
    
    //允许编辑
    imagePicker.allowsEditing = true;
    //设置图片源
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //模态弹出IamgePickerView
    [self presentViewController:imagePicker animated:YES completion:nil];
}


/**
 *  使用相机
 */

-(void)userCamera {
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePicker = self.imagePickerController;
        
        //允许编辑
        imagePicker.allowsEditing=true;
        //设置图片源
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //模态弹出IamgePickerView
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }else{
        NSLog(@"模拟器不支持拍照功能");
    }
}

@end
