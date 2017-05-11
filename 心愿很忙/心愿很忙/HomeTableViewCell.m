//
//  HomeTableViewCell.m
//  心愿很忙
//
//  Created by Jackeylove on 2017/4/21.
//  Copyright © 2017年 Jackeylove. All rights reserved.
//

#import "HomeTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SRActionSheet.h"
#import "LYPhoto.h"
#import "LYPhotoBrowser.h"
#import <STPopup/STPopup.h>
#import "WSIMeDetailViewController.h"
#import "WSIHomeTableViewController.h"
#import <REFrostedViewController.h>
#import <WebKit/WebKit.h>
#import "WSIThingViewController.h"
#import "WclEmitterButton.h"
#import <UShareUI/UShareUI.h>
#import "WSILoginViewController.h"
#import "REFrostedViewController.h"
#import "WSICommentViewController.h"


#define ifHTTP !([link rangeOfString:@"http"].location == NSNotFound)
#define ifType(type) !([self.itObj.link rangeOfString:type].location == NSNotFound)
@interface HomeTableViewCell ()<WKNavigationDelegate>
/**个人简介*/
@property(nonatomic,strong) STPopupController *popupController;

/**宝贝链接*/
@property(nonatomic,strong)  NSString *wishLink;
/**赞*/
@property (weak, nonatomic) IBOutlet UILabel *likeAmount;
/**评论*/
@property (weak, nonatomic) IBOutlet UILabel *commentAmount;
/**昵称*/
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/**发表时间*/
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
/**总赞数*/
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
/**总评论数*/
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
/**+1-1*/
@property (nonatomic,assign) NSInteger like;
/**点赞按钮*/
@property (weak, nonatomic) IBOutlet WclEmitterButton *starBt;
/**date*/
@property(nonatomic,strong)NSDate *date;
/**vc*/
@property(nonatomic,strong)WSICommentViewController *commentVc;
@end


@implementation HomeTableViewCell
static NSString *notiName = @"pushVc";
static NSString *notiName2 = @"comment";
static NSString *notiName3 = @"changeTabbar";
static NSDateFormatter *fmt_;
static NSCalendar *calendar_;

-(WSICommentViewController *)commentVc {

    if (!_commentVc) {
        
        _commentVc =[[WSICommentViewController alloc]init];
    }
    
    return _commentVc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_headerIv circleHeader:self.headerIv withBorderWidth:0 andBorderColor:nil];
    [self setupContentLabel];
    [self addGesture];
    
    [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(checkingUnRead) userInfo:nil repeats:YES];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query getObjectInBackgroundWithId:_avObj.user.objectId block:^(BmobObject *object, NSError *error) {
        
        NSString *headStr = [object objectForKey:@"userHeader"];
        
        [_headerIv sd_setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
        
        [_nickName setText:[object objectForKey:@"nickName"]]; //设置昵称
        
    }];


}


/**
 *  实现label长按复制
 */

-(void)setupContentLabel {
    
     //让cell 不响应点击事件
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    longPress.minimumPressDuration = 0.5;
    
    [_contentLabel addGestureRecognizer:longPress];
}


-(BOOL)canBecomeFirstResponder {

    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    return action == @selector(customCopy:);
}

- (void)customCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contentLabel.text;
    
}

- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    
    [self becomeFirstResponder];
   
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(customCopy:)];
    
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}


/**
 *  点击查看大图
 */

-(void)addGesture {

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
    
     _headerIv.userInteractionEnabled = YES;
    [_headerIv addGestureRecognizer:tapGr2];
   
    _thingIv.userInteractionEnabled = YES;
    [_thingIv addGestureRecognizer:tapGr];
   
}

-(void)tap{

    LYPhoto *photo = [LYPhoto photoWithImageView:self.thingIv placeHold:self.thingIv.image photoUrl:nil];
            
    [LYPhotoBrowser showPhotos:@[photo] currentPhotoIndex:0 countType:LYPhotoBrowserCountTypeNone];
}

