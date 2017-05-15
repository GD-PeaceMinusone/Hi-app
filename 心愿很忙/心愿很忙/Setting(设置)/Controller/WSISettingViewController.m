//
//  WSISettingViewController.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/26.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "WSISettingViewController.h"
#import "UIViewController+SelectPhotoIcon.m"
#import "SRActionSheet.h"
#import "BBInput.h"
#import <UIImageView+WebCache.h>

@interface WSISettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIImageView *headerIv;
@property(nonatomic,strong)UITableViewCell *nickCell;
@property(nonatomic,strong)UITableViewCell *signCell;
@property(nonatomic,strong)UIButton *leftBt;
@property(nonatomic,strong)UIBarButtonItem *left;
@end

@implementation WSISettingViewController

-(UIButton *)leftBt {
    
    if (!_leftBt) {
        
        _leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _leftBt.frame = CGRectMake(0, 0, 25, 25);
        [_leftBt setImage:[UIImage imageNamed:@"返回 (3)"] forState:UIControlStateNormal];
        
    }
    
    return _leftBt;
}


-(UIBarButtonItem *)left {
    
    if (!_left) {
        
        _left = [[UIBarButtonItem alloc]initWithCustomView:self.leftBt];
        
    }
    
    return _left;
}

-(void)back {

    [[UIViewController getNavi] popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavi];
    _headerIv.contentMode = UIViewContentModeScaleAspectFill;
    _headerIv.clipsToBounds = YES;
    
}

-(void)setupNavi {

    self.navigationItem.leftBarButtonItem = self.left;
    self.navigationItem.title = @"设置";
    
}


-(void)viewWillAppear:(BOOL)animated {

    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:[BmobUser currentUser].objectId block:^(BmobObject *object, NSError *error) {
        
        NSString *sign = [object objectForKey:@"sign"];
        [_signCell.detailTextLabel setText:sign];
        
        NSString *nickName = [object objectForKey:@"nickName"];
        [_nickCell.detailTextLabel setText:nickName];
        
        NSString *head = [object objectForKey:@"userHeader"];
        [_headerIv sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
    }];
    
    
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
                                                                   
                                                                   [BmobUser logout];
                                                               
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
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        if (indexPath.section == 0)
        {
            switch (indexPath.row) {
                case 0: //头像
                {
                    cell.textLabel.text = @"头像";
              
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
                    
                    _headerIv = [[UIImageView alloc]initWithRoundingRectImageView];
                    
                    _headerIv.image = [UIImage imageNamed:@"头像 (22)"];
                    
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
                
                SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:@"更改头像"
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
    
    _headerIv.image = editedImage;
    
    if ([[url description] hasSuffix:@"PNG"]) {
        
        imgData = UIImagePNGRepresentation(editedImage);
        
    }else {
        
        imgData = UIImageJPEGRepresentation(editedImage, 1.0);

    }
    
    BmobFile *file = [[BmobFile alloc]initWithFileName:@"header.jpg" withFileData:imgData];
    
    [file saveInBackgroundByDataSharding:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            NSLog(@"上传头像成功");
            
            NSLog(@"%@",file.url);
            
            BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
            
            [query getObjectInBackgroundWithId:[BmobUser currentUser].objectId block:^(BmobObject *object, NSError *error) {
                
                [object setObject:file.url forKey:@"userHeader"];
                
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        
                        NSLog(@"头像更新成功");
                        
                        [HUDUtils setupSuccessWithStatus:@"头像上传成功" WithDelay:1.8f completion:nil];
                        
                    }else {
                        
                        [HUDUtils setupErrorWithStatus:@"设置头像失败" WithDelay:1.5f completion:nil];
                    }
                    
                    
                }];
                
            }];
            
            
            
        }else {
            
            NSLog(@"上传头像失败: ---- %@", error);
            
            [HUDUtils setupErrorWithStatus:@"头像上传失败" WithDelay:1.5f completion:nil];
        }
        

        
        
    } progressBlock:^(CGFloat progress) {
        
        NSLog(@"%lf",progress);
        
        [HUDUtils uploadImgWithProgress:progress status:@"头像上传中.." completion:nil];
        
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


/**
 *   修改昵称
 */
-(void)updateNickName{
    
    [BBInput setDescTitle:@"请输入昵称"];
    [BBInput setMaxContentLength:20];
    [BBInput setNormalContent:_nickCell.detailTextLabel.text];
    [BBInput showInput:^(NSString *inputContent) {
        
        _nickCell.detailTextLabel.text = inputContent;
        
        BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
        
        [query getObjectInBackgroundWithId:[BmobUser currentUser].objectId block:^(BmobObject *object, NSError *error) {
            
            [object setObject:inputContent forKey:@"nickName"];
            [object updateInBackground];
            
        }];
  
    
        [self.tableView reloadData];
        
    }];
    
}

/**
 *  修改签名
 */

-(void)updateSignName{
    
    [BBInput setDescTitle:@"请输入签名"];
    [BBInput setMaxContentLength:30];
    [BBInput setNormalContent:_signCell.detailTextLabel.text];
    [BBInput showInput:^(NSString *inputContent) {
        
        _signCell.detailTextLabel.text = inputContent;
        
        BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
        
        [query getObjectInBackgroundWithId:[BmobUser currentUser].objectId block:^(BmobObject *object, NSError *error) {
            
            [object setObject:inputContent forKey:@"sign"];
            [object updateInBackground];
          
        }];
  
        [self.tableView reloadData];
        
    }];
    
}


@end
