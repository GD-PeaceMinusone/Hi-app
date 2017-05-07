//
//  ContentTableViewCell.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/5/6.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "ContentTableViewCell.h"
#import "STPopupController.h"
#import "WSIMeDetailViewController.h"
#import "LYPhoto.h"
#import "LYPhotoBrowser.h"

@interface ContentTableViewCell ()
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headerIv;
/**昵称*/
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/**发表时间*/
@property (weak, nonatomic) IBOutlet UILabel *Time;
/**配图*/
@property (weak, nonatomic) IBOutlet UIImageView *contentIv;
/**配图文字*/
@property (weak, nonatomic) IBOutlet UILabel *content;
/**总赞数*/
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
/**心愿详情*/
@property (weak, nonatomic) IBOutlet UIButton *wishBt;
/**+1-1*/
@property (nonatomic,assign) NSInteger like;
/**vc*/
@property(nonatomic,strong) STPopupController *popupController;







@end

@implementation ContentTableViewCell
static NSString *notiName = @"pushVc";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupBt];
    [self setupIv];
}

-(void)setupBt {

    [_wishBt.layer setBorderWidth:1.0f];
    [_wishBt.layer setCornerRadius:4.0f];
    [_wishBt.layer setBorderColor:[UIColor colorWithRed:0/255.0 green:119/255.0 blue:254/255.0 alpha:1.0f].CGColor];
    
}

-(void)setupIv {

    [_headerIv circleHeader:_headerIv withBorderWidth:0 andBorderColor:nil];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
    
    _headerIv.userInteractionEnabled = YES;
    [_headerIv addGestureRecognizer:tapGr];

    _contentIv.userInteractionEnabled = YES;
    [_contentIv addGestureRecognizer:tapGr2];
}

-(void)tap2{
    
    LYPhoto *photo = [LYPhoto photoWithImageView:_contentIv placeHold:_contentIv.image photoUrl:nil];
    
    [LYPhotoBrowser showPhotos:@[photo] currentPhotoIndex:0 countType:LYPhotoBrowserCountTypeNone];
}


-(void)tap {
    
    [STPopupNavigationBar appearance].barTintColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:nil size:15], NSForegroundColorAttributeName: [UIColor whiteColor] };
    WSIMeDetailViewController *meVc = [WSIMeDetailViewController new];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:@[@(_headerIv.tag),meVc]];
    
    _popupController = [[STPopupController alloc] initWithRootViewController:meVc];
    _popupController.containerView.layer.cornerRadius = 3.0f;
    [_popupController presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    [_popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
}

-(void)backgroundViewDidTap {
    
    [self.popupController dismiss];
    
}

-(void)setAvObj:(WishModel *)avObj {

    _avObj = avObj;
    
    [_content setText:avObj.comment]; //设置配图内容
    
    [_Time setText:avObj.createdAt]; //设置发表时间
    
    NSURL *url = [NSURL URLWithString:avObj.picUrl];
    
    [_contentIv sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:_avObj.user.objectId block:^(BmobObject *object, NSError *error) {
        
        NSString *headStr = [object objectForKey:@"userHeader"];
        
        [_headerIv sd_setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
        
        [_nickName setText:[object objectForKey:@"nickName"]]; //设置昵称
        
    }];
    
    
    //查询对应状态的总赞数
    
    BmobQuery *allQuery = [BmobQuery queryWithClassName:@"Praise"];
    
    [allQuery whereKey:@"comment" equalTo:_avObj.avObj];
    
    [allQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        
        _like = number;
        [_likeCount setText:[NSString stringWithFormat:@"%d", number]];
        
    }];
 
}






















@end