-(void)tap2 {
    
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


/**点击视图销毁*/

-(void)backgroundViewDidTap {
    
    [self.popupController dismiss];
    
}

/**删除和分享*/

- (IBAction)shareAction:(id)sender {
    
    BmobUser *user = _avObj.user;
    
    if ([user.objectId isEqualToString:[BmobUser currentUser].objectId]) {
        
        SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                    cancelTitle:@"删除"
                                                               destructiveTitle:nil
                                                                    otherTitles:@[@"分享"]
                                                                    otherImages:nil
                                                               selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
                                                                   
                                                                   if (index == 0) {
                                                                       
                                                                       
                                                                       
                                                                       
                                                                   }else if(index == 1) {
                                                                       
                                                                       
                                                                       
                                                                   }else {
                                                                       
                                                                   }
                                                                   
                                                               }];
        
        [actionSheet show];
        
    }else {
    
        [self shareWithUI];
    }
    
    
}


/**
 *  设置cell上的数据
 */


-(void)setAvObj:(WishModel *)avObj {

    _avObj = avObj;
    
    [_contentLabel setText:avObj.comment]; //设置配图内容
    
    [_currentTime setText:avObj.createdAt]; //设置发表时间
    
    NSURL *url = [NSURL URLWithString:avObj.picUrl];

    [_thingIv sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
    
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
    
    
    //判断当前状态是否被当前用户赞过 如果赞过 则无论何时图标都显示selected状态
    
    BmobQuery *query1 = [BmobQuery queryWithClassName:@"Praise"];
    
    [query1 whereKey:@"starUser" equalTo:[BmobUser currentUser]];
    
    BmobQuery *query2 = [BmobQuery queryWithClassName:@"Praise"];
    
    [query2 whereKey:@"comment" equalTo:_avObj.avObj];
    
    BmobQuery *addQuery = [BmobQuery queryWithClassName:@"Praise"];
    
    [addQuery add:query1];
    
    [addQuery add:query2];
    
    [addQuery andOperation];
    
    [addQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count == 0) {
            
            _starBt.selected = NO;
            
        }else {
        
            _starBt.selected = YES;
        }
        
        
    }];

}


/**实现点赞功能*/
- (IBAction)wclButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (![BmobUser currentUser]) {
        
        WSILoginViewController *loginVc = [WSILoginViewController new];
        
        REFrostedViewController *vc = (REFrostedViewController*) [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [vc presentViewController:loginVc animated:YES completion:nil];
      
        return;
    }
    
    /**构建查询条件 如已点过赞 将不再增加数据 并将该条数据从后台delete*/

    BmobQuery *query1 = [BmobQuery queryWithClassName:@"Praise"];
    
    [query1 whereKey:@"starUser" equalTo:[BmobUser currentUser]];
    
    BmobQuery *query2 = [BmobQuery queryWithClassName:@"Praise"];
    
    [query2 whereKey:@"comment" equalTo:_avObj.avObj];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Praise"];
    
    [query add:query1];
    
    [query add:query2];
    
    [query andOperation];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count == 0) {
            
            BmobObject *obj = [BmobObject objectWithClassName:@"Praise"];
            
            [obj setObject:[BmobUser currentUser] forKey:@"starUser"];
            [obj setObject:_avObj.avObj forKey:@"comment"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
 
                    if (isSuccessful) {
                        
                        NSLog(@"点赞成功");
                        [_likeCount setText:[NSString stringWithFormat:@"%ld", _like + 1]];
                        _like += 1;
      
                }else {
                    
                    NSLog(@"点赞失败---%@", error);
                    
                }
          
            }];


        }else {
            
            NSLog(@"已经赞过");
            [array[0] deleteInBackground];
            [_likeCount setText:[NSString stringWithFormat:@"%ld", _like - 1]];
            _like -= 1;
        }
        
        
    }];
    

}


- (IBAction)commentBt:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName2 object:@[@(_headerIv.tag),self.commentVc]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName3 object:nil];

    [[UIViewController getNavi] pushViewController:self.commentVc animated:YES];
}

