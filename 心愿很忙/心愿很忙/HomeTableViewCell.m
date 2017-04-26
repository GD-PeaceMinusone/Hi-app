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
#import <DACircularProgressView.h>
#import <REFrostedViewController.h>
#import <WebKit/WebKit.h>
#import "WSIThingViewController.h"

#define ifHTTP !([link rangeOfString:@"http"].location == NSNotFound)
#define ifType(type) !([self.itObj.link rangeOfString:type].location == NSNotFound)
@interface HomeTableViewCell ()<WKNavigationDelegate>

@property(nonatomic,strong) STPopupController *popupController;
@property(nonatomic,strong) DACircularProgressView *progressView;
@property (nonatomic,assign) NSInteger progress;
@property(nonatomic,strong) NSString *wishLink;
@end


@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    [self addGesture];
    [self.headerIv circleHeader:self.headerIv withBorderWidth:0 andBorderColor:nil];
    [self addProgress];
    
    //让cell 不响应点击事件
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



/**
 *  图片加载进度
 */

-(void)addProgress {

   
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
            
            switch (index) {
                case 0:{
 
                    [self getLink];

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


-(void)getLink {
    
    if (ifType(@"手机淘宝")) {//为淘宝链接
        
        if (!([self.itObj.link rangeOfString:@"http"].location == NSNotFound)) {
            
            self.wishLink = [self taobaoLinkWithHttp:@"http"];
            
        }else {
        
            self.wishLink = [self taobaoLinkWithHttp:@"https"];
        }
        

        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.wishLink] options:@{} completionHandler:nil];
        
    }else if(ifType(@"tm=")) {//天猫链接
        
        [self openWithTitle:@"taobao"];
        
    }else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"link" object:self.itObj.link];
        NSLog(@"1111");
        REFrostedViewController*vc = (REFrostedViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        UITabBarController *tabBarVc =(UITabBarController*) vc.contentViewController;
        
        
        WSIThingViewController *thingVc = [WSIThingViewController new];
        [tabBarVc.selectedViewController pushViewController:thingVc animated:YES];
        
    }
 
}


/**
 *  淘宝链接判断
 */

-(NSString*)taobaoLinkWithHttp:(NSString*)http {
    
    NSString *link = self.itObj.link;
    NSRange startRange = [link rangeOfString:@"打开"];
    NSRange endRange = [link rangeOfString:@"，或"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *resultStr = [link substringWithRange:range];
    NSString *wishStr = [resultStr stringByReplacingOccurrencesOfString:http withString:@"taobao"];
    
    return wishStr;
}

/**
 *  其他链接判断
 */

-(void)openWithTitle: (NSString*)title {

    NSString *link = self.itObj.link;
    
    if (ifHTTP) {
        
        NSString *wishStr = [link stringByReplacingOccurrencesOfString:@"http" withString:title];
        self.wishLink = wishStr;
        
    }else {
        
        NSString *wishStr = [link stringByReplacingOccurrencesOfString:@"https" withString:title];
        self.wishLink = wishStr;
    }
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.wishLink] options:@{} completionHandler:nil];
    

}

@end
