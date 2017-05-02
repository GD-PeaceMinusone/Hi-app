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
#import <DACircularProgressView.h>
#import <REFrostedViewController.h>
#import <WebKit/WebKit.h>
#import "WSIThingViewController.h"
#import <UIImageView+WebCache.h>

#define ifHTTP !([link rangeOfString:@"http"].location == NSNotFound)
#define ifType(type) !([self.itObj.link rangeOfString:type].location == NSNotFound)
@interface HomeTableViewCell ()<WKNavigationDelegate>
/**个人简介*/
@property(nonatomic,strong) STPopupController *popupController;
/***/
@property(nonatomic,strong) DACircularProgressView *progressView;
/***/
@property (nonatomic,assign) NSInteger progress;
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

@end


@implementation HomeTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headerIv circleHeader:self.headerIv withBorderWidth:0 andBorderColor:nil];
    [self setupContentLabel];
    [self addGesture];

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
    
    UILabel *label=( UILabel *)[self.window viewWithTag: 1];
    
    label.backgroundColor = [UIColor colorWithRed:38/255.0 green:202/255.0 blue:202/255.0 alpha:1.0f];
    
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
    
    [self.headerIv addGestureRecognizer:tapGr2];
    self.headerIv.userInteractionEnabled = YES;
    
    self.thingIv.userInteractionEnabled = YES;
    [self.thingIv addGestureRecognizer:tapGr];
   
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
    
    
    NSString *notiName = @"pushVc";
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:@[@(_headerIv.tag),meVc]];
    
    self.popupController = [[STPopupController alloc] initWithRootViewController:meVc];
    self.popupController.containerView.layer.cornerRadius = 4.0f;
    [self.popupController presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
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


-(void)setAvObj:(AVObject *)avObj {

    _avObj = avObj;
    
    _contentLabel.text = [avObj objectForKey:@"content"];
    
    NSURL *url = [NSURL URLWithString:[avObj objectForKey:@"picUrl"]];
    
    [_thingIv sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
    
    AVUser *user = [avObj objectForKey:@"wishUser"];
    
    
    [user fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        
        NSString *headerStr = [object objectForKey:@"userHeader"];
        
        NSURL *headerUrl = [NSURL URLWithString:headerStr];
        
        [_headerIv sd_setImageWithURL:headerUrl placeholderImage:[UIImage imageNamed:@"头像 (22)"]];
        [_nickName setText:[object objectForKey:@"nickName"]];
    }];
    
    AVQuery *startDateQuery = [AVQuery queryWithClassName:@"Praise"];
    [startDateQuery whereKey:@"beStarUser" equalTo:[_avObj objectForKey:@"wishUser"]];
    
    AVQuery *endDateQuery = [AVQuery queryWithClassName:@"Praise"];
    [endDateQuery whereKey:@"comment" equalTo:_avObj];
    
    AVQuery *query = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:startDateQuery,endDateQuery,nil]];
    
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError * _Nullable error) {
        
        [_likeCount setText:[NSString stringWithFormat:@"%ld",number]];
        
    }];

}

/**实现点赞功能*/
- (IBAction)wclButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
  
    AVQuery *startDateQuery = [AVQuery queryWithClassName:@"Praise"];
    [startDateQuery whereKey:@"starUser" equalTo:[AVUser currentUser]];
    
    AVQuery *endDateQuery = [AVQuery queryWithClassName:@"Praise"];
    [endDateQuery whereKey:@"comment" equalTo:_avObj];
    
    AVQuery *query = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:startDateQuery,endDateQuery,nil]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
       
        if (results.count == 0) {
            
            AVObject *obj = [AVObject objectWithClassName:@"Praise"];
            
            [obj setObject:[AVUser currentUser] forKey:@"starUser"];
            [obj setObject:_avObj forKey:@"comment"];
            [obj setObject:[_avObj objectForKey:@"wishUser"] forKey:@"beStarUser"];
            
            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded) {
                    
                    NSLog(@"点赞成功");
                    
                }else {
                    
                    NSLog(@"点赞失败");
                }
                
            }];
            
        }else {
        
            [results[0] deleteInBackground];
        }
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