-(void)checkingUnRead {

    [_currentTime setText:_avObj.createdAt];
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
            
            switch (index) {
                case 0:{
 
//                    [self getLink];

                }
                    break;
                    
                case 1:
                    
                    NSLog(@"2");
                    
                    break;
                    
                default:
                    break;
            }
            
            }];
    
    [actionSheet show];
  
    
}

- (void)shareWithUI {
    
//    UIImage *headerImg  = [UIImage imageNamed:@"header"];
//    
//    UIImage *image = [self imageAddText:_contetnIv.image withName:@"我想想还是不结婚了" andHeader:headerImg];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        
        switch (platformType) {
            case UMSocialPlatformType_QQ:
                
            {
                [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106117908"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
                
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                
                messageObject.text = _contentLabel.text;
                //创建图片内容对象
                UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                //如果有缩略图，则设置缩略图
                shareObject.thumbImage = [UIImage imageNamed:@"header"];
                
//                [shareObject setShareImage:image];
                
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ  messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        NSLog(@"response data is %@",data);
                    }
                }];
            }
                break;
                
            case UMSocialPlatformType_Sina:
                
            {
                
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                
                messageObject.text = _contentLabel.text;
                //创建图片内容对象
                UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                //如果有缩略图，则设置缩略图
                shareObject.thumbImage = [UIImage imageNamed:@"header"];
                
//                [shareObject setShareImage:image];
                
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina  messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        NSLog(@"response data is %@",data);
                    }
                }];
                
            }
                break;
                
            case UMSocialPlatformType_WechatTimeLine:
                
            {
                
                
            }
                break;
                
            default:
                break;
        }
        
        
        
        
        
        
        
        
        
    }];//显示分享面板
    
    
    
}

/**
 *  判断链接地址 打开不同链接对应的app 没有就加载本地的WKWebView
 */


//-(void)getLink {
//    
//    if (ifType(@"手机淘宝")) {//为淘宝链接
//        
//        if (!([self.itObj.link rangeOfString:@"http"].location == NSNotFound)) {
//            
//            self.wishLink = [self taobaoLinkWithHttp:@"http"];
//            
//        }else {
//        
//            self.wishLink = [self taobaoLinkWithHttp:@"https"];
//        }
//        
//
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.wishLink] options:@{} completionHandler:nil];
//        
//    }else if(ifType(@"tm=")) {//天猫链接
//        
//        [self openWithTitle:@"taobao"];
//        
//    }else {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"link" object:self.itObj.link];
//        NSLog(@"1111");
//        REFrostedViewController*vc = (REFrostedViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//        UITabBarController *tabBarVc =(UITabBarController*) vc.contentViewController;
//        
//        
//        WSIThingViewController *thingVc = [WSIThingViewController new];
//        [tabBarVc.selectedViewController pushViewController:thingVc animated:YES];
//        
//    }
// 
//}
//
//
///**
// *  淘宝链接判断
// */
//
//-(NSString*)taobaoLinkWithHttp:(NSString*)http {
//    
//    NSString *link = self.itObj.link;
//    NSRange startRange = [link rangeOfString:@"打开"];
//    NSRange endRange = [link rangeOfString:@"，或"];
//    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
//    NSString *resultStr = [link substringWithRange:range];
//    NSString *wishStr = [resultStr stringByReplacingOccurrencesOfString:http withString:@"taobao"];
//    
//    return wishStr;
//}
//
///**
// *  其他链接判断
// */
//
//-(void)openWithTitle: (NSString*)title {
//
//    NSString *link = self.itObj.link;
//    
//    if (ifHTTP) {
//        
//        NSString *wishStr = [link stringByReplacingOccurrencesOfString:@"http" withString:title];
//        self.wishLink = wishStr;
//        
//    }else {
//        
//        NSString *wishStr = [link stringByReplacingOccurrencesOfString:@"https" withString:title];
//        self.wishLink = wishStr;
//    }
//    
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.wishLink] options:@{} completionHandler:nil];
//    
//
//}

@end
