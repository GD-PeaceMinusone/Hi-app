//
//  WSISettingViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/26.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSISettingViewController.h"
#import "UIViewController+SelectPhotoIcon.m"
#import "SettingNaviBarView.h"
#import "SRActionSheet.h"
#import "Bmob.h"
#import "BBInput.h"
#import <UIImageView+WebCache.h>
#import "ListObject.h"

@interface WSISettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SettingNaviBarView *barView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIImageView *headerIv;
@property(nonatomic,strong)UITableViewCell *nickCell;
@property(nonatomic,strong)UITableViewCell *signCell;
@end

@implementation WSISettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _barView = [SettingNaviBarView createNaviBarViewFromXIB];
    [self replaceNaviBarView:_barView];
  
}

-(void)viewWillAppear:(BOOL)animated {
    
    [_headerIv sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"headerPath"]] placeholderImage:nil];
}

#pragma mark - 懒加载


-(UIButton *)button {

    if (!_button) {
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"退出登录" forState:UIControlStateNormal];
        [_button setTitleColor:blueColor forState:UIControlStateNormal];
        [_button setFrame:CGRectMake(0, 12, 100, 40)];
        [_button addTarget:self action:@selector(leaveAccount) forControlEvents:UIControlEventTouchUpInside];
        _button.xmg_centerX = _tableView.xmg_centerX;
    }
    
    return _button;
}

/**
 *  退出当前账户
 */

-(void)leaveAccount {

    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                cancelTitle:@"取消"
                                                                destructiveTitle:nil
                                                                otherTitles:@[@"确认退出"]
                                                                otherImages:nil
                                                           selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                                                               
                                                               if (index == 0) {
                                                                   
                                                                   [AVUser logOut];
                                                                   
                                                                   [HUDUtils setupSuccessWithStatus:@"已退出" WithDelay:1.8f completion:^{
                                                                       
                                                                    [[UIViewController getNavi] popToRootViewControllerAnimated:YES];
                                                                       
                                                                   }];
                                                               }
                                                               
                                                           }];
    
    [actionSheet show];
}

/**
 *   手势方法
 */

-(void)tap {

    
}


#pragma mark - delegate && source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 3;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        
        if (indexPath.section == 0)
        {
            switch (indexPath.row) {
                case 0: //头像
                {
                    cell.textLabel.text = @"头像";
                    
                    UIImage *image = [UIImage imageWithIconName:@"header" borderImage:nil border:0];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
                    
                    _headerIv = [[UIImageView alloc]initWithImage:image];
                    
                    [_headerIv sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"headerPath"]] placeholderImage:nil];
                    
                    _headerIv.userInteractionEnabled = YES;
                    
                    [_headerIv addGestureRecognizer:tap];
                    
                    [cell.contentView addSubview:_headerIv];
                    
                    [_headerIv mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.size.mas_equalTo(CGSizeMake(40, 40));
                        make.top.equalTo(cell.mas_top).with.offset(10);
                        make.right.equalTo(cell.mas_right).with.offset(-28);
                    }];
                    
                }
                    break;
                case 1: //昵称
                {
                    cell.textLabel.text = @"昵称";
                    _nickCell = cell;
                }
                    break;
                case 2: //签名
                {
                    cell.textLabel.text = @"签名";
                    _signCell = cell;
                }
                    break;
                    
                default:
                    break;
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        else if (indexPath.section == 1)
        {
            switch (indexPath.row) {
                case 0: //退出登录
                {
                         
                    [cell addSubview:self.button];
             
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 13;
    }
    return 15;
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0: //头像
            {
                
                SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                            cancelTitle:@"取消"
                                                                       destructiveTitle:nil
                                                                            otherTitles:@[@"相机",@"从手机相册选择"]
                                                                            otherImages:nil
                                                                       selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                                                                           
                                                                           if (index == 0) {
                                                                               
                                                                   
                                                                               [self useCamera];
                                                                               
                                                                           }else {
                                                                           
                                                                               [self useAlbum];
                                                                           }
                                                                           
                                                                       }];
                
                [actionSheet show];
           
            }
                break;
            case 1: //昵称
            {
     
                [self updateNickName];
      
            }
                break;
            case 2: //签名
            {
               
                [self updateSignName];
                
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 编辑资料


/**
 *  修改头像
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;{
    
    //获得编辑后的图片
    UIImage *editedImage = (UIImage *)info[UIImagePickerControllerEditedImage];
    NSURL *url = info[@"UIImagePickerControllerReferenceURL"];
    NSData *imgData = nil;
    
    UIImage *image = [UIImage imageWithIcon:editedImage borderImage:nil Border:0];
    
    if ([[url description] hasSuffix:@"PNG"]) {
        
        imgData = UIImagePNGRepresentation(image);
        
    }else {
        
        imgData = UIImageJPEGRepresentation(image, 1.0);
        
    }
    
    
    AVFile *file = [AVFile fileWithName:@"header.jpg" data:imgData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            
            NSLog(@"上传头像成功");
            
            NSLog(@"%@",file.url);

            [[AVUser currentUser] setObject:file.url forKey:@"userHeader"];
            
            [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded) {
                    
                    NSLog(@"头像更新成功");
                    
                    [HUDUtils setupSuccessWithStatus:@"头像上传成功" WithDelay:1.8f completion:nil];
                    
                }else {
                
                    [HUDUtils setupErrorWithStatus:@"设置头像失败" WithDelay:1.5f completion:nil];
                }
                
            }];
            
        }else {
            
            NSLog(@"上传头像失败: ---- %@", error);
            
            [HUDUtils setupErrorWithStatus:@"头像上传失败" WithDelay:1.5f completion:nil];
        }
        
    } progressBlock:^(NSInteger percentDone) {
        
        NSLog(@"%lf",percentDone/100.0);
        
        [HUDUtils uploadImgWithProgress:percentDone/100.0 status:@"头像上传中.." completion:nil];
        
    }];

    _headerIv.image = image;

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


/**
 *   修改昵称
 */
-(void)updateNickName{
    
    [BBInput setDescTitle:@"请输入昵称"];
    [BBInput setMaxContentLength:10];
    [BBInput setNormalContent:_nickCell.detailTextLabel.text];
    [BBInput showInput:^(NSString *inputContent) {
        
        _nickCell.detailTextLabel.text = inputContent;
        
        [User getCurrentUser].nickName = inputContent;
        [[User getCurrentUser] update];
        
        [self.tableView reloadData];
        
    }];
    
}

/**
 *  修改签名
 */

-(void)updateSignName{
    
    [BBInput setDescTitle:@"请输入签名"];
    [BBInput setMaxContentLength:20];
    [BBInput setNormalContent:_signCell.detailTextLabel.text];
    [BBInput showInput:^(NSString *inputContent) {
        
        _signCell.detailTextLabel.text = inputContent;
        [User getCurrentUser].sign = inputContent;
        [[User getCurrentUser] update];
        [self.tableView reloadData];
        
    }];
    
}


@end
