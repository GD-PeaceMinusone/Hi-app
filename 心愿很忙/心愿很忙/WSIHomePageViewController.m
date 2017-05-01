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
#import "EditingNaviBarView.h"
#import "SCAvatarBrowser.h"
#import "SRActionSheet.h"
#import <UIImageView+WebCache.h>

@interface WSIHomePageViewController ()
@property (nonatomic, strong) EditingNaviBarView *barView;
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

@end

@implementation WSIHomePageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _barView = [EditingNaviBarView createNaviBarViewFromXIB];
    [self replaceNaviBarView:_barView];
    
    [self setupHeaderIv];
    [self setupBgIv];
}

-(void)viewWillAppear:(BOOL)animated {

    [[AVUser currentUser] fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        
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

    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
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
    
     _bgIv.image = editedImage;
    
    if ([[url description] hasSuffix:@"PNG"]) {
        
        imgData = UIImagePNGRepresentation(editedImage);
        
    }else {
        
        imgData = UIImageJPEGRepresentation(editedImage, 1.0);
    }
    
    
    AVFile *file = [AVFile fileWithName:@"header.jpg" data:imgData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            
            NSLog(@"更改背景成功");
            
            NSLog(@"%@",file.url);
            
            [[AVUser currentUser] setObject:file.url forKey:@"bgUrl"];
            
            [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded) {
                    
                    NSLog(@"背景更新成功");
                    
                    [HUDUtils setupSuccessWithStatus:@"背景已更改" WithDelay:1.5f completion:nil];
                    
                }else {
                    
                    [HUDUtils setupErrorWithStatus:@"背景设置失败" WithDelay:1.5f completion:nil];
                }
                
            }];
            
        }else {
            
            NSLog(@"更改背景失败: ---- %@", error);
            
            [HUDUtils setupErrorWithStatus:@"背景设置失败" WithDelay:1.5f completion:nil];
        }
        
    } progressBlock:^(NSInteger percentDone) {
        
        NSLog(@"%lf",percentDone/100.0);
        
        [HUDUtils uploadImgWithProgress:percentDone/100.0 status:@"正在设置背景.." completion:nil];
        
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
