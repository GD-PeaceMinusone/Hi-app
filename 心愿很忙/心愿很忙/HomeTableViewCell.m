//
//  HomeTableViewCell.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/21.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "HomeTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <SRActionSheet.h>
#import "LYPhoto.h"
#import "LYPhotoBrowser.h"
#import <STPopup/STPopup.h>
#import "WSIMeDetailViewController.h"
#import "WSIHomeTableViewController.h"


@interface HomeTableViewCell ()

@property(nonatomic,strong)STPopupController *popupController;

@end


@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    [self addGesture];
    [self.headerIv circleHeader:self.headerIv withBorderWidth:0 andBorderColor:nil];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}




/**
 *  点击查看大图
 */

-(void)addGesture {

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
     UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    [self.headerIv addGestureRecognizer:tapGr];
    self.headerIv.userInteractionEnabled = YES;
    self.headerIv.tag = 2;
    
    self.thingIv.userInteractionEnabled = YES;
    [self.thingIv addGestureRecognizer:tapGr2];
    self.thingIv.tag = 1;
   
}

-(void)tap:(UITapGestureRecognizer*)tap {
  
    switch (tap.view.tag) {
            
        case 1:
        {
            LYPhoto *photo = [LYPhoto photoWithImageView:self.thingIv placeHold:self.thingIv.image photoUrl:nil];
            
            [LYPhotoBrowser showPhotos:@[photo] currentPhotoIndex:0 countType:LYPhotoBrowserCountTypeNone];
        }
            break;
            
        case 2:
            
        {
            [STPopupNavigationBar appearance].barTintColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
            [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
            [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:nil size:15], NSForegroundColorAttributeName: [UIColor whiteColor] };
           
            
            WSIMeDetailViewController *meVc = [WSIMeDetailViewController new];
            self.popupController = [[STPopupController alloc] initWithRootViewController:meVc];
            self.popupController.containerView.layer.cornerRadius = 4.0f;
            
            
            [self.popupController presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            
            [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            
           
            
        }
            break;
            
        default:
            break;
    }
    
}

/**
 *  点击视图销毁
 */

-(void)backgroundViewDidTap {
    
    [self.popupController dismiss];
    
}


/**
 *  设置cell上的数据
 */
-(void)setItObj:(ListObject *)itObj {
    
    _itObj = itObj;
    
    self.contentLabel.text = itObj.thingContent;
   
    NSURL *url = [NSURL URLWithString:itObj.thingPath];
    NSLog(@"1111");
    [self.thingIv sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
      
    }];
   
}

/**
 *  重写这个方法的目的: 能够拦截所有设置cell frame的操作
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= WSIMargin;
    frame.origin.y += WSIMargin;
    frame.size.width -= WSIMargin *2;
    frame.origin.x += WSIMargin;
    
    [super setFrame:frame];
}

/**
 *  弹出选择菜单
 */
- (IBAction)giftButton:(id)sender {
 
    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:@"选择"
        cancelTitle:@"取消"
        destructiveTitle:nil
        otherTitles:@[@"查看详情", @"帮她/他实现心愿"]
        otherImages:nil
        selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
            }];
    
    [actionSheet show];
  
    
}




@end
